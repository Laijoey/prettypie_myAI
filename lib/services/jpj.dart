import 'package:flutter/material.dart';
import '../widgets/action_tile.dart';
import '../../widgets/ai_recommendation_box.dart';

class JPJPage extends StatelessWidget {
  const JPJPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("License Renewal")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AIRecommendationBox(serviceType: "License Renewal"),

            SizedBox(height: 20),

            JPJSummarySection(),

            SizedBox(height: 20),

            JPJVehicleSection(),

            SizedBox(height: 20),

            JPJDriverSection(),

            SizedBox(height: 20),

            JPJRagSection(),
          ],
        ),
      ),
    );
  }
}

class JPJSummarySection extends StatelessWidget {
  const JPJSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "JPJ Overview",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        const Card(
          child: ListTile(
            leading: Icon(Icons.directions_car),
            title: Text("Vehicle Status"),
            subtitle: Text("Road Tax Active"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.credit_card),
            title: Text("Driving License"),
            subtitle: Text("CDL - Valid until 2026"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.confirmation_number),
            title: Text("Active Registrations"),
            subtitle: Text("1 Vehicle Registered"),
          ),
        ),
      ],
    );
  }
}

class JPJVehicleSection extends StatelessWidget {
  const JPJVehicleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Vehicle Licensing",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ActionTile(
          title: "Bid Number Plate (JPJeBid)",
          subtitle: "Auction vehicle registration numbers",
          icon: Icons.confirmation_number,
          onTap: () {
            // TODO: open JPJeBid link
          },
        ),

        ActionTile(
          title: "LKM Renewal",
          subtitle: "Road tax renewal",
          icon: Icons.verified,
          onTap: () {},
        ),

        ActionTile(
          title: "Check Latest Plate Numbers",
          subtitle: "View available number series",
          icon: Icons.search,
          onTap: () {},
        ),
      ],
    );
  }
}

class JPJDriverSection extends StatelessWidget {
  const JPJDriverSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Driver Licensing",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ActionTile(
          title: "Check License Status",
          subtitle: "LDL / PDL / CDL details",
          icon: Icons.credit_card,
          onTap: () {},
        ),

        ActionTile(
          title: "Renew Driving License",
          subtitle: "Only eligible licenses can be renewed",
          icon: Icons.refresh,
          onTap: () {},
        ),

        ActionTile(
          title: "CDL Application",
          subtitle: "Apply for Competent Driving License",
          icon: Icons.assignment_ind,
          onTap: () {},
        ),

        ActionTile(
          title: "Check Test Results",
          subtitle: "Driving test outcome (MyJPJ sync)",
          icon: Icons.fact_check,
          onTap: () {},
        ),

        ActionTile(
          title: "Special Transition Program",
          subtitle: "Class B upgrade eligibility check",
          icon: Icons.change_circle,
          onTap: () {},
        ),
      ],
    );
  }
}

class JPJRagSection extends StatelessWidget {
  const JPJRagSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "JPJ Knowledge (RAG)",
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
            "This section will use Vertex AI Search to retrieve JPJ regulations, "
            "road tax policies, driving license eligibility, and vehicle registration rules.",
          ),
        ),
      ],
    );
  }
}