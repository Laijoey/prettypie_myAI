import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/action_tile.dart';
import '../../widgets/ai_recommendation_box.dart';

class PTPTNPage extends StatelessWidget {
  const PTPTNPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PTPTN Intelligence")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AIRecommendationBox(serviceType: "PTPTN"),

            SizedBox(height: 20),

            PTPTNSummarySection(),

            SizedBox(height: 20),

            PTPTNAccountSection(),

            SizedBox(height: 20),

            PTPTNActionsSection(),

            SizedBox(height: 20),

            PTPTNQRSection(),

            SizedBox(height: 20),

            PTPTNRagSection(),
          ],
        ),
      ),
    );
  }
}

class PTPTNSummarySection extends StatelessWidget {
  const PTPTNSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Loan Overview",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        const Card(
          child: ListTile(
            leading: Icon(Icons.school),
            title: Text("Outstanding Loan"),
            subtitle: Text("RM 12,500"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.warning),
            title: Text("Blacklist Status"),
            subtitle: Text("No travel restriction"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.trending_up),
            title: Text("Repayment Status"),
            subtitle: Text("Active / On schedule"),
          ),
        ),
      ],
    );
  }
}

class PTPTNAccountSection extends StatelessWidget {
  const PTPTNAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Account Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        const Card(
          child: ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text("Total Credit"),
            subtitle: Text("RM 3,000"),
          ),
        ),
      ],
    );
  }
}

class PTPTNActionsSection extends StatelessWidget {
  const PTPTNActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PTPTN Services",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ActionTile(
          title: "Travel Restriction Status",
          subtitle: "Check blacklist for overseas travel",
          icon: Icons.flight_takeoff,
          onTap: () {},
        ),

        ActionTile(
          title: "SSPN Prime Account",
          subtitle: "Open savings account",
          icon: Icons.savings,
          onTap: () {},
        ),

        ActionTile(
          title: "SSPN Plus Account",
          subtitle: "Investment-linked savings",
          icon: Icons.account_balance,
          onTap: () {},
        ),

        ActionTile(
          title: "Debt Settlement Letter",
          subtitle: "Generate clearance letter",
          icon: Icons.description,
          onTap: () {},
        ),

        ActionTile(
          title: "Loan Balance Check",
          subtitle: "Verify remaining PTPTN debt",
          icon: Icons.search,
          onTap: () {},
        ),

        ActionTile(
          title: "Direct Debit Application",
          subtitle: "Enable automatic repayment",
          icon: Icons.sync,
          onTap: () {},
        ),

        ActionTile(
          title: "Auto Debit Setup",
          subtitle: "Bank auto deduction system",
          icon: Icons.autorenew,
          onTap: () {},
        ),

        ActionTile(
          title: "Salary Deduction",
          subtitle: "Potong gaji repayment system",
          icon: Icons.money,
          onTap: () {},
        ),

        ActionTile(
          title: "JomPAY Check",
          subtitle: "Payment verification system",
          icon: Icons.payment,
          onTap: () {},
        ),

        ActionTile(
          title: "WPP Check",
          subtitle: "Advance loan eligibility",
          icon: Icons.school,
          onTap: () {},
        ),

        ActionTile(
          title: "Loan Statement Request",
          subtitle: "Generate official statement",
          icon: Icons.receipt_long,
          onTap: () {},
        ),

        ActionTile(
          title: "Promotions & Discounts",
          subtitle: "PTPTN repayment incentives",
          icon: Icons.local_offer,
          onTap: () {},
        ),
      ],
    );
  }
}

class PTPTNQRSection extends StatelessWidget {
  const PTPTNQRSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "QR Services",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Center(
          child: QrImageView(
            data: "PTPTN_USER_DEMO_QR",
            version: QrVersions.auto,
            size: 160,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Scan for future integration: payment, student verification, or campus services.",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PTPTNRagSection extends StatelessWidget {
  const PTPTNRagSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PTPTN Knowledge (RAG)",
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
            "This section will use Vertex AI Search to retrieve PTPTN policies, "
            "loan repayment rules, SSPN benefits, and blacklist regulations.",
          ),
        ),
      ],
    );
  }
}