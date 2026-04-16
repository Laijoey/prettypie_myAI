class PrefillService {
  static Map<String, dynamic> buildPrefill({
    required Map<String, dynamic> profile,
    required List<Map<String, dynamic>> documents,
  }) {
    return {
      // 👤 from profile
      "name": profile["name"],
      "ic": profile["ic"],
      "address": profile["address"],
      "phone": profile["phone"],
      "region": profile["region"],

      // 💰 derived from documents (REAL DATA)
      "income": _calculateIncome(documents),

      // 🧠 fallback safety
      "email": profile["email"],
    };
  }

  static double _calculateIncome(List<Map<String, dynamic>> docs) {
    double total = 0;

    for (final doc in docs) {
      if (doc["type"] == "income" || doc["type"] == "payslip") {
        final value = doc["amount"];
        if (value is num) {
          total += value.toDouble();
        } else {
          final parsed = double.tryParse(
            value?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '',
          );
          if (parsed != null) {
            total += parsed;
          }
        }
      }
    }

    return total;
  }
}