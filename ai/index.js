import 'dotenv/config';
import express from 'express';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

app.post('/chat', async (req, res) => {
  try {
    const { message, userProfile } = req.body;
    if (!message) {
      return res.status(400).json({ error: 'message is required' });
    }
    const { chatbotFlow } = await import('./flows/chatbotFlow.js');
    const result = await chatbotFlow({ message, userProfile });
    res.json(result);
  } catch (err) {
    console.error(err);           // ← shows full error in terminal
    res.status(500).json({ error: err.message });
  }
});

app.post('/recommend', async (req, res) => {
  console.log("BODY:", req.body)
  
  try {
    const { recommendFlow } = await import('./flows/recommendFlow.js');
    const income = Number(req.body.income);
    const age = Number(req.body.age);
    const has_vehicle = Boolean(req.body.has_vehicle);
    const employment_status = req.body.employment_status;

    if (Number.isNaN(income) || Number.isNaN(age)) {
      return res.status(400).json({ error: 'income and age are required' });
    }
    const result = await recommendFlow({ income, age, has_vehicle, employment_status });
    res.json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

app.post('/ocr', async (req, res) => {
  try {
    const { ocrFlow } = await import('./flows/ocrFlow.js');
    const { imageBase64, mimeType } = req.body;
    if (!imageBase64 || !mimeType) {
      return res.status(400).json({ error: 'imageBase64 and mimeType are required' });
    }
    const result = await ocrFlow({ imageBase64, mimeType });
    res.json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

app.listen(process.env.PORT || 5001, () => {
  console.log(`✅ MyGOV AI running on port ${process.env.PORT || 5001}`);
});