import 'package:flutter/material.dart';
import '../widgets/action_tile.dart';
import '../widgets/ai_recommendation_box.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'backend_api.dart';

class TaxPage extends StatefulWidget {
  const TaxPage({super.key});

  @override
  State<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> {
  bool isLoading = false;
  Map<String, dynamic>? taxResult;
  Map<String, dynamic>? income;
  List<dynamic>? reliefs;
  String? taxStatus;

  Future<void> autoTax() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user!.getIdToken();
      print("TOKEN: $token");

      final response = await http
          .post(
            Uri.parse("${BackendApi.baseUrl}/auto-tax"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"userId": "test"}),
          )
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body);
      setState(() {
        taxResult = data["data"];
      });
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to fetch tax data")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitTax() async {
    if (taxResult == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Run Auto Tax first")));
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user!.getIdToken();

      final res = await http.post(
        Uri.parse("${BackendApi.baseUrl}/submit-tax"),
        headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "taxData": {"amount": taxResult!["estimatedTax"]},
        }),
      );

      final data = jsonDecode(res.body);

      setState(() {
        taxStatus = "Submitted";
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data["message"])));
    } catch (e) {
      print("Submit ERROR: $e");
    }
  }

  Future<void> payTax() async {
    if (taxResult == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No tax to pay")));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Redirecting to payment for RM ${taxResult!["estimatedTax"]}",
        ),
      ),
    );

    // future: integrate ByrHASiL / FPX
  }

  Future<void> registerTin() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("e-TIN registered successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tax Filing")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AIRecommendationBox(serviceType: "Tax Filing"),

            const SizedBox(height: 20),

            // ================= INCOME =================
            const Text(
              "Income Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _InfoCard(
              title: "Annual Income",
              subtitle: "RM 85,000 (Firebase-ready)",
              icon: Icons.attach_money,
            ),
            _InfoCard(
              title: "EPF Contribution",
              subtitle: "RM 9,000",
              icon: Icons.account_balance,
            ),
            _InfoCard(
              title: "Donations",
              subtitle: "RM 1,200",
              icon: Icons.volunteer_activism,
            ),

            const SizedBox(height: 20),

            // ================= ACTIONS =================
            const Text(
              "Tax Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ActionTile(
              title: "Auto File Tax",
              subtitle: "Gemini-assisted tax filing",
              icon: Icons.auto_awesome,
              onTap: autoTax,
            ),

            ActionTile(
              title: "Submit to LHDN",
              subtitle: "Send via Cloud Run API",
              icon: Icons.cloud_upload,
              onTap: submitTax,
            ),

            ActionTile(
              title: "Pay Tax (ByrHASiL)",
              subtitle: "Secure payment gateway",
              icon: Icons.payment,
              onTap: payTax,
            ),

            ActionTile(
              title: "e-TIN Registration",
              subtitle: "Register taxpayer ID",
              icon: Icons.badge,
              onTap: registerTin,
            ),

            const SizedBox(height: 20),

            // ================= LOADING =================
            if (isLoading) const Center(child: CircularProgressIndicator()),

            // ================= RESULT =================
            if (taxResult != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AI Tax Result",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text("Estimated Tax: RM ${taxResult!["estimatedTax"]}"),

                      const SizedBox(height: 8),

                      Text("Reliefs: ${taxResult!["reliefs"].join(", ")}"),

                      const SizedBox(height: 8),

                      Text("Recommendation: ${taxResult!["recommendation"]}"),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ================= OTHER UI =================
            const Text(
              "Tax Relief Checker",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _InfoCard(
              title: "Eligible Reliefs",
              subtitle: "EPF, Education, Lifestyle",
              icon: Icons.check_circle,
            ),

            const SizedBox(height: 20),

            const Text(
              "Tax Estimator",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _InfoCard(
              title: "Estimated Tax",
              subtitle: "RM 2,150 (AI prediction)",
              icon: Icons.calculate,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= REUSABLE CARD =================
class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class TaxActionsSection extends StatelessWidget {
  const TaxActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tax Actions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        // ================= AI ACTIONS =================
        ActionTile(
          title: "Auto File Tax",
          subtitle: "Gemini-assisted tax filing",
          icon: Icons.auto_awesome,
          onTap: () async {
            try {
              final response = await http.post(
                Uri.parse("https://YOUR-CLOUD-RUN-URL/auto-tax"),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({"userId": "user123"}),
              );

              final data = jsonDecode(response.body);

              if (data["success"]) {
                final result = data["data"];

                // SHOW RESULT TO USER
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Tax Result"),
                    content: Text(
                      "Estimated Tax: RM ${result["estimatedTax"]}\n\n"
                      "Reliefs: ${result["reliefs"].join(", ")}\n\n"
                      "${result["recommendation"]}",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                throw Exception("Failed");
              }
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Error: $e")));
            }
          },
        ),

        ActionTile(
          title: "Analyze My Tax",
          subtitle: "AI reviews income & deductions",
          icon: Icons.analytics,
          onTap: () {
            // future: Vertex AI Search + Gemini
          },
        ),

        const SizedBox(height: 10),

        // ================= SYSTEM ACTIONS =================
        ActionTile(
          title: "Fetch Income Data",
          subtitle: "Load Firebase tax profile",
          icon: Icons.cloud_download,
          onTap: () {
            // Firebase Firestore fetch
          },
        ),

        ActionTile(
          title: "Check Tax Reliefs",
          subtitle: "RAG-based eligibility check",
          icon: Icons.fact_check,
          onTap: () {
            // Vertex AI Search (LHDN rules)
          },
        ),

        const SizedBox(height: 10),

        // ================= SUBMISSION =================
        ActionTile(
          title: "Submit to LHDN",
          subtitle: "Send via Cloud Run API",
          icon: Icons.upload,
          onTap: () {
            // Cloud Run endpoint
          },
        ),

        ActionTile(
          title: "Check Submission Status",
          subtitle: "Track refund / approval",
          icon: Icons.receipt_long,
          onTap: () {
            // Firebase + API status check
          },
        ),

        const SizedBox(height: 10),

        // ================= PAYMENT =================
        ActionTile(
          title: "Pay Tax (ByrHASiL)",
          subtitle: "Secure government payment",
          icon: Icons.payment,
          onTap: () {
            // payment gateway later
          },
        ),
      ],
    );
  }
}
