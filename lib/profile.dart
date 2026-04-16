import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                SizedBox(width: 220, child: _ProfileSidebar()),
                Expanded(
                  child: ColoredBox(
                    color: theme.scaffoldBackgroundColor,
                    child: _ProfileBody(),
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
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/dashboard');
                        }
                        if (item.title == 'Services') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/services');
                        }
                        if (item.title == 'My Applications') {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/applications');
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

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  final repo = ProfileRepository();
  Map<String, dynamic>? profile;
  List<Map<String, dynamic>> docs = [];

  // ================= CONTROLLERS =================
  final nameController = TextEditingController();
  final icController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = true;

  // ================= PRIVACY =================
  bool lhdn = true;
  bool kwsp = true;
  bool padu = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ================= LOAD FIREBASE =================
  Future<void> _loadProfile() async {
    profile = await repo.getUserProfile();
    docs = await repo.getUserDocuments();

    nameController.text = profile?['name'] ?? '';
    icController.text = profile?['ic'] ?? '';
    phoneController.text = profile?['phone'] ?? '';
    emailController.text = profile?['email'] ?? '';
    addressController.text = profile?['address'] ?? '';

    lhdn = profile?['share_lhdn'] ?? true;
    kwsp = profile?['share_kwsp'] ?? true;
    padu = profile?['share_padu'] ?? false;

    setState(() => isLoading = false);
  }

  // ================= SAVE FIREBASE =================
  Future<void> _saveProfile() async {

    await repo.updateProfile({
      'name': nameController.text,
      'ic': icController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'share_lhdn': lhdn,
      'share_kwsp': kwsp,
      'share_padu': padu,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  // ================= EDIT DIALOG =================
  void _openEditDialog() {
    final tempName = TextEditingController(text: nameController.text);
    final tempIc = TextEditingController(text: icController.text);
    final tempPhone = TextEditingController(text: phoneController.text);
    final tempEmail = TextEditingController(text: emailController.text);
    final tempAddress = TextEditingController(text: addressController.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _input(tempName, "Full Name"),
              _input(tempIc, "IC Number"),
              _input(tempPhone, "Phone"),
              _input(tempEmail, "Email"),
              _input(tempAddress, "Address"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // ✅ update controllers ONLY after save
              nameController.text = tempName.text;
              icController.text = tempIc.text;
              phoneController.text = tempPhone.text;
              emailController.text = tempEmail.text;
              addressController.text = tempAddress.text;

              await _saveProfile();

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          // ================= PROFILE CARD =================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD9DEE5)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const _AvatarBox(),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameController.text.isEmpty
                              ? 'No Name'
                              : nameController.text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'MyKad: ${icController.text}',
                          style: const TextStyle(
                            color: Color(0xFF6F8094),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _openEditDialog,
                    child: const Text("Edit"),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: _InfoLine(
                        icon: Icons.location_on_outlined,
                        text: addressController.text,
                      ),
                    ),
                    Expanded(
                      child: _InfoLine(
                        icon: Icons.phone_outlined,
                        text: phoneController.text,
                      ),
                    ),
                    Expanded(
                      child: _InfoLine(
                        icon: Icons.mail_outline,
                        text: emailController.text,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Expanded(child: _DocumentVaultCard()),
              const SizedBox(width: 12),
              const Expanded(child: _LinkedServicesCard()),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Expanded(child: _PaymentHistoryCard()),
              const SizedBox(width: 12),
              Expanded(
                child: _PrivacyControlCard(
                  lhdn: lhdn,
                  kwsp: kwsp,
                  padu: padu,
                  onChanged: (a, b, c) {
                    setState(() {
                      lhdn = a;
                      kwsp = b;
                      padu = c;
                    });
                    _saveProfile();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    icController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
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
      child: const Icon(
        Icons.person_outline,
        size: 34,
        color: Color(0xFF214B74),
      ),
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
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

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
          Row(
            children: [
              Icon(icon, color: const Color(0xFF214B74), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
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
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF273449) // lighter than card
            : theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
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
          _LinkStatusTile(
            name: 'EPF Information',
            agency: 'KWSP',
            linked: true,
          ),
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
  const _LinkStatusTile({
    required this.name,
    required this.agency,
    required this.linked,
  });

  final String name;
  final String agency;
  final bool linked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF273449) // lighter than card
            : theme.colorScheme.surfaceVariant.withOpacity(0.3),
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
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
                color: linked
                    ? const Color(0xFF2DBE63)
                    : const Color(0xFF7A8B9D),
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
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF273449) // lighter than card
            : theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
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
  final bool lhdn;
  final bool kwsp;
  final bool padu;
  final Function(bool, bool, bool) onChanged;

  const _PrivacyControlCard({
    required this.lhdn,
    required this.kwsp,
    required this.padu,
    required this.onChanged,
  });

  @override
  State<_PrivacyControlCard> createState() => _PrivacyControlCardState();
}

class _PrivacyControlCardState extends State<_PrivacyControlCard> {
  late bool _lhdn;
  late bool _kwsp;
  late bool _padu;

  @override
  void initState() {
    super.initState();
    _lhdn = widget.lhdn;
    _kwsp = widget.kwsp;
    _padu = widget.padu;
  }

  void _update() {
    widget.onChanged(_lhdn, _kwsp, _padu);
  }

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
              setState(() => _lhdn = value);
              _update();
            },
          ),
          const SizedBox(height: 8),
          _PrivacyRow(
            title: 'Data sharing with KWSP',
            subtitle: 'Employment and EPF data',
            value: _kwsp,
            onChanged: (value) {
              setState(() => _kwsp = value);
              _update();
            },
          ),
          const SizedBox(height: 8),
          _PrivacyRow(
            title: 'Data sharing with PADU',
            subtitle: 'Subsidy eligibility data',
            value: _padu,
            onChanged: (value) {
              setState(() => _padu = value);
              _update();
            },
          ),
        ],
      ),
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrivacyRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6F8094)),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF2DBE63),
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

class ProfileRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getUserProfile() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _db.collection('users').doc(uid).get();

    return doc.data() ?? {};
  }

  Future<List<Map<String, dynamic>>> getUserDocuments() async {
    final uid = _auth.currentUser!.uid;

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('documents')
        .get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final uid = _auth.currentUser!.uid;

    await _db.collection('users').doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
