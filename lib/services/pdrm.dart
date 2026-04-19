import 'package:flutter/material.dart';
import '../widgets/action_tile.dart';
import '../../widgets/ai_recommendation_box.dart';
class PDRMPage extends StatelessWidget {
  const PDRMPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Summons Payment")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AIRecommendationBox(serviceType: "PDRM"),

            SizedBox(height: 20),

            PDRMSummonsSection(),

            SizedBox(height: 20),

            PDRMActionsSection(),

            SizedBox(height: 20),

            PDRMRagSection(),
          ],
        ),
      ),
    );
  }
}

class PDRMSummonsSection extends StatelessWidget {
  const PDRMSummonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Summons Overview",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        const Card(
          child: ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text("Outstanding Summons"),
            subtitle: Text("RM 300 (2 pending cases)"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.check_circle),
            title: Text("Paid Summons"),
            subtitle: Text("RM 150 (completed)"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.block),
            title: Text("Blacklist Status"),
            subtitle: Text("No travel restriction"),
          ),
        ),
      ],
    );
  }
}

class PDRMActionsSection extends StatelessWidget {
  const PDRMActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PDRM Services",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ActionTile(
          title: "Check Summons",
          subtitle: "View traffic & police fines",
          icon: Icons.receipt_long,
          onTap: () {},
        ),

        ActionTile(
          title: "Pay Summons",
          subtitle: "Online payment & discount system",
          icon: Icons.payment,
          onTap: () {},
        ),

        ActionTile(
          title: "Blacklist Check",
          subtitle: "Check travel restriction status",
          icon: Icons.block,
          onTap: () {},
        ),

        ActionTile(
          title: "Accident Report",
          subtitle: "Submit accident details",
          icon: Icons.car_crash,
          onTap: () {},
        ),

        ActionTile(
          title: "Police Report",
          subtitle: "File official report online",
          icon: Icons.report,
          onTap: () {},
        ),

        ActionTile(
          title: "Emergency Assistance",
          subtitle: "Request immediate help",
          icon: Icons.local_police,
          onTap: () {},
        ),
      ],
    );
  }
}

class PDRMRagSection extends StatelessWidget {
  const PDRMRagSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PDRM Knowledge (RAG)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "This section will use Vertex AI Search to retrieve traffic law rules, "
            "summons policies, blacklist regulations, and accident reporting procedures.",
          ),
        ),
      ],
    );
  }
}