import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_assistant_fab.dart';
import 'services/ai_service.dart';
import 'services/prefill_service.dart';
import 'services/service_navigation_intent.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                SizedBox(width: 220, child: _ApplicationSidebar()),
                Expanded(
                  child: ColoredBox(
                    color: theme.scaffoldBackgroundColor,
                    child: _ApplicationBody(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const ChatAssistantFab(),
    );
  }
}

class _ApplicationSidebar extends StatelessWidget {
  const _ApplicationSidebar();

  static const _items = [
    _ApplicationNavItem('Dashboard', Icons.dashboard_outlined, false),
    _ApplicationNavItem('Services', Icons.grid_view_outlined, false),
    _ApplicationNavItem('My Applications', Icons.description_outlined, true),
    _ApplicationNavItem(
      'Payments',
      Icons.account_balance_wallet_outlined,
      false,
    ),
    _ApplicationNavItem(
      'Notifications',
      Icons.notifications_none_outlined,
      false,
    ),
    _ApplicationNavItem('Profile', Icons.person_outline, false),
    _ApplicationNavItem('Settings', Icons.settings_outlined, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF214B74),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7C51A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF123A61),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SmartGOV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'One-Stop Portal',
                      style: TextStyle(
                        color: Color(0xFF9DB3C7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item.active
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Icon(item.icon, color: const Color(0xFFC2D1DF)),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFFC2D1DF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        if (item.title == 'Dashboard') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/dashboard');
                        }
                        if (item.title == 'Services') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/services');
                        }
                        if (item.title == 'Payments') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/payments');
                        }
                        if (item.title == 'Notifications') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/notifications');
                        }
                        if (item.title == 'Profile') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/profile');
                        }
                        if (item.title == 'Settings') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/settings');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                // IMPORTANT: clear navigation stack
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Color(0xFFC2D1DF)),
                  SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFC2D1DF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
}

class _ApplicationBody extends StatelessWidget {
  const _ApplicationBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Applications',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Track all your government applications in one place',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          _ApplicationTrackerCard(),

          const SizedBox(height: 18),

          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: theme.colorScheme.secondary, // ✅ FIXED
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Suggested for You',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _SuggestionGrid(),
        ],
      ),
    );
  }
}

class _ApplicationTrackerCard extends StatefulWidget {
  const _ApplicationTrackerCard();

  @override
  State<_ApplicationTrackerCard> createState() => _ApplicationTrackerCardState();
}

class _ApplicationTrackerCardState extends State<_ApplicationTrackerCard> {
  List<_TrackedApplication> _buildSampleApplications() {
    return [
      _TrackedApplication.sample(
        id: 'sample-str',
        title: 'STR Aid Application',
        agency: 'PADU',
        status: 'Pending',
        submittedAt: DateTime(2026, 3, 28),
        fields: const {
          'Applicant Name': 'Sample User',
          'Household Income': 'RM 2,500',
          'Dependents': '2',
        },
      ),
      _TrackedApplication.sample(
        id: 'sample-ekasih',
        title: 'eKasih Registration',
        agency: 'ICU JPM',
        status: 'Approved',
        submittedAt: DateTime(2026, 3, 15),
        fields: const {
          'Applicant Name': 'Sample User',
          'Category': 'B40',
          'Address': 'Kuala Lumpur',
        },
      ),
      _TrackedApplication.sample(
        id: 'sample-license',
        title: 'License Renewal',
        agency: 'JPJ',
        status: 'Processing',
        submittedAt: DateTime(2026, 4, 1),
        fields: const {
          'License Class': 'D',
          'Renewal Duration': '2 years',
          'Payment Method': 'FPX',
        },
      ),
      _TrackedApplication.sample(
        id: 'sample-ptptn',
        title: 'PTPTN Repayment Plan',
        agency: 'PTPTN',
        status: 'Rejected',
        submittedAt: DateTime(2026, 3, 10),
        fields: const {
          'Loan Number': 'PTPTN-12345',
          'Requested Amount': 'RM 180',
          'Reason': 'Document mismatch',
        },
      ),
    ];
  }

