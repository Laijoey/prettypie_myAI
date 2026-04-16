import 'package:flutter/material.dart';
import 'chat_assistant_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,

    // ✅ MUST BE HERE (outside body)
    floatingActionButton: const ChatAssistantFab(),

    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // ================= SIDEBAR =================
              const SizedBox(
                width: 220,
                child: _SettingsSidebar(),
              ),

              // ================= MAIN CONTENT =================
              Expanded(
                child: ColoredBox(
                  color: isDark
                      ? theme.scaffoldBackgroundColor
                      : const Color(0xFFF5F5F7),
                  child: const _SettingsBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class _SettingsSidebar extends StatelessWidget {
  const _SettingsSidebar();

  static const _items = [
    _SettingsNavItem('Dashboard', Icons.dashboard_outlined, false),
    _SettingsNavItem('Services', Icons.grid_view_outlined, false),
    _SettingsNavItem('My Applications', Icons.description_outlined, false),
    _SettingsNavItem('Payments', Icons.account_balance_wallet_outlined, false),
    _SettingsNavItem('Notifications', Icons.notifications_none_outlined, false),
    _SettingsNavItem('Profile', Icons.person_outline, false),
    _SettingsNavItem('Settings', Icons.settings_outlined, true),
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
                        if (item.title == 'Profile') {
                          Navigator.of(context).pushReplacementNamed('/profile');
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

class _SettingsBody extends StatefulWidget {
  const _SettingsBody();

  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  // ================= STATE =================
  bool _biometricLogin = true;
  bool _emailAlert = true;
  bool _smsAlert = false;
  bool _darkMode = false;

  String _language = 'English (Malaysia)';
  String _region = 'Kuala Lumpur';

  bool _loading = true;

  final List<String> _languages = [
    'English (Malaysia)',
    'Bahasa Melayu',
    'Chinese'
  ];

  final List<String> _regions = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Perak',
    'Perlis',
    'Pulau Pinang',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
    'Putrajaya',
    'Labuan',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ================= LOAD =================
  Future<void> _loadSettings() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;

      final theme = Provider.of<ThemeController>(
        context,
        listen: false,
      );

      setState(() {
        _biometricLogin = data['biometric'] ?? true;
        _emailAlert = data['emailAlert'] ?? true;
        _smsAlert = data['smsAlert'] ?? false;
        _darkMode = data['darkMode'] ?? false;
        _language = data['language'] ?? _language;
        _region = data['region'] ?? _region;
      });

      // ✅ APPLY DARK MODE HERE (after data exists)
      theme.setDarkMode(data['darkMode'] ?? false);
    }
  } catch (e) {
    print("ERROR: $e");
  } finally {
    setState(() => _loading = false);
  }
}

  // ================= SAVE =================
  Future<void> _saveSettings() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set({
    'biometric': _biometricLogin,
    'emailAlert': _emailAlert,
    'smsAlert': _smsAlert,
    'darkMode': _darkMode,
    'language': _language,
    'region': _region,
  }, SetOptions(merge: true)); // ✅ IMPORTANT

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Settings saved')),
  );
}

  // ================= CHANGE PASSWORD =================
  Future<void> _changePasswordDialog() async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "Enter new password",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.currentUser!
                    .updatePassword(controller.text);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password updated")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          // ================= ACCOUNT =================
          const _SettingsSectionTitle('Account'),
          const SizedBox(height: 10),

          _SettingsCard(
            children: [
              // LANGUAGE
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField(
                  value: _language,
                  items: _languages
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _language = value!);
                  },
                  decoration: const InputDecoration(
                    labelText: "Preferred Language",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // REGION
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField(
                  value: _region,
                  items: _regions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _region = value!);
                  },
                  decoration: const InputDecoration(
                    labelText: "Region",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ================= SECURITY =================
          const _SettingsSectionTitle('Security'),
          const SizedBox(height: 10),

          _SettingsCard(
            children: [
              _ToggleRow(
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or face ID',
                value: _biometricLogin,
                onChanged: (v) => setState(() => _biometricLogin = v),
              ),
              const Divider(),

              ListTile(
                title: const Text("Change Password"),
                subtitle: const Text("Update your account password"),
                trailing: const Icon(Icons.chevron_right),
                onTap: _changePasswordDialog,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ================= NOTIFICATIONS =================
          const _SettingsSectionTitle('Notifications'),
          const SizedBox(height: 10),

          _SettingsCard(
            children: [
              _ToggleRow(
                title: 'Email Alerts',
                subtitle: 'Get updates by email',
                value: _emailAlert,
                onChanged: (v) => setState(() => _emailAlert = v),
              ),
              const Divider(),

              _ToggleRow(
                title: 'SMS Alerts',
                subtitle: 'Receive SMS reminders',
                value: _smsAlert,
                onChanged: (v) => setState(() => _smsAlert = v),
              ),
              const Divider(),

              _ToggleRow(
                title: 'Dark Mode',
                subtitle: 'Enable dark theme',
                value: _darkMode,
                onChanged: (v) {
                  setState(() => setState(() => _darkMode = v));
                  Provider.of<ThemeController>(context, listen: false)
                  .setDarkMode(v);
                }
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ================= SAVE =================
          SizedBox(
            width: 180,
            height: 44,
            child: FilledButton(
              onPressed: _saveSettings,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1F4468),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
  fontSize: 18, // Overriding only the size if needed
  fontWeight: FontWeight.w700,
),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DEE5)),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF5F738A),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2DBE63),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Password',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Update your account password',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Color(0xFF7D8D9D)),
        ],
      ),
    );
  }
}

class _SettingsNavItem {
  const _SettingsNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}

class ThemeController extends ChangeNotifier {
  bool isDark = false;

  void setDarkMode(bool value) {
    isDark = value;
    notifyListeners();
  }

  // ✅ LOAD FROM FIRESTORE
  Future<void> loadThemeFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        isDark = data['darkMode'] ?? false;
        notifyListeners(); // 🔥 triggers UI update
      }
    } catch (e) {
      print("Theme load error: $e");
    }
  }
}