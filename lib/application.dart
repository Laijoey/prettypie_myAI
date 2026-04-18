import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class _ApplicationTrackerCard extends StatelessWidget {
  const _ApplicationTrackerCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)), // kept as-is
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
          Divider(height: 1, color: Theme.of(context).dividerColor),

          // ================= PENDING =================
          _ApplicationRow(
            title: 'STR Aid Application',
            subtitle: 'PADU • 28 Mar 2026',
            status: 'Pending',
            statusTextColor: Colors.orange,
            statusBgColor: isDark
                ? Colors.orange.withValues(alpha: 0.15)
                : const Color(0xFFFFF1D6),
            icon: Icons.schedule,
            iconColor: Colors.orange,
            iconBgColor: isDark
                ? Colors.orange.withValues(alpha: 0.15)
                : const Color(0xFFFFF1D6),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // ================= APPROVED =================
          _ApplicationRow(
            title: 'eKasih Registration',
            subtitle: 'ICU JPM • 15 Mar 2026',
            status: 'Approved',
            statusTextColor: Colors.green,
            statusBgColor: isDark
                ? Colors.green.withValues(alpha: 0.15)
                : const Color(0xFFE4F6EC),
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
            iconBgColor: isDark
                ? Colors.green.withValues(alpha: 0.15)
                : const Color(0xFFE4F6EC),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // ================= PROCESSING =================
          _ApplicationRow(
            title: 'License Renewal',
            subtitle: 'JPJ • 1 Apr 2026',
            status: 'Processing',
            statusTextColor: Colors.blue,
            statusBgColor: isDark
                ? Colors.blue.withValues(alpha: 0.15)
                : const Color(0xFFE5F4FD),
            icon: Icons.timelapse,
            iconColor: Colors.blue,
            iconBgColor: isDark
                ? Colors.blue.withValues(alpha: 0.15)
                : const Color(0xFFE5F4FD),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // ================= REJECTED =================
          _ApplicationRow(
            title: 'PTPTN Repayment Plan',
            subtitle: 'PTPTN • 10 Mar 2026',
            status: 'Rejected',
            statusTextColor: Colors.red,
            statusBgColor: isDark
                ? Colors.red.withValues(alpha: 0.15)
                : const Color(0xFFFBE9EA),
            icon: Icons.cancel_outlined,
            iconColor: Colors.red,
            iconBgColor: isDark
                ? Colors.red.withValues(alpha: 0.15)
                : const Color(0xFFFBE9EA),
          ),
        ],
      ),
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
  });

  final String title;
  final String subtitle;
  final String status;
  final Color statusTextColor;
  final Color statusBgColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ],
      ),
    );
  }
}

class _SuggestionGrid extends StatelessWidget {
  const _SuggestionGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: const [
        _SuggestionTile(
          title: 'You are eligible for STR',
          subtitle:
              'Based on your income data, you qualify for Sumbangan Tunai Rahmah.',
        ),
        _SuggestionTile(
          title: 'Apply for MyKasih',
          subtitle:
              'Your household profile matches the MyKasih food aid criteria.',
        ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          const SizedBox(height: 10),
          const Text(
            'Apply Now →',
            style: TextStyle(
              color: Color(0xFF244A71),
              fontSize: 13,
              fontWeight: FontWeight.w700,
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