  _StatusStyle _statusStyle(BuildContext context, String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final normalized = status.trim().toLowerCase();

    if (normalized == 'approved') {
      return _StatusStyle(
        textColor: Colors.green,
        bgColor: isDark
            ? Colors.green.withValues(alpha: 0.15)
            : const Color(0xFFE4F6EC),
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
    }

    if (normalized == 'processing' || normalized == 'in review') {
      return _StatusStyle(
        textColor: Colors.blue,
        bgColor: isDark
            ? Colors.blue.withValues(alpha: 0.15)
            : const Color(0xFFE5F4FD),
        icon: Icons.timelapse,
        iconColor: Colors.blue,
      );
    }

    if (normalized == 'rejected') {
      return _StatusStyle(
        textColor: Colors.red,
        bgColor: isDark ? Colors.red.withValues(alpha: 0.15) : const Color(0xFFFBE9EA),
        icon: Icons.cancel_outlined,
        iconColor: Colors.red,
      );
    }

    return _StatusStyle(
      textColor: Colors.orange,
      bgColor: isDark
          ? Colors.orange.withValues(alpha: 0.15)
          : const Color(0xFFFFF1D6),
      icon: Icons.schedule,
      iconColor: Colors.orange,
    );
  }

  void _openDetails(_TrackedApplication application) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApplicationDetailsPage(application: application),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final fallbackItems = _buildSampleApplications();

    Widget buildTracker(List<_TrackedApplication> items) {
      final rows = items.isEmpty ? fallbackItems : items;

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD9DEE5)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Application Tracker',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < rows.length; i++) ...[
              Builder(
                builder: (context) {
                  final app = rows[i];
                  final style = _statusStyle(context, app.status);
                  return _ApplicationRow(
                    title: app.title,
                    subtitle: '${app.agency} • ${_formatDate(app.submittedAt)}',
                    status: app.status,
                    statusTextColor: style.textColor,
                    statusBgColor: style.bgColor,
                    icon: style.icon,
                    iconColor: style.iconColor,
                    iconBgColor: style.bgColor,
                    onTap: () => _openDetails(app),
                  );
                },
              ),
            ],
          ],
        ),
      );
    }

    if (user == null) {
      return buildTracker(fallbackItems);
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('service_applications')
          .orderBy('created_at', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return buildTracker(fallbackItems);
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!.docs
            .map(_TrackedApplication.fromFirestore)
            .toList();
        return buildTracker(items);
      },
    );
  }
}

