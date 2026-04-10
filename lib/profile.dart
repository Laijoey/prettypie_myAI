import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                  child: _ProfileSidebar(),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Color(0xFFF5F5F7),
                    child: _ProfileBody(),
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

class _ProfileSidebar extends StatelessWidget {
  const _ProfileSidebar();

  static const _items = [
    _ProfileNavItem('Dashboard', Icons.dashboard_outlined, false),
    _ProfileNavItem('Services', Icons.grid_view_outlined, false),
    _ProfileNavItem('My Applications', Icons.description_outlined, false),
    _ProfileNavItem('Payments', Icons.account_balance_wallet_outlined, false),
    _ProfileNavItem('Notifications', Icons.notifications_none_outlined, false),
    _ProfileNavItem('Profile', Icons.person_outline, true),
    _ProfileNavItem('Settings', Icons.settings_outlined, false),
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
                        if (item.title == 'Notifications') {
                          Navigator.of(context).pushReplacementNamed('/notifications');
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

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Profile',
            style: TextStyle(
              color: Color(0xFF1E2D3F),
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD9DEE5)),
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    _AvatarBox(),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ahmad bin Abdullah',
                          style: TextStyle(
                            color: Color(0xFF1E2D3F),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'MyKad: 900101-14-5678',
                          style: TextStyle(
                            color: Color(0xFF6F8094),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _InfoLine(
                        icon: Icons.location_on_outlined,
                        text: 'No. 12, Jln Bukit Bintang, KL',
                      ),
                    ),
                    Expanded(
                      child: _InfoLine(
                        icon: Icons.phone_outlined,
                        text: '012-345 6789',
                      ),
                    ),
                    Expanded(
                      child: _InfoLine(
                        icon: Icons.mail_outline,
                        text: 'ahmad@email.com',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _DocumentVaultCard()),
              SizedBox(width: 12),
              Expanded(child: _LinkedServicesCard()),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PaymentHistoryCard()),
              SizedBox(width: 12),
              Expanded(child: _PrivacyControlCard()),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarBox extends StatelessWidget {
  const _AvatarBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFD9DEE5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.person_outline, size: 34, color: Color(0xFF214B74)),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF7A8B9D)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6F8094),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF214B74), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E2D3F),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DocumentVaultCard extends StatelessWidget {
  const _DocumentVaultCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionCard(
      title: 'Document Vault',
      icon: Icons.description_outlined,
      child: Column(
        children: [
          _SimpleListTile(
            title: 'Identity Card (MyKad)',
            subtitle: 'ID - Uploaded 01 Jan 2025',
          ),
          SizedBox(height: 8),
          _SimpleListTile(
            title: 'Income Statement 2024',
            subtitle: 'Finance - Uploaded 15 Mar 2025',
          ),
          SizedBox(height: 8),
          _SimpleListTile(
            title: 'SPM Certificate',
            subtitle: 'Education - Uploaded 20 Jun 2023',
          ),
        ],
      ),
    );
  }
}

class _SimpleListTile extends StatelessWidget {
  const _SimpleListTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F6),
        borderRadius: BorderRadius.circular(10),
      ),
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
    );
  }
}

class _LinkedServicesCard extends StatelessWidget {
  const _LinkedServicesCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionCard(
      title: 'Linked Services',
      icon: Icons.link_outlined,
      child: Column(
        children: [
          _LinkStatusTile(name: 'Tax Records', agency: 'LHDN', linked: true),
          SizedBox(height: 8),
          _LinkStatusTile(name: 'EPF Information', agency: 'KWSP', linked: true),
          SizedBox(height: 8),
          _LinkStatusTile(name: 'Subsidy Data', agency: 'PADU', linked: true),
          SizedBox(height: 8),
          _LinkStatusTile(name: 'Health Records', agency: 'KKM', linked: false),
        ],
      ),
    );
  }
}

class _LinkStatusTile extends StatelessWidget {
  const _LinkStatusTile({required this.name, required this.agency, required this.linked});

  final String name;
  final String agency;
  final bool linked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1E2D3F),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  agency,
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
              color: linked ? const Color(0xFFE4F6EC) : const Color(0xFFE6EBF1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              linked ? 'Linked' : 'Not Linked',
              style: TextStyle(
                color: linked ? const Color(0xFF2DBE63) : const Color(0xFF7A8B9D),
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

class _PaymentHistoryCard extends StatelessWidget {
  const _PaymentHistoryCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionCard(
      title: 'Payment History',
      icon: Icons.credit_card_outlined,
      child: Column(
        children: [
          _PaymentHistoryTile(
            item: 'Traffic Summons',
            amount: 'RM 150.00',
            date: '20 Mar 2026',
          ),
          SizedBox(height: 8),
          _PaymentHistoryTile(
            item: 'PTPTN Repayment',
            amount: 'RM 200.00',
            date: '15 Mar 2026',
          ),
          SizedBox(height: 8),
          _PaymentHistoryTile(
            item: 'Road Tax',
            amount: 'RM 90.00',
            date: '1 Feb 2026',
          ),
        ],
      ),
    );
  }
}

class _PaymentHistoryTile extends StatelessWidget {
  const _PaymentHistoryTile({
    required this.item,
    required this.amount,
    required this.date,
  });

  final String item;
  final String amount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item,
              style: const TextStyle(
                color: Color(0xFF1E2D3F),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Color(0xFF1E2D3F),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF6F8094),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrivacyControlCard extends StatefulWidget {
  const _PrivacyControlCard();

  @override
  State<_PrivacyControlCard> createState() => _PrivacyControlCardState();
}

class _PrivacyControlCardState extends State<_PrivacyControlCard> {
  bool _lhdn = true;
  bool _kwsp = true;
  bool _padu = false;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Privacy Control',
      icon: Icons.shield_outlined,
      child: Column(
        children: [
          _PrivacyRow(
            title: 'Data sharing with LHDN',
            subtitle: 'Tax and income data',
            value: _lhdn,
            onChanged: (value) {
              setState(() {
                _lhdn = value;
              });
            },
          ),
          const SizedBox(height: 8),
          _PrivacyRow(
            title: 'Data sharing with KWSP',
            subtitle: 'Employment and EPF data',
            value: _kwsp,
            onChanged: (value) {
              setState(() {
                _kwsp = value;
              });
            },
          ),
          const SizedBox(height: 8),
          _PrivacyRow(
            title: 'Data sharing with PADU',
            subtitle: 'Subsidy eligibility data',
            value: _padu,
            onChanged: (value) {
              setState(() {
                _padu = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2DBE63),
        ),
      ],
    );
  }
}

class _ProfileNavItem {
  const _ProfileNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}
