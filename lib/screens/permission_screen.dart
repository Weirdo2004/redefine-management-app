import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool isAgreed = false;

  Future<void> _requestPermissions() async {
    if (!isAgreed) {
      Get.snackbar(
        "Error",
        "Please accept the Privacy Policy & Terms of Service",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Request permissions
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.location,
          Permission.phone, // For Device info/Phone state
          // Permission.manageExternalStorage, // For installed apps (if needed, or check implementation)
          // Note: "Installed apps" usually requires QUERY_ALL_PACKAGES in AndroidManifest,
          // but actual runtime permission might be different or just usage stats.
          // For now, we'll ask for Location and Phone as proxies for "Device info".
        ].request();

    if (statuses[Permission.location]!.isGranted) {
      // Navigate to Welcome/Login
      Get.offAllNamed('/login');
    } else {
      Get.snackbar(
        "Permissions Required",
        "Please grant permissions to proceed.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We need a\nfew permissions!",
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF242424),
                    height: 1.2,
                  ),
                ),
              ),
            ),

            SizedBox(height: 35),
            // Scrollable Middle Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildPermissionItem(
                      icon: Icons.sms_outlined,
                      title: "SMS",
                      description:
                          "SMS data (Non-Personal, Transactional SMS from Short-Code Senders) from your phone will be collected, transmitted and stored in our secured moneyview server (https://app-moneyview.whizdm.com) in order to provide the personal finance manager offering and for onward sharing with Lending Partners to assess creditworthiness; understand cash flow patterns when you apply for a loan. This data may be collected when the app is closed or not in use.",
                    ),
                    const SizedBox(height: 10),
                    _buildPermissionItem(
                      icon: Icons.location_on_outlined,
                      title: "Location",
                      description:
                          "Location data will be collected, transmitted and stored in our secured moneyview server (https://app-moneyview.whizdm.com) for checking serviceability, fraud prevention, expedition of KYC and to provide better offers.",
                    ),
                    const SizedBox(height: 10),
                    _buildPermissionItem(
                      icon: Icons.phone_android_outlined,
                      title: "Device information",
                      description:
                          "This information is collected, transmitted and stored in our secured moneyview server (https://app-moneyview.whizdm.com) for hassle-free registration and fraud prevention.",
                    ),
                    const SizedBox(height: 10),
                    _buildPermissionItem(
                      icon: Icons.grid_view,
                      title: "Installed apps",
                      description:
                          "Metadata on Installed apps will be collected, transmitted and stored in our secured moneyview server (https://app-moneyview.whizdm.com) for onward sharing with lending partners to assess your creditworthiness and for fraud prevention.",
                    ),
                    const SizedBox(height: 10),
                    _buildPermissionItem(
                      icon: Icons.camera_alt_outlined,
                      title: "Camera",
                      description:
                          "Media and photos permission will allow you to click and upload documents for KYC, required for fraud prevention and to ensure compliance. This information is collected, transmitted and stored in our secured moneyview server (https://app-moneyview.whizdm.com).",
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "All your information is safe and secure",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Know more",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),

            // Grey divider line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(height: 1, color: Colors.grey[300]),
            ),
            // Fixed Footer
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color:
                              isAgreed ? const Color(0xFF134044) : Colors.white,
                          border: Border.all(
                            color:
                                isAgreed
                                    ? const Color(0xFF134044)
                                    : Colors.grey[400]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isAgreed = !isAgreed;
                            });
                          },
                          child:
                              isAgreed
                                  ? const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isAgreed = !isAgreed;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                  text: "By continuing, I accept the ",
                                ),
                                TextSpan(
                                  text: "Privacy policy",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: " & "),
                                TextSpan(
                                  text: "Terms of Service",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: " of moneyview."),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Likely exit app or show dialog
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 24,
                            ),
                            side: const BorderSide(color: Color(0xFF134044)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "I disagree",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF134044),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _requestPermissions,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 24,
                            ),
                            backgroundColor:
                                isAgreed
                                    ? const Color(0xFF134044)
                                    : Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "I agree",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 12, // Small text as per image
                    color: Colors.grey[600],
                    height: 1.5,
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
