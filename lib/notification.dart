import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
                SizedBox(
                  width: 220,
                  child: _NotificationSidebar(),
                ),
                Expanded(
                  child: ColoredBox(
                    color: theme.scaffoldBackgroundColor,
                    child: _NotificationBody(),
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

class _NotificationBody extends StatefulWidget {
  const _NotificationBody();

  @override
  State<_NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<_NotificationBody> {
  String _selectedFilter = 'All';

  static const List<_NotificationData> _allNotifications = [
    _NotificationData(
      title: 'Road tax renewal due in 5 days',
      subtitle: 'JPJ - Renew before 19 Apr 2026',
      timeAgo: '2h ago',
      icon: Icons.directions_car_outlined,
      showCheck: true,
      category: 'Payments',
    ),
    _NotificationData(
      title: 'Traffic summons payment due soon',
      subtitle: 'PDRM - Due by 16 Apr 2026',
      timeAgo: '5h ago',
      icon: Icons.warning_amber_outlined,
      showCheck: true,
      category: 'Payments',
    ),
    _NotificationData(
      title: 'STR Phase 2 payment credited',
      subtitle: 'LHDN - RM 300 credited to bank account',
      timeAgo: '1d ago',
      icon: Icons.account_balance_wallet_outlined,
      showCheck: true,
      category: 'Payments',
    ),
    _NotificationData(
      title: 'Passport renewal appointment confirmed',
      subtitle: 'JIM - 22 Apr 2026, UTC Pudu',
      timeAgo: '3d ago',
      icon: Icons.event_available_outlined,
      category: 'Applications',
    ),
    _NotificationData(
      title: 'eKasih application approved',
      subtitle: 'ICU JPM - Approval letter now available',
      timeAgo: '5d ago',
      icon: Icons.check_circle_outline,
      category: 'Applications',
    ),
    _NotificationData(
      title: 'MyKad address update pending verification',
      subtitle: 'JPN - Submit utility bill for verification',
      timeAgo: '1w ago',
      icon: Icons.badge_outlined,
      category: 'Applications',
    ),
    _NotificationData(
      title: 'System maintenance scheduled',
      subtitle: 'MyGov - 20 Apr 2026, 1:00 AM - 4:00 AM',
      timeAgo: '1w ago',
      icon: Icons.info_outline,
      category: 'System',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleNotifications = _selectedFilter == 'All'
        ? _allNotifications
        : _allNotifications
            .where((item) => item.category == _selectedFilter)
            .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Stay updated with your government services',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 14),
                _NotificationFilters(
                  selectedFilter: _selectedFilter,
                  onFilterSelected: (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                ),
                SizedBox(height: 14),
                _NotificationListCard(items: visibleNotifications),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationFilters extends StatelessWidget {
  const _NotificationFilters({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          label: 'All',
          active: selectedFilter == 'All',
          onTap: () => onFilterSelected('All'),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: 'Payments',
          active: selectedFilter == 'Payments',
          onTap: () => onFilterSelected('Payments'),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: 'Applications',
          active: selectedFilter == 'Applications',
          onTap: () => onFilterSelected('Applications'),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: 'System',
          active: selectedFilter == 'System',
          onTap: () => onFilterSelected('System'),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

class _NotificationListCard extends StatelessWidget {
  const _NotificationListCard({required this.items});

  final List<_NotificationData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        children: items.isEmpty
            ?[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No notifications in this category.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ]
            : [
                for (var i = 0; i < items.length; i++) ...[
                  _NotificationItem(
                    title: items[i].title,
                    subtitle: items[i].subtitle,
                    timeAgo: items[i].timeAgo,
                    icon: items[i].icon,
                    showCheck: items[i].showCheck,
                  ),
                  if (i != items.length - 1)
                    const Divider(height: 1, color: Color(0xFFDDE3EA)),
                ],
              ],
      ),
    );
  }
}

class _NotificationData {
  const _NotificationData({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.icon,
    required this.category,
    this.showCheck = false,
  });

  final String title;
  final String subtitle;
  final String timeAgo;
  final IconData icon;
  final String category;
  final bool showCheck;
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
          const SizedBox(width: 8),
          SizedBox(
            width: 56,
            child: Text(
              timeAgo,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF6F8094),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            height: 28,
            child: showCheck
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9EDF2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF9AAABC),
                      size: 16,
                    ),
                  )
                : null,
          ),
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
