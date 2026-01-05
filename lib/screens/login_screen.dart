import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

import 'package:video_player/video_player.dart';
import '../utils/project_style.dart'; // Import ProjectStyle

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();
  late VideoPlayerController _videoController; // Video Controller
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize Video Player
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('https://assets.oyoroomscdn.com/cin/Prism_login_video.mp4'),
    );

    _videoController
        .initialize()
        .then((_) {
          print("✅ Video initialized successfully");
          print("Video duration: ${_videoController.value.duration}");
          print("Video size: ${_videoController.value.size}");

          // Set video properties
          _videoController.setLooping(true);
          _videoController.setVolume(0.0);

          // Start playing
          _videoController.play().then((_) {
            print("✅ Video started playing");
          });

          // Rebuild to show video
          if (mounted) {
            setState(() {});
          }
        })
        .catchError((error) {
          print("🔥 Video Initialization Error: $error");
          print("🔥 Error type: ${error.runtimeType}");
          // Fallback or error state handling
        });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _videoController.dispose(); // Dispose video controller
    super.dispose();
  }

  void _handleContinue() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Basic validation
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter valid credentials",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        return;
      }

      final user = await _authService.signIn(email, password);

      if (user != null) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      print("🔥 Login Error: $e");
      Get.snackbar(
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Video
          Positioned.fill(
            child:
                _videoController.value.isInitialized
                    ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController.value.size.width,
                        height: _videoController.value.size.height,
                        child: VideoPlayer(_videoController),
                      ),
                    )
                    : Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ), // Show loader instead of just black
                    ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // 2. Content
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // spacer to push content down (header height approx)
                    SizedBox(height: 60),

                    Spacer(),

                    // Promotional Text
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontFamily: ProjectStyle.fontFamily,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 32),

                    // Email Input
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Change 12.0 to adjust roundness
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 50, // Fixed height for alignment
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical:
                            TextAlignVertical.center, // Align Text
                        style: TextStyle(
                          fontFamily: ProjectStyle.fontFamily,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          hintStyle: TextStyle(
                            fontFamily: ProjectStyle.fontFamily,
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true, // Key for centering
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 20,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Password Input
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Change 12.0 to adjust roundness
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 50,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontFamily: ProjectStyle.fontFamily,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontFamily: ProjectStyle.fontFamily,
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.lock_outline,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 20,
                          ),
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                              size: 20,
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

                    SizedBox(height: 16),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // Rectangular as per image outline style usually or slight radius? Image looks sharp rectangular or very slight. Stick to standard or request.
                            // Image shows standard button.
                          ),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontFamily: ProjectStyle.fontFamily,
                            fontSize: 19,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Sign up later footer
                    GestureDetector(
                      onTap: () {
                        // "route to the same screen only login page"
                        Get.offAllNamed('/login');
                      },
                      child: Text(
                        "I'll sign up later",
                        style: TextStyle(
                          fontFamily: ProjectStyle.fontFamily,
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 16), // Bottom padding
                  ],
                ),
              ),
            ),
          ),

          // 3. Fixed Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Centered Logo
                    Image.asset('assets/logo1.png', height: 50),
                    SizedBox(height: 100),
                    Image.asset('assets/logo1.png', height: 50),
                    /* SizedBox(height: 100), removed spacer if not needed or keep it? 
                       Actually, the stack alignment is center, so SizedBox height in a Stack doesn't affect positioning of other Stack elements unless it's the main sizing one.
                       But wait, the Stack has `alignment: Alignment.center`. 
                       Let's just remove the Positioned widget.
                    */
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
