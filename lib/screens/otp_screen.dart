// File: screens/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Timer for checking verification status
  Timer? _verificationTimer;
  Timer? _resendTimer;
  int _secondsRemaining = 60;
  bool _isResendEnabled = false;
  String _localError = '';

  // Get auth service
  final AuthService _authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Start checking for verification status
    _checkVerificationStatus();
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _secondsRemaining = 60;
    _isResendEnabled = false;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendEnabled = true;
          _resendTimer?.cancel();
        }
      });
    });
  }

  void _checkVerificationStatus() {
    // Check every 3 seconds if the email has been verified
    _verificationTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _authService.reloadUser();

      if (_authService.isEmailVerified()) {
        _verificationTimer?.cancel();
        Get.offAllNamed('/home');
      }
    });
  }

  void _resendOtp() async {
    if (!_isResendEnabled) return;

    setState(() {
      _localError = '';
    });

    bool success = await _authService.sendOTP();

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email resent to ${widget.email}'),
          backgroundColor: Colors.green,
        ),
      );

      // Restart timer
      _startResendTimer();
    }
  }

  // Manual verification check
  void _checkEmailVerification() async {
    await _authService.reloadUser();

    if (_authService.isEmailVerified()) {
      Get.offAllNamed('/home');
    } else {
      setState(() {
        _localError = 'Email not verified yet. Please check your inbox.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Black Header (40% of screen) - same as LoginScreen
                      Container(
                        height: screenHeight * 0.4,
                        width: double.infinity,
                        color: Colors.black,
                        padding: EdgeInsets.only(left: 20, bottom: 30),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Verify your\nemail address\nto continue.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // White Section
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.03),

                              // Email verification info
                              Text(
                                "We've sent a verification email to:",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                widget.email,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              Text(
                                "Please check your email inbox and click the verification link. After verification, click the button below to continue.",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black87,
                                ),
                              ),

                              // Error messages (both local and from service)
                              if (_localError.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.02,
                                  ),
                                  child: Text(
                                    _localError,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                  ),
                                ),

                              Obx(() {
                                if (_authService
                                    .errorMessage
                                    .value
                                    .isNotEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.02,
                                    ),
                                    child: Text(
                                      _authService.errorMessage.value,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              }),

                              SizedBox(height: screenHeight * 0.05),

                              // Verify Email Button
                              SizedBox(
                                width: double.infinity,
                                child: Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed:
                                        _authService.isLoading.value
                                            ? null
                                            : _checkEmailVerification,
                                    child:
                                        _authService.isLoading.value
                                            ? SizedBox(
                                              height: screenWidth * 0.05,
                                              width: screenWidth * 0.05,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                            : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "I've Verified My Email",
                                                  style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.05,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth * 0.02,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              // Resend email option
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Didn't receive the email?",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    GestureDetector(
                                      onTap:
                                          _isResendEnabled ? _resendOtp : null,
                                      child: Text(
                                        _isResendEnabled
                                            ? "Resend Verification Email"
                                            : "Resend in $_secondsRemaining seconds",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color:
                                              _isResendEnabled
                                                  ? Colors.purple
                                                  : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
