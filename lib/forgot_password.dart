import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSent = false; // To toggle between input and success message

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _resetPassword() async {
  String email = emailController.text.trim();

  if (email.isEmpty || !email.contains('@')) {
    _showError("Please enter a valid email address");
    return;
  }

  setState(() => _isLoading = true);

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );

    setState(() {
      _isLoading = false;
      _isSent = true;
    });
  } catch (e) {
    setState(() => _isLoading = false);

    _showError("Failed to send reset email. Check email exists.");
  }
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
          constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 600),
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
                // 🔵 LEFT BRAND PANEL (Consistent with Register Page)
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
                          child: const Icon(Icons.lock_reset_outlined,
                              size: 40, color: Color(0xFF153B60)),
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
                          "Trouble logging in?\nWe'll help you get back into your account safely.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "Secure Recovery | Identity Verified",
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                // ⚪ RIGHT FORM PANEL
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                    child: Center(
                      child: SingleChildScrollView(
                        child: _isSent ? _buildSuccessState() : _buildInputState(),
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

  // State 1: Enter Email
  Widget _buildInputState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Forgot Password?",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF153B60)),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your email address and we'll send you a link to reset your password.",
          style: TextStyle(color: Colors.grey[600], height: 1.4),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration("Email Address", Icons.email_outlined),
        ),
        const SizedBox(height: 35),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF153B60),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Send Reset Link →",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Back to Login",
              style: TextStyle(color: Color(0xFF153B60), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // State 2: Success Message
  Widget _buildSuccessState() {
    return Column(
      children: [
        const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
        const SizedBox(height: 24),
        const Text(
          "Check Your Email",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF153B60)),
        ),
        const SizedBox(height: 12),
        Text(
          "We have sent a password recovery link to:\n${emailController.text}",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], height: 1.4),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF153B60)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Return to Login",
                style: TextStyle(color: Color(0xFF153B60), fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}