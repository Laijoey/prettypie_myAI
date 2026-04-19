import 'package:flutter/material.dart';

class AIRecommendationBox extends StatelessWidget {
  final String serviceType;

  const AIRecommendationBox({
    super.key,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    final recommendations = _getAI(serviceType);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "AI Analysis (Demo)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),

          ...recommendations.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getAI(String type) {
    switch (type) {
      case "Tax Filing":
        return [
          "You have 3 eligible tax reliefs detected",
          "Estimated refund: RM 120",
          "Income pre-filled from Firebase profile",
        ];

      case "EPF Management":
        return [
          "Retirement score: Moderate",
          "You qualify for i-Saraan bonus contribution",
        ];

      case "License Renewal":
        return [
          "License expires in 28 days",
          "Early renewal recommended",
        ];

      case "Health Services":
        return [
          "Nearest clinic available within 2.3km",
          "Vaccination record complete",
        ];

      case "PTPTN":
        return [
          "Loan repayment is active",
          "You are eligible for restructuring plan",
        ];

      default:
        return ["AI analyzing your profile..."];
    }
  }
}