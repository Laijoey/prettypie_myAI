import 'package:flutter/material.dart';
import '../../widgets/action_tile.dart';
import '../../widgets/ai_recommendation_box.dart';

class EPFPage extends StatelessWidget {
  const EPFPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EPF Management")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AIRecommendationBox(serviceType: "EPF Management"),
            SizedBox(height: 20),

            EPFBalanceSection(),
            SizedBox(height: 20),

            EPFActionsSection(),
            SizedBox(height: 20),

            EPFRagSection(),
          ],
        ),
      ),
    );
  }
}

class EPFBalanceSection extends StatelessWidget {
  const EPFBalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "EPF Account Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        const Card(
          child: ListTile(
            leading: Icon(Icons.account_balance),
            title: Text("Account 1 (Retirement)"),
            subtitle: Text("RM 45,000"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.savings),
            title: Text("Account 2 (Housing)"),
            subtitle: Text("RM 18,000"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.medical_services),
            title: Text("Account 3 (Flexible)"),
            subtitle: Text("RM 5,000"),
          ),
        ),
      ],
    );
  }
}

class EPFActionsSection extends StatelessWidget {
  const EPFActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "EPF Services",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ActionTile(
          title: "Check EPF Balance",
          subtitle: "View Account 1, 2, 3 breakdown",
          icon: Icons.account_balance,
          onTap: () {},
        ),

        ActionTile(
          title: "Withdrawal Application",
          subtitle: "Apply for approved withdrawals",
          icon: Icons.money,
          onTap: () {},
        ),

        ActionTile(
          title: "Voluntary Contribution",
          subtitle: "Add extra savings",
          icon: Icons.add_circle,
          onTap: () {},
        ),

        ActionTile(
          title: "i-Invest",
          subtitle: "Invest EPF into unit trust",
          icon: Icons.trending_up,
          onTap: () {},
        ),

        ActionTile(
          title: "i-Lindung",
          subtitle: "Buy insurance using EPF",
          icon: Icons.health_and_safety,
          onTap: () {},
        ),

        ActionTile(
          title: "i-Saraan / i-Sayang",
          subtitle: "Gig worker + spouse contribution",
          icon: Icons.family_restroom,
          onTap: () {},
        ),
      ],
    );
  }
}

class EPFRagSection extends StatelessWidget {
  const EPFRagSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "EPF Knowledge (RAG)",
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
            "This section will use Vertex AI Search to retrieve EPF rules, withdrawal eligibility, "
            "investment guidelines, and retirement planning insights.",
          ),
        ),
      ],
    );
  }
}