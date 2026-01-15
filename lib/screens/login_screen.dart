import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  bool isWhatsappUpdates = true;
  bool isTermsAccepted = true;
  bool _isPasswordVisible = false;

  void _handleLogin() async {
    print("🔘 Continue button pressed");

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!isTermsAccepted) {
      Get.snackbar("Error", "Please accept the Terms of Service to continue.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please accept the Terms of Service to continue."),
        ),
      );
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    print("📧 Email: $email");
    // print("🔑 Password: $password"); // Don't log passwords in production

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter both Email and Password.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both Email and Password.")),
      );
      return;
    }

    print("🚀 Calling AuthService.signIn...");
    final user = await _authService.signIn(email, password);
    print("🏁 AuthService.signIn completed. User: $user");

    if (user != null) {
      print("✅ Login Successful, Navigating to Home");
      Get.offAllNamed('/home');
    } else {
      final msg =
          _authService.errorMessage.value.isNotEmpty
              ? _authService.errorMessage.value
              : "Authentication failed";

      print("❌ Login Failed: $msg");
      Get.snackbar("Login Failed", msg);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - 48.0, // accounting for padding
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF242424),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email ID Field
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email ID",
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            suffixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // WhatsApp Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: isWhatsappUpdates,
                            activeColor: const Color(0xFF134044),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                isWhatsappUpdates = val ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              "Send me updates over WhatsApp",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Terms Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isTermsAccepted,
                            activeColor: const Color(0xFF134044),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                isTermsAccepted = val ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                  children: [
                                    const TextSpan(text: "I accept the "),
                                    TextSpan(
                                      text: "Terms of Service",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: " & "),
                                    TextSpan(
                                      text: "Privacy policy",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          ", which includes permission to securely share my data/documents with verified ",
                                    ),
                                    TextSpan(
                                      text: "partners",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " to process my application",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed:
                                _authService.isLoading.value
                                    ? null
                                    : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF134044),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                _authService.isLoading.value
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
