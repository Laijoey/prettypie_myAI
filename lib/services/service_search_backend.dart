class ServiceSearchBackend {
  const ServiceSearchBackend._();

  static const Map<String, List<String>> _aliasesByService = {
    'Tax Filing': ['tax', 'cukai', 'lhdn', 'mytax', 'income tax'],
    'EPF Management': ['epf', 'kwsp', 'retirement', 'contribution'],
    'Health Services': ['health', 'clinic', 'hospital', 'kkm', 'medical'],
    'Loan Payment': ['loan', 'ptptn', 'student loan', 'education loan'],
    'License Renewal': ['license', 'lesen', 'jpj', 'roadtax', 'driving'],
    'Summons Payment': ['summons', 'saman', 'pdrm', 'fine'],
    'Birth Certificate': ['birth', 'certificate', 'jpn', 'child'],
    'Housing Application': ['housing', 'house', 'home', 'pr1ma', 'property'],
    'Social Welfare': ['welfare', 'aid', 'jkm', 'assistance', 'bantuan'],
    'Business Registration': ['business', 'ssm', 'company', 'register'],
    'Legal Aid': ['legal', 'law', 'bheuu', 'court help'],
    'Passport Renewal': ['passport', 'jim', 'immigration', 'travel'],
    'Marriage Registration': ['marriage', 'nikah', 'register marriage'],
    'Land Tax Payment': ['land tax', 'quit rent', 'ptg', 'tanah'],
    'Vehicle Ownership Transfer': [
      'ownership transfer',
      'vehicle transfer',
      'transfer car',
      'jpj transfer',
    ],
    'Court Case Status': ['court', 'case', 'e-kehakiman', 'judiciary'],
    'Zakat Payment': ['zakat', 'ppz', 'charity'],
    'Public Complaint': ['complaint', 'report issue', 'sispa', 'sispaa'],
  };

  static Future<String?> searchSingleService({
    required String keyword,
    required List<String> serviceTitles,
  }) async {
    final normalizedQuery = _normalize(keyword);
    if (normalizedQuery.isEmpty) {
      return null;
    }

    await Future<void>.delayed(const Duration(milliseconds: 170));

    String? bestTitle;
    var bestScore = 0;

    for (final title in serviceTitles) {
      final score = _scoreTitle(title, normalizedQuery);
      if (score > bestScore) {
        bestScore = score;
        bestTitle = title;
      }
    }

    return bestScore > 0 ? bestTitle : null;
  }

  static int _scoreTitle(String title, String normalizedQuery) {
    final normalizedTitle = _normalize(title);
    var score = 0;

    if (normalizedTitle == normalizedQuery) {
      score += 140;
    } else if (normalizedTitle.startsWith(normalizedQuery)) {
      score += 90;
    } else if (normalizedTitle.contains(normalizedQuery)) {
      score += 65;
    }

    final aliases = _aliasesByService[title] ?? const <String>[];
    for (final alias in aliases) {
      final normalizedAlias = _normalize(alias);
      if (normalizedAlias == normalizedQuery) {
        score += 120;
      } else if (normalizedAlias.startsWith(normalizedQuery) ||
          normalizedAlias.contains(normalizedQuery)) {
        score += 75;
      } else if (normalizedQuery.contains(normalizedAlias)) {
        score += 35;
      }
    }

    final queryTokens = normalizedQuery.split(' ').where((e) => e.isNotEmpty);
    for (final token in queryTokens) {
      if (normalizedTitle.contains(token)) {
        score += 14;
      }
      for (final alias in aliases) {
        if (_normalize(alias).contains(token)) {
          score += 12;
          break;
        }
      }
    }

    return score;
  }

  static String _normalize(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
