import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController icController = TextEditingController(); // ✅ ADDED
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  bool _validateEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> register() async {
    String ic = icController.text.trim(); // ✅ ADDED
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // ================= VALIDATION =================
    if (ic.isEmpty) {
      _showError("IC Number is required");
      return;
    }

    if (ic.length < 8) {
      _showError("Invalid IC Number");
      return;
    }

    if (!_validateEmail(email)) {
      _showError("Invalid email format");
      return;
    }

    if (password.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? error = await _authService.register(
        ic: ic, 
        email: email, 
        password: password
        );

      setState(() => _isLoading = false);

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );
        Navigator.pop(context);
      } else {
        _showError(error);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("Something went wrong. Please try again.");
    }
  }

  @override
  void dispose() {
    icController.dispose(); // ✅ ADDED
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFEDEFF2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 650),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [

                // 🔵 LEFT PANEL (UNCHANGED)
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF153B60), Color(0xFF214F7B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCC00),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            size: 40,
                            color: Color(0xFF153B60),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "SmartGOV",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Your one-stop portal for all government services.\nSecure, simple, and smart.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "Secure Login | myDigital ID | Fast Access",
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                // ⚪ RIGHT PANEL (ONLY IC ADDED)
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF153B60),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Join thousands of citizens today",
                              style: TextStyle(color: Colors.grey[600]),
                            ),

                            const SizedBox(height: 40),

                            // ================= IC FIELD (ADDED) =================
                            TextField(
                              controller: icController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration("IC Number", Icons.badge_outlined),
                            ),

                            const SizedBox(height: 20),

                            // EMAIL
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration("Email Address", Icons.email_outlined),
                            ),

                            const SizedBox(height: 20),

                            // PASSWORD
                            TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // CONFIRM PASSWORD
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: _inputDecoration("Confirm Password", Icons.verified_user_outlined).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 35),

                            // SIGN UP
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF153B60),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text("Sign Up →"),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
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