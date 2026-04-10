import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEFF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: const [
                SizedBox(
                  width: 220,
                  child: _NotificationSidebar(),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Color(0xFFF5F5F7),
                    child: _NotificationBody(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1F4468),
        child: const Icon(Icons.smart_toy_outlined),
      ),
    );
  }
}

class _NotificationSidebar extends StatelessWidget {
  const _NotificationSidebar();

  static const _items = [
    _NotificationNavItem('Dashboard', Icons.dashboard_outlined, false),
    _NotificationNavItem('Services', Icons.grid_view_outlined, false),
    _NotificationNavItem('My Applications', Icons.description_outlined, false),
    _NotificationNavItem('Payments', Icons.account_balance_wallet_outlined, false),
    _NotificationNavItem('Notifications', Icons.notifications_none_outlined, true),
    _NotificationNavItem('Profile', Icons.person_outline, false),
    _NotificationNavItem('Settings', Icons.settings_outlined, false),
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
                          Navigator.of(context).pushReplacementNamed('/dashboard');
                        }
                        if (item.title == 'Services') {
                          Navigator.of(context).pushReplacementNamed('/services');
                        }
                        if (item.title == 'My Applications') {
                          Navigator.of(context).pushReplacementNamed('/applications');
                        }
                        if (item.title == 'Payments') {
                          Navigator.of(context).pushReplacementNamed('/payments');
                        }
                        if (item.title == 'Profile') {
                          Navigator.of(context).pushReplacementNamed('/profile');
                        }
                        if (item.title == 'Settings') {
                          Navigator.of(context).pushReplacementNamed('/settings');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: Row(
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
        ],
      ),
    );
  }
}

class _NotificationBody extends StatelessWidget {
  const _NotificationBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Stay updated with your government services',
            style: TextStyle(
              color: Color(0xFF6B7B8D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 14),
          _NotificationFilters(),
          SizedBox(height: 14),
          _NotificationListCard(),
        ],
      ),
    );
  }
}

class _NotificationFilters extends StatelessWidget {
  const _NotificationFilters();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _FilterChip(label: 'All', active: true),
        SizedBox(width: 8),
        _FilterChip(label: 'Payments'),
        SizedBox(width: 8),
        _FilterChip(label: 'Applications'),
        SizedBox(width: 8),
        _FilterChip(label: 'System'),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF214B74) : const Color(0xFFE9EDF2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xFF6D8094),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotificationListCard extends StatelessWidget {
  const _NotificationListCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        children: const [
          _NotificationItem(
            title: 'Road tax expires in 14 days',
            subtitle: 'JPJ - Renew before 19 Apr 2026',
            timeAgo: '2h ago',
            icon: Icons.credit_card,
            showCheck: true,
          ),
          Divider(height: 1, color: Color(0xFFDDE3EA)),
          _NotificationItem(
            title: '2 unpaid summons detected',
            subtitle: 'PDRM - Total RM 300.00',
            timeAgo: '5h ago',
            icon: Icons.credit_card,
            showCheck: true,
          ),
          Divider(height: 1, color: Color(0xFFDDE3EA)),
          _NotificationItem(
            title: 'eKasih application approved',
            subtitle: 'ICU JPM - Your application has been approved',
            timeAgo: '1d ago',
            icon: Icons.description_outlined,
            showCheck: true,
          ),
          Divider(height: 1, color: Color(0xFFDDE3EA)),
          _NotificationItem(
            title: 'STR Aid application submitted',
            subtitle: 'PADU - Currently under review',
            timeAgo: '3d ago',
            icon: Icons.description_outlined,
          ),
          Divider(height: 1, color: Color(0xFFDDE3EA)),
          _NotificationItem(
            title: 'System maintenance scheduled',
            subtitle: 'MyGov - 10 Apr 2026, 2:00 AM - 6:00 AM',
            timeAgo: '5d ago',
            icon: Icons.info_outline,
          ),
          Divider(height: 1, color: Color(0xFFDDE3EA)),
          _NotificationItem(
            title: 'PTPTN repayment reminder',
            subtitle: 'PTPTN - Monthly payment due 15 Apr',
            timeAgo: '1w ago',
            icon: Icons.credit_card,
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.icon,
    this.showCheck = false,
  });

  final String title;
  final String subtitle;
  final String timeAgo;
  final IconData icon;
  final bool showCheck;

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
              color: const Color(0xFFE9EDF2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF5C7389), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E2D3F),
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
          const SizedBox(width: 8),
          Text(
            timeAgo,
            style: const TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showCheck) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFE9EDF2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF9AAABC),
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationNavItem {
  const _NotificationNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}