class _ApplicationRow extends StatelessWidget {
  const _ApplicationRow({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusTextColor,
    required this.statusBgColor,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String status;
  final Color statusTextColor;
  final Color statusBgColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF6F8094),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class ApplicationDetailsPage extends StatelessWidget {
  const ApplicationDetailsPage({super.key, required this.application});

  final _TrackedApplication application;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD9DEE5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Agency: ${application.agency}',
                    style: const TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Submitted: ${_formatDate(application.submittedAt)}',
                    style: const TextStyle(
                      color: Color(0xFF6F8094),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      application.status,
                      style: const TextStyle(
                        color: Color(0xFF214B74),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _DetailSection(
              title: 'Submitted Information',
              children: application.fields.isEmpty
                  ? const [
                      Text(
                        'No field details were saved for this application.',
                        style: TextStyle(color: Color(0xFF6F8094), fontSize: 13),
                      ),
                    ]
                  : application.fields.entries
                        .map(
                          (entry) => _DetailRow(
                            label: entry.key,
                            value: entry.value.isEmpty ? '-' : entry.value,
                          ),
                        )
                        .toList(),
            ),
            if (application.aiExtracted.isNotEmpty) ...[
              const SizedBox(height: 12),
              _DetailSection(
                title: 'AI Extracted Fields',
                children: application.aiExtracted.entries
                    .map(
                      (entry) => _DetailRow(
                        label: entry.key,
                        value: entry.value,
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 12),
            _DetailSection(
              title: 'Metadata',
              children: [
                _DetailRow(label: 'Application ID', value: application.id),
                _DetailRow(label: 'Source', value: application.source),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6F8094),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.textColor,
    required this.bgColor,
    required this.icon,
    required this.iconColor,
  });

  final Color textColor;
  final Color bgColor;
  final IconData icon;
  final Color iconColor;
}

class _TrackedApplication {
  const _TrackedApplication({
    required this.id,
    required this.title,
    required this.agency,
    required this.status,
    required this.submittedAt,
    required this.fields,
    required this.aiExtracted,
    required this.source,
  });

  factory _TrackedApplication.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final fieldsData = (data['fields'] as Map<String, dynamic>? ?? const {})
        .map((key, value) => MapEntry(key, value?.toString() ?? ''));
    final aiData =
        (data['ai_extracted'] as Map<String, dynamic>? ?? const {})
            .map((key, value) => MapEntry(key, value?.toString() ?? ''));

    final ts = data['created_at'];
    final submittedAt = ts is Timestamp ? ts.toDate() : null;

    return _TrackedApplication(
      id: doc.id,
      title: (data['service'] ?? 'Application').toString(),
      agency: (data['agency'] ?? 'Agency').toString(),
      status: _displayStatus((data['status'] ?? 'Pending').toString()),
      submittedAt: submittedAt,
      fields: fieldsData,
      aiExtracted: aiData,
      source: 'Firestore',
    );
  }

  factory _TrackedApplication.sample({
    required String id,
    required String title,
    required String agency,
    required String status,
    required DateTime submittedAt,
    required Map<String, String> fields,
  }) {
    return _TrackedApplication(
      id: id,
      title: title,
      agency: agency,
      status: status,
      submittedAt: submittedAt,
      fields: fields,
      aiExtracted: const {},
      source: 'Sample',
    );
  }

  final String id;
  final String title;
  final String agency;
  final String status;
  final DateTime? submittedAt;
  final Map<String, String> fields;
  final Map<String, String> aiExtracted;
  final String source;
}

String _displayStatus(String raw) {
  final cleaned = raw.trim();
  if (cleaned.isEmpty) {
    return 'Pending';
  }

  return cleaned
      .split('_')
      .join(' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}')
      .join(' ');
}

String _formatDate(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Unknown date';
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
}

class _SuggestionGrid extends StatefulWidget {
  const _SuggestionGrid();

  @override
  State<_SuggestionGrid> createState() => _SuggestionGridState();
}

class _SuggestionGridState extends State<_SuggestionGrid> {
  bool _loading = true;
  String? _error;
  List<AiRecommendation> _recommendations = const [];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  int? _parseAge(dynamic value) {
    if (value is num) {
      return value.round();
    }
    return int.tryParse(value?.toString() ?? '');
  }

  int? _ageFromDob(dynamic value) {
    final dobText = value?.toString();
    if (dobText == null || dobText.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(dobText);
    if (parsed == null) {
      return null;
    }

    final today = DateTime.now();
    var age = today.year - parsed.year;
    final hadBirthdayThisYear =
        today.month > parsed.month ||
        (today.month == parsed.month && today.day >= parsed.day);
    if (!hadBirthdayThisYear) {
      age -= 1;
    }
    return age;
  }

  int _parseIncome(dynamic value) {
    if (value is num) {
      return value.round();
    }

    final text = value?.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    if (text == null || text.isEmpty) {
      return 0;
    }

    return double.tryParse(text)?.round() ?? 0;
  }

  Future<void> _loadRecommendations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Please sign in to see recommendations.';
          _loading = false;
        });
        return;
      }

      final profileDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final profile = profileDoc.data() ?? const {};

      final documentsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .get();

      final documents = documentsSnapshot.docs
          .map((doc) => doc.data())
          .toList();
      final prefill = PrefillService.buildPrefill(
        profile: profile,
        documents: documents,
      );

      final income = _parseIncome(prefill['income']) != 0
          ? _parseIncome(prefill['income'])
          : _parseIncome(profile['income']);
      final age = _parseAge(profile['age']) ?? _ageFromDob(profile['dob']) ?? 0;
      final employmentStatus =
          (profile['employment_status'] ??
                  profile['employmentStatus'] ??
                  'unknown')
              .toString();
      final hasVehicle =
          (profile['has_vehicle'] ?? profile['hasVehicle'] ?? false) == true;

      final recommendations = await AiService.instance.recommend(
        income: income,
        age: age,
        hasVehicle: hasVehicle,
        employmentStatus: employmentStatus,
      );

      AiDraftStore.instance.lastRecommendations = recommendations;

      if (!mounted) {
        return;
      }

      setState(() {
        _recommendations = recommendations;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  void _openService(String route) {
    if (route.startsWith('/services')) {
      Navigator.of(context).pushReplacementNamed('/services');
      return;
    }

    Navigator.of(context).pushReplacementNamed(route);
  }

  void _openServiceByTitle(String serviceTitle) {
    ServiceNavigationIntent.targetServiceTitle = serviceTitle;
    Navigator.of(context).pushReplacementNamed('/services');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null || _recommendations.isEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 300,
        ),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _SuggestionTile(
              title: 'You are eligible for STR',
              subtitle:
                  'Based on your income data, you qualify for Sumbangan Tunai Rahmah.',
              imageAsset: 'assets/images/STR.webp',
              onApply: () => _openServiceByTitle('Social Welfare'),
            );
          }

          return _SuggestionTile(
            title: 'Apply for MyKasih',
            subtitle:
                'Your household profile matches the MyKasih food aid criteria.',
            imageAsset: 'assets/images/MYKASIH.webp',
            onApply: () => _openServiceByTitle('Social Welfare'),
          );
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recommendations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 126,
      ),
      itemBuilder: (context, index) {
        final recommendation = _recommendations[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD9DEE5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      recommendation.service,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: recommendation.priority == 'high'
                          ? const Color(0xFFFDEDEE)
                          : recommendation.priority == 'medium'
                          ? const Color(0xFFFFF3E6)
                          : const Color(0xFFE8F4FE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      recommendation.priority.toUpperCase(),
                      style: TextStyle(
                        color: recommendation.priority == 'high'
                            ? Colors.red
                            : recommendation.priority == 'medium'
                            ? const Color(0xFFF5A623)
                            : const Color(0xFF3DA5F5),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                recommendation.reason,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF6F8094),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF214B74),
                  ),
                  onPressed: () => _openService(recommendation.route),
                  child: Text('Apply ${recommendation.service}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.title,
    required this.subtitle,
    this.imageAsset,
    this.onApply,
  });

  final String title;
  final String subtitle;
  final String? imageAsset;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 170,
                width: double.infinity,
                child: Image.asset(
                  imageAsset!,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          if (imageAsset != null) const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 12,
              height: 1.3,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onApply,
            child: const Text(
              'Apply Now →',
              style: TextStyle(
                color: Color(0xFF244A71),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplicationNavItem {
  const _ApplicationNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}
