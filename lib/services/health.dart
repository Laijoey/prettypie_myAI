import 'package:flutter/material.dart';
import '../widgets/action_tile.dart';
import '../../widgets/ai_recommendation_box.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Services")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AIRecommendationBox(serviceType: "Health Services"),

            SizedBox(height: 20),

            HealthSummarySection(),

            SizedBox(height: 20),

            HealthActionsSection(),

            SizedBox(height: 20),

            HealthRagSection(),
          ],
        ),
      ),
    );
  }
}

class HealthSummarySection extends StatelessWidget {
  const HealthSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Health Overview",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        const Card(
          child: ListTile(
            leading: Icon(Icons.vaccines),
            title: Text("Vaccination Status"),
            subtitle: Text("Completed (COVID-19 + Booster)"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.monitor_heart),
            title: Text("Health Risk Level"),
            subtitle: Text("Low Risk"),
          ),
        ),

        const Card(
          child: ListTile(
            leading: Icon(Icons.location_on),
            title: Text("Nearest Clinic"),
            subtitle: Text("2.3 km away"),
          ),
        ),
      ],
    );
  }
}

class HealthActionsSection extends StatelessWidget {
  const HealthActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Health Services",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ActionTile(
          title: "Book Appointment",
          subtitle: "Clinic based on location",
          icon: Icons.calendar_today,
          onTap: () {},
        ),

        ActionTile(
          title: "Health Records",
          subtitle: "Vaccination + medical history",
          icon: Icons.health_and_safety,
          onTap: () {},
        ),

        ActionTile(
          title: "Disease Tracker",
          subtitle: "Dengue / COVID hotspot map",
          icon: Icons.map,
          onTap: () {},
        ),

        ActionTile(
          title: "Find Clinics",
          subtitle: "Nearby hospitals & clinics",
          icon: Icons.local_hospital,
          onTap: () {},
        ),

        ActionTile(
          title: "Organ Donation",
          subtitle: "Register donor status",
          icon: Icons.favorite,
          onTap: () {},
        ),

        ActionTile(
          title: "Mental Health Screening",
          subtitle: "MyMinda assessment",
          icon: Icons.psychology,
          onTap: () {},
        ),
      ],
    );
  }
}

class HealthRagSection extends StatelessWidget {
  const HealthRagSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Health Knowledge (RAG)",
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
            "This section will use Vertex AI Search to retrieve medical guidelines, "
            "clinic availability, disease outbreak data, and mental health support resources.",
          ),
        ),
      ],
    );
  }
}