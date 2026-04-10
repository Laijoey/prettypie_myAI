import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

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
                  child: _ServicesSidebar(),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Color(0xFFF5F5F7),
                    child: _ServicesBody(),
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

class _ServicesSidebar extends StatelessWidget {
  const _ServicesSidebar();

  static const _items = [
    _ServiceNavItem('Dashboard', Icons.dashboard_outlined, false),
    _ServiceNavItem('Services', Icons.grid_view_outlined, true),
    _ServiceNavItem('My Applications', Icons.description_outlined, false),
    _ServiceNavItem('Payments', Icons.account_balance_wallet_outlined, false),
    _ServiceNavItem('Notifications', Icons.notifications_none_outlined, false),
    _ServiceNavItem('Profile', Icons.person_outline, false),
    _ServiceNavItem('Settings', Icons.settings_outlined, false),
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
                        if (item.title == 'My Applications') {
                          Navigator.of(context).pushReplacementNamed('/applications');
                        }
                        if (item.title == 'Payments') {
                          Navigator.of(context).pushReplacementNamed('/payments');
                        }
                        if (item.title == 'Notifications') {
                          Navigator.of(context).pushReplacementNamed('/notifications');
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

class _ServicesBody extends StatelessWidget {
  const _ServicesBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 28),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Government Services',
                  style: TextStyle(
                    color: Color(0xFF1E2D3F),
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Access all government services in one place',
                  style: TextStyle(
                    color: Color(0xFF6B7B8D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                _SearchServicesField(),
                SizedBox(height: 20),
                _ServiceSectionTitle('Popular Services'),
                SizedBox(height: 10),
                _ServiceGrid(popular: true),
                SizedBox(height: 18),
                _ServiceSectionTitle('All Services'),
                SizedBox(height: 10),
                _ServiceGrid(popular: false),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchServicesField extends StatelessWidget {
  const _SearchServicesField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search services... (e.g. renew license, check tax, apply bantuan)',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color(0xFFF2F4F7),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD9DEE5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD9DEE5)),
        ),
      ),
    );
  }
}

class _ServiceSectionTitle extends StatelessWidget {
  const _ServiceSectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF1E2D3F),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({required this.popular});

  final bool popular;

  @override
  Widget build(BuildContext context) {
    final items = popular ? _popularItems : _allItems;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 84,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _ServiceTile(item: item, showArrow: popular);
      },
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.item, required this.showArrow});

  final _ServiceItem item;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF1E2D3F),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7D8D9D),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF7D8D9D), size: 14),
        ],
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
}

const List<_ServiceItem> _popularItems = [
  _ServiceItem(
    title: 'Tax Filing',
    subtitle: 'LHDN / MyTax',
    icon: Icons.attach_money,
    iconColor: Color(0xFF2ECC71),
    iconBg: Color(0xFFE8F6EE),
  ),
  _ServiceItem(
    title: 'EPF Management',
    subtitle: 'KWSP',
    icon: Icons.account_balance,
    iconColor: Color(0xFF3DA5F5),
    iconBg: Color(0xFFE8F4FE),
  ),
  _ServiceItem(
    title: 'Health Services',
    subtitle: 'KKM',
    icon: Icons.favorite_border,
    iconColor: Color(0xFFF5A623),
    iconBg: Color(0xFFFFF3E6),
  ),
  _ServiceItem(
    title: 'Loan Payment',
    subtitle: 'PTPTN',
    icon: Icons.school_outlined,
    iconColor: Color(0xFFE57373),
    iconBg: Color(0xFFFDEDEE),
  ),
  _ServiceItem(
    title: 'License Renewal',
    subtitle: 'JPJ',
    icon: Icons.directions_car_outlined,
    iconColor: Color(0xFF607489),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Summons Payment',
    subtitle: 'PDRM',
    icon: Icons.warning_amber_outlined,
    iconColor: Color(0xFFF5A623),
    iconBg: Color(0xFFFFF3E6),
  ),
];

const List<_ServiceItem> _allItems = [
  _ServiceItem(
    title: 'Birth Certificate',
    subtitle: 'JPN',
    icon: Icons.description_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Housing Application',
    subtitle: 'PR1MA',
    icon: Icons.home_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Social Welfare',
    subtitle: 'JKM',
    icon: Icons.people_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Business Registration',
    subtitle: 'SSM',
    icon: Icons.work_outline,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Legal Aid',
    subtitle: 'BHEUU',
    icon: Icons.balance_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
  _ServiceItem(
    title: 'Passport Renewal',
    subtitle: 'JIM',
    icon: Icons.flight_outlined,
    iconColor: Color(0xFF7D8D9D),
    iconBg: Color(0xFFE9EDF2),
  ),
];

class _ServiceNavItem {
  const _ServiceNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}
