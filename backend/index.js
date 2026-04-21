const express = require("express");
const cors = require("cors");
const app = express();

app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));

app.use(express.json());

const admin = require("firebase-admin");

const FIREBASE_PROJECT_ID = process.env.FIREBASE_PROJECT_ID || "mygov-ai";
const FIREBASE_STORAGE_BUCKET =
  process.env.FIREBASE_STORAGE_BUCKET || "mygov-ai.firebasestorage.app";

const SEARCH_PROJECT_ID = process.env.SEARCH_PROJECT_ID || "mygov-ai";
const LOCATION = process.env.SEARCH_LOCATION || "global";
const DATA_STORE_ID =
  process.env.DATA_STORE_ID || "mygov-gcs-connector_1776179121278";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: FIREBASE_PROJECT_ID,
  storageBucket: FIREBASE_STORAGE_BUCKET,
});

const { genkit } = require("genkit");
const { googleAI } = require("@genkit-ai/googleai");

const ai = genkit({
  plugins: [googleAI()],
  model: "googleai/gemini-1.5-flash",
});

const { SearchServiceClient } = require("@google-cloud/discoveryengine");

const client = new SearchServiceClient();

const bucket = admin.storage().bucket();
const db = admin.firestore();
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });

async function searchDocs(query) {
  const servingConfig = `projects/${SEARCH_PROJECT_ID}/locations/${LOCATION}/collections/default_collection/dataStores/${DATA_STORE_ID}/servingConfigs/default_serving_config`;

  const request = {
    servingConfig,
    query,
    pageSize: 3,
  };

  const [response] = await client.search(request);

  let resultsText = "";

  response.results.forEach((result, i) => {
    const doc = result.document;

    resultsText += `Result ${i + 1}:\n`;
    resultsText += doc.derivedStructData?.content || "";
    resultsText += "\n\n";
  });

  return resultsText;
}

//================= VERIFY USER MIDDLEWARE =================
async function verifyUser(req, res, next) {
  try {
    const authHeader = req.headers.authorization || "";

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ error: "No token provided" });
    }

    const token = authHeader.substring("Bearer ".length).trim();
    if (!token) {
      return res.status(401).json({ error: "No token provided" });
    }

    const decodedToken = await admin.auth().verifyIdToken(token);

    req.user = decodedToken;
    next();
  } catch (err) {
    return res.status(401).json({
      error: "Invalid token",
      detail: err.message,
      projectId: FIREBASE_PROJECT_ID,
    });
  }
}
// ================= HEALTH CHECK =================
app.get("/", (req, res) => {
  res.send("API running");
});

app.post("/upload-doc", verifyUser, upload.single("file"), async (req, res) => {
  try {
    const uid = req.user.uid;

    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: "No file uploaded",
      });
    }

    const file = req.file;

    const type = req.body.type || "general";

    const allowedTypes = ["lhdn", "kwsp", "kkm", "ptptn", "jpj", "pdrm", "general"];

    if (!allowedTypes.includes(type)) {
      return res.status(400).json({
        success: false,
        error: "Invalid document type",
      });
    }

    const fileName = `${type}/${uid}/${Date.now()}_${file.originalname}`;
    const blob = bucket.file(fileName);

    const blobStream = blob.createWriteStream({
      metadata: {
        contentType: file.mimetype,
      },
    });

    blobStream.on("error", (err) => {
      console.error("Upload error:", err);
      return res.status(500).json({
        success: false,
        error: err.message,
      });
    });

    blobStream.on("finish", async () => {
      try {
        // ✅ MAKE FILE PUBLIC
        await blob.makePublic();

        const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;

        return res.json({
          success: true,
          message: "File uploaded successfully",
          data: {
            fileName: file.originalname,
            type: type,
            url: publicUrl,
          },
        });
      } catch (err) {
        console.error("Public URL error:", err);
        return res.status(500).json({
          success: false,
          error: err.message,
        });
      }
    });

    blobStream.end(file.buffer);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

app.post("/pay", verifyUser, async (req, res) => {
  try {
    const uid = req.user.uid;

    const {
      agency,
      reference,
      amount,
      category, // ✅ NEW
    } = req.body;

    const allowedCategories = [
      "lhdn",
      "kwsp",
      "kkm",
      "ptptn",
      "jpj",
      "pdrm",
      "general",
    ];

    if (!allowedCategories.includes(category)) {
      return res.status(400).json({
        success: false,
        error: "Invalid category",
      });
    }

    const transactionId = `TXN_${Date.now()}`;

    const receipt = {
      uid,
      agency,
      reference,
      amount,
      category, // ✅ stored here
      transactionId,
      status: "SUCCESS",
      paidAt: new Date().toISOString(),
    };

    // ✅ STORE IN FIRESTORE (categorized)
    await admin.firestore()
      .collection("receipts")
      .doc(transactionId)
      .set(receipt);

    return res.json({
      success: true,
      message: "Payment successful",
      data: receipt,
    });

  } catch (err) {
    console.error(err);

    return res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

app.post("/chat", verifyUser, async (req, res) => {
  try {
    const message = req.body.message;
    const uid = req.user.uid;

    let contextData = "";

    // 🔹 Simple intent detection (you can improve later)
    if (message.toLowerCase().includes("tax")) {
      const tax = await calculateTax(uid);
      contextData = JSON.stringify(tax);
    }

    if (message.toLowerCase().includes("income")) {
      const income = await getUserTaxData(uid);
      contextData = JSON.stringify(income);
    }

    const response = await ai.generate({
      prompt: `
      You are SmartGOV AI Assistant for Malaysia.

      You help users with:
      - LHDN tax
      - PTPTN
      - JPJ
      - Bantuan

      User data (if available):
      ${contextData}

      User question:
      ${message}

      Give a helpful, simple answer.
      `,
    });

    res.json({
      success: true,
      reply: response.text,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

async function getUserTaxData(uid) {
  return {
    income: 85000,
    epf: 9000,
    donation: 1200,
  };
}

async function calculateTax(uid) {
  return {
    estimatedTax: 2150,
    reliefs: ["EPF", "Lifestyle"],
    recommendation: "You can claim more lifestyle relief",
  };
}

// ================= START SERVER (MUST BE LAST) =================
const DEFAULT_PORT = Number(process.env.PORT) || 8080;
const MAX_PORT_RETRIES = 10;

function startServer(port, attempt = 0) {
  const server = app.listen(port, "0.0.0.0", () => {
    console.log(`Server running on ${port}`);
  });

  server.on("error", (err) => {
    if (err && err.code === "EADDRINUSE" && attempt < MAX_PORT_RETRIES) {
      const nextPort = port + 1;
      console.warn(
        `Port ${port} is in use. Retrying on port ${nextPort}...`
      );
      setTimeout(() => startServer(nextPort, attempt + 1), 150);
      return;
    }

    console.error("Failed to start backend server:", err);
    process.exitCode = 1;
  });
}

startServer(DEFAULT_PORT);