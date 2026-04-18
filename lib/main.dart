import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'chat_assistant_fab.dart';
import 'service.dart';
import 'application.dart';
import 'payment.dart';
import 'notification.dart';
import 'profile.dart';
import 'settings.dart';
import 'register.dart';
import 'forgot_password.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeController = ThemeController();
  await themeController.loadThemeFromFirestore();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SmartGov',

          // ================= LIGHT THEME =================
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E446B),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          // ================= DARK THEME =================
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness:
                Brightness.dark, // Explicitly set for better icon contrast

            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6FA8DC),
              secondary: Color(0xFF4A90E2),
              surface: Color(
                0xFF1E293B,
              ), // Slightly lighter than background for depth
              background: Color(0xFF0F172A),
              onSurface: Colors.white,
              onBackground: Colors.white,
            ),

            scaffoldBackgroundColor: const Color(0xFF0F172A),

            // AppBar Theme
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F172A),
              foregroundColor: Colors.white,
              elevation: 0,
            ),

            // Card Theme (IMPROVED)
            cardTheme: const CardThemeData(
              color: Color(0xFF1E293B), // Raised surface color
              shadowColor: Colors.black54,
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),

            // Text Theme
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
              bodyMedium: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
              ), // Slate-400 for secondary text
              bodySmall: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              titleLarge: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Switch Theme
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected))
                  return const Color(0xFF6FA8DC);
                return const Color(0xFF94A3B8);
              }),
              trackColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected))
                  return const Color(0xFF1E446B);
                return const Color(0xFF334155);
              }),
            ),

            dividerTheme: const DividerThemeData(
              color: Color(0xFF334155),
              thickness: 1,
            ),
          ),
          // ================= THEME MODE =================
          themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,

          // ================= ROUTES =================
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? '/login'
              : '/dashboard',

          routes: {
            '/dashboard': (_) => const DashboardPage(),
            '/services': (_) => const ServicePage(),
            '/applications': (_) => const ApplicationPage(),
            '/payments': (_) => const PaymentPage(),
            '/notifications': (_) => const NotificationPage(),
            '/profile': (_) => const ProfilePage(),
            '/settings': (_) => const SettingsPage(),
            '/login': (_) => const LoginPage(),
            // '/tax': (context) => const TaxPage(),
            // '/epf': (context) => const EPFPage(),
            // '/ptptn': (context) => const PTPTNPage(),
            // '/jpj': (context) => const JPJPage(),
            // '/health': (context) => const HealthPage(),
            // '/pdrm': (context) => const PDRMPage(),
          },
        );
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1100;
          final panelHeight = math.min(760.0, constraints.maxHeight - 24);

          return Center(
            child: Container(
              margin: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxWidth: 1700),
              height: panelHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 22,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isDesktop
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 1, child: _BrandPanel()),
                          Expanded(flex: 1, child: _LoginPanel()),
                        ],
                      )
                    : const _LoginPanel(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF153B60), Color(0xFF214F7B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -80,
            top: -70,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7C51A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF123A61),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'SmartGOV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Your one-stop portal for all government services.\nSecure, simple, and smart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 20,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 42),
                Text(
                  'Secure Login | my MyDigital ID | Fast Access',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontSize: 15,
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

enum _LoginMode { myDigitalId, manual }

class _LoginPanel extends StatefulWidget {
  const _LoginPanel();

  @override
  State<_LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<_LoginPanel> {
  _LoginMode _loginMode = _LoginMode.myDigitalId;
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  void _showQrPopup(String sessionId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "MyDigital ID Scan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Waiting for authentication...",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: QrImageView(
                    data: sessionId,
                    version: QrVersions.auto,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF1F4468),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(strokeWidth: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDashboard(String userId) {
    Navigator.of(context).pushReplacementNamed('/dashboard', arguments: userId);
  }

  Future<void> loginWithQr(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid QR User')));
        return;
      }
      _openDashboard(userId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('QR Login Failed')));
    }
  }

  Future<void> _handleQrLoginFlow() async {
    final String sessionId = "sess_${DateTime.now().millisecondsSinceEpoch}";

    // 1. Create temporary session for the UI
    await FirebaseFirestore.instance
        .collection('qr_sessions')
        .doc(sessionId)
        .set({'status': 'waiting', 'createdAt': FieldValue.serverTimestamp()});

    if (!mounted) return;
    _showQrPopup(sessionId);

    // 2. THE DEMO SHORTCUT: Directly use Kelvin's UID
    const String kelvinUid = "QkP13R7eWNUB2yeLlJUBFqVXBHv2";

    Future.delayed(const Duration(seconds: 5), () async {
      // Update session just to show "approved" in DB if you check it
      await FirebaseFirestore.instance
          .collection('qr_sessions')
          .doc(sessionId)
          .update({
            'status': 'approved',
            'scannedData': {'name': 'Kelvin Christ', 'ic': '012345678910'},
          });

      if (mounted) {
        Navigator.pop(context); // Close Popup
        _openDashboard(kelvinUid); // Go straight to Kelvin's profile
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Color(0xFF1B2A3A),
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to access your government services',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.52),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _LoginSwitch(
                    selectedMode: _loginMode,
                    onChanged: (mode) {
                      setState(() {
                        _loginMode = mode;
                      });
                    },
                  ),
                  const SizedBox(height: 22),
                  if (_loginMode == _LoginMode.myDigitalId)
                    _buildMyDigitalSection(context)
                  else
                    _buildManualSection(context),
                  const SizedBox(height: 24),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.52),
                          fontSize: 12,
                        ),
                        children: const [
                          TextSpan(text: 'By signing in, you agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(color: Color(0xFF1F4468)),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: Color(0xFF1F4468)),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyDigitalSection(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () => _handleQrLoginFlow(),
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDADDE2), width: 2),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 68,
                color: Color(0xFF1F4468),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Scan this QR code with your MyDigital ID app',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        const SizedBox(height: 18),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('or use OTP'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: otpController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone_android_outlined),
            hintText: 'Phone number',
            filled: true,
            fillColor: const Color(0xFFDADDE2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1F4468),
            ),
            onPressed: () async {
              String phone = otpController.text.trim();
              if (phone.isEmpty) return;
              bool sent = await _authService.sendOtp(phone);
              if (!sent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to send OTP')),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController otpInput = TextEditingController();
                  return AlertDialog(
                    title: const Text("Enter OTP"),
                    content: TextField(
                      controller: otpInput,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Enter OTP"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          bool success = await _authService.verifyOtp(
                            otpInput.text,
                          );
                          if (success) {
                            Navigator.pop(context);
                            await Provider.of<ThemeController>(
                              context,
                              listen: false,
                            ).loadThemeFromFirestore();
                            final uid =
                                FirebaseAuth.instance.currentUser?.uid ?? phone;
                            _openDashboard(uid);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid OTP')),
                            );
                          }
                        },
                        child: const Text("Verify"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Send OTP'),
          ),
        ),
      ],
    );
  }

  Widget _buildManualSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'IC Number/Email',
          style: TextStyle(
            color: Color(0xFF2E3C4D),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail_outline),
            hintText: 'Enter your IC/email',
            filled: true,
            fillColor: const Color(0xFFEDEFF2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Password',
          style: TextStyle(
            color: Color(0xFF2E3C4D),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Enter password',
            filled: true,
            fillColor: const Color(0xFFEDEFF2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: Color(0xFF1F4468),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1F4468),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              String input = emailController.text.trim();
              String password = passwordController.text.trim();
              if (input.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }
              setState(() => _isLoading = true);
              try {
                bool success = await _authService.login(input, password);
                setState(() => _isLoading = false);
                if (success) {
                  await Provider.of<ThemeController>(
                    context,
                    listen: false,
                  ).loadThemeFromFirestore();
                  final uid = FirebaseAuth.instance.currentUser?.uid ?? input;
                  _openDashboard(uid);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid credentials')),
                  );
                }
              } catch (e) {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Login error')));
              }
            },
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Sign In →',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              );
            },
            child: const Text(
              "Don't have an account? Sign Up",
              style: TextStyle(
                color: Color(0xFF1F4468),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class _LoginSwitch extends StatelessWidget {
  const _LoginSwitch({required this.selectedMode, required this.onChanged});

  final _LoginMode selectedMode;
  final ValueChanged<_LoginMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAEE),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _SwitchItem(
              label: 'MyDigital ID',
              isSelected: selectedMode == _LoginMode.myDigitalId,
              onTap: () => onChanged(_LoginMode.myDigitalId),
            ),
          ),
          Expanded(
            child: _SwitchItem(
              label: 'Manual Login',
              isSelected: selectedMode == _LoginMode.manual,
              onTap: () => onChanged(_LoginMode.manual),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchItem extends StatelessWidget {
  const _SwitchItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                )
              : null,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF2A3A4C)
                  : const Color(0xFF768392),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                const SizedBox(width: 220, child: _DashboardSidebar()),
                Expanded(
                  child: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: const _DashboardBody(),
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

class _DashboardSidebar extends StatelessWidget {
  const _DashboardSidebar();

  static const _items = [
    _SideNavItem('Dashboard', Icons.dashboard_outlined, true),
    _SideNavItem('Services', Icons.grid_view_outlined, false),
    _SideNavItem('My Applications', Icons.description_outlined, false),
    _SideNavItem('Payments', Icons.account_balance_wallet_outlined, false),
    _SideNavItem('Notifications', Icons.notifications_none_outlined, false),
    _SideNavItem('Profile', Icons.person_outline, false),
    _SideNavItem('Settings', Icons.settings_outlined, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF214B74),
      child: Column(
        children: [
          // ================= HEADER =================
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

          // ================= MENU =================
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
                        if (item.title == 'Services') {
                          Navigator.pushReplacementNamed(context, '/services');
                        }
                        if (item.title == 'My Applications') {
                          Navigator.pushReplacementNamed(
                            context,
                            '/applications',
                          );
                        }
                        if (item.title == 'Payments') {
                          Navigator.pushReplacementNamed(context, '/payments');
                        }
                        if (item.title == 'Notifications') {
                          Navigator.pushReplacementNamed(
                            context,
                            '/notifications',
                          );
                        }
                        if (item.title == 'Profile') {
                          Navigator.pushReplacementNamed(context, '/profile');
                        }
                        if (item.title == 'Settings') {
                          Navigator.pushReplacementNamed(context, '/settings');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // ================= LOGOUT (FIXED) =================
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

class _DashboardBody extends StatefulWidget {
  const _DashboardBody();

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody> {
  String _userName = 'Ahmad'; // Default fallback
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // 1. Get UID from navigation arguments or Firebase Auth
      final String? args =
          ModalRoute.of(context)?.settings.arguments as String?;
      final String? authUid = FirebaseAuth.instance.currentUser?.uid;

      // Fallback to Kelvin's UID if testing the QR demo
      final String uid = args ?? authUid ?? "QkP13R7eWNUB2yeLlJUBFqVXBHv2";

      // 2. Fetch the name from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        setState(() {
          _userName = doc.data()!['name'] ?? 'User';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error loading user name: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Pagi, $_userName 👋', // ✅ Now Dynamic
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Here's your government services overview",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/notifications');
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9EDF2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_outlined,
                        color: Color(0xFF607489),
                        size: 19,
                      ),
                    ),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '4',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _TopStatCard(
                  icon: Icons.attach_money,
                  iconColor: Color(0xFF2ECC71),
                  iconBg: Color(0xFFE8F6EE),
                  title: 'Tax Status',
                  value: 'Filed',
                  subtitle: 'YA 2024 — MyTax',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _TopStatCard(
                  icon: Icons.account_balance,
                  iconColor: Color(0xFF3DA5F5),
                  iconBg: Color(0xFFE8F4FE),
                  title: 'EPF Balance',
                  value: 'RM 45,230',
                  subtitle: 'Last updated today',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _TopStatCard(
                  icon: Icons.favorite_border,
                  iconColor: Color(0xFFF5A623),
                  iconBg: Color(0xFFFFF3E6),
                  title: 'Health',
                  value: '1 Appointment',
                  subtitle: 'KKM — 15 Apr 2026',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _TopStatCard(
                  icon: Icons.school_outlined,
                  iconColor: Color(0xFFE57373),
                  iconBg: Color(0xFFFDEDEE),
                  title: 'PTPTN Loan',
                  value: 'RM 12,800',
                  subtitle: 'Remaining balance',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Expanded(
            child: Row(
              children: [
                Expanded(flex: 2, child: _NotificationsPanel()),
                SizedBox(width: 14),
                Expanded(flex: 1, child: _QuickActionsPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopStatCard extends StatelessWidget {
  const _TopStatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const Spacer(),
              const Icon(Icons.north_east, color: Color(0xFF7C8EA2), size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF7F8F9F), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _NotificationsPanel extends StatelessWidget {
  const _NotificationsPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
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
              Text(
                'Notifications',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/notifications');
                },
                child: const Text(
                  'View all →',
                  style: TextStyle(
                    color: Color(0xFF355977),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: const [
                _NoticeTile(
                  icon: Icons.directions_car_outlined,
                  iconColor: Color(0xFFF04E4E),
                  iconBg: Color(0xFFFDEDEE),
                  title: 'Road tax renewal due in 5 days',
                  subtitle: 'JPJ - Renew before 19 Apr 2026',
                  urgent: true,
                ),
                SizedBox(height: 10),
                _NoticeTile(
                  icon: Icons.warning_amber_outlined,
                  iconColor: Color(0xFFF04E4E),
                  iconBg: Color(0xFFFDEDEE),
                  title: 'Traffic summons payment due soon',
                  subtitle: 'PDRM - Due by 16 Apr 2026',
                  urgent: true,
                ),
                SizedBox(height: 10),
                _NoticeTile(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: Color(0xFF2ECC71),
                  iconBg: Color(0xFFE8F6EE),
                  title: 'STR Phase 2 payment credited',
                  subtitle: 'LHDN - RM 300 credited to bank account',
                ),
                SizedBox(height: 10),
                _NoticeTile(
                  icon: Icons.event_available_outlined,
                  iconColor: Color(0xFF2ECC71),
                  iconBg: Color(0xFFE8F6EE),
                  title: 'Passport renewal appointment confirmed',
                  subtitle: 'JIM - 22 Apr 2026, UTC Pudu',
                ),
                SizedBox(height: 10),
                _NoticeTile(
                  icon: Icons.school_outlined,
                  iconColor: Color(0xFF3DA5F5),
                  iconBg: Color(0xFFE8F4FE),
                  title: 'PTPTN payment due in 3 days',
                  subtitle: 'PTPTN - RM 120 due on 17 Apr 2026',
                ),
                SizedBox(height: 10),
                _NoticeTile(
                  icon: Icons.local_hospital_outlined,
                  iconColor: Color(0xFFF5A623),
                  iconBg: Color(0xFFFFF3E6),
                  title: 'Clinic appointment reminder',
                  subtitle: 'KKM - 18 Apr 2026, Klinik Kesihatan Cheras',
                ),
                SizedBox(height: 10),
                _NoticeTile(
                  icon: Icons.badge_outlined,
                  iconColor: Color(0xFF3DA5F5),
                  iconBg: Color(0xFFE8F4FE),
                  title: 'MyKad address update pending verification',
                  subtitle: 'JPN - Submit utility bill to complete request',
                ),
                SizedBox(height: 10),
                _NoticeTile(
                  icon: Icons.receipt_long_outlined,
                  iconColor: Color(0xFF2ECC71),
                  iconBg: Color(0xFFE8F6EE),
                  title: 'Income tax e-Receipt available',
                  subtitle: 'LHDN - YA2025 filing receipt ready to download',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.urgent = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? (urgent
                  ? Colors.red.withValues(alpha: 0.12)
                  : const Color(0xFF273449)) // darker tile
            : (urgent ? const Color(0xFFF9EFF0) : const Color(0xFFF0F3F6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? iconColor.withValues(alpha: 0.15) : iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (urgent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.red.withValues(alpha: 0.2)
                    : const Color(0xFFF8D6D8),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Urgent',
                style: TextStyle(
                  color: Color(0xFFF04E4E),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Quick Actions',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.2,
              children: [
                _QuickActionTile(
                  label: 'Pay Summons',
                  icon: Icons.credit_card_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceActionPage(
                          // Now accessible because we removed the '_'
                          item: ServiceItem(
                            title:
                                'Summons Payment', // This string triggers _isSummonsPayment in your form
                            subtitle: 'PDRM / JPJ',
                            icon: Icons.credit_card_outlined,
                            iconBg: const Color(0xFFE8F4FE),
                            iconColor: const Color(0xFF3DA5F5),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                _QuickActionTile(
                  label: 'Renew License',
                  icon: Icons.badge_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceActionPage(
                          item: ServiceItem(
                            title: 'License Renewal',
                            subtitle: 'JPJ',
                            icon: Icons.badge_outlined,
                            iconBg: const Color(0xFFE8F4FE),
                            iconColor: const Color(0xFF3DA5F5),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                _QuickActionTile(
                  label: 'Book Clinic',
                  icon: Icons.event_note_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceActionPage(
                          item: ServiceItem(
                            title: 'Health Services',
                            subtitle: 'KKM',
                            icon: Icons.event_note_outlined,
                            iconBg: const Color(0xFFE8F4FE),
                            iconColor: const Color(0xFF3DA5F5),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                _QuickActionTile(
                  label: 'Check EPF',
                  icon: Icons.account_balance,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceActionPage(
                          item: ServiceItem(
                            title: 'EPF Management',
                            subtitle: 'KWSP',
                            icon: Icons.event_note_outlined,
                            iconBg: const Color(0xFFE8F4FE),
                            iconColor: const Color(0xFF3DA5F5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap, // ✅ added
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF273449) : const Color(0xFFE9EDF2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : const Color(0xFFD8E0EA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDark
                    ? theme.colorScheme.primary
                    : const Color(0xFF2D4A68),
                size: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isDark
                    ? theme.colorScheme.onSurface
                    : const Color(0xFF2A3E55),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SideNavItem {
  const _SideNavItem(this.title, this.icon, this.active);

  final String title;
  final IconData icon;
  final bool active;
}
