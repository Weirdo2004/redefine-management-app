import 'package:customerapp/screens/about_screen.dart';
import 'package:customerapp/screens/activity_log_screen.dart';
import 'package:customerapp/screens/change_password_screen.dart';
import 'package:customerapp/screens/cost_sheet_screen.dart';
import 'package:customerapp/screens/login_screen.dart';
import 'package:customerapp/screens/modification_screen.dart';
import 'package:customerapp/screens/notification_screen.dart';
import 'package:customerapp/screens/profile_screen.dart';
import 'package:customerapp/screens/refer_screen.dart';
import 'package:customerapp/screens/signup_screen.dart';
import 'package:customerapp/screens/splash_screen.dart';
import 'package:customerapp/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/document_screen.dart';
import 'screens/home_screen.dart';
import 'screens/payment_schedule_screen.dart';
import 'screens/project_detail_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'services/auth_service.dart';
import 'utils/project_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized properly

  try {
    await Firebase.initializeApp(); // Initialize Firebase
    print("✅ Firebase Initialized Successfully");
  } catch (e) {
    print("🔥 Firebase Initialization Error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer App',
      theme: ThemeData(
        fontFamily: ProjectStyle.fontFamily,
        scaffoldBackgroundColor: Color(0xfff5f5f5),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(
          AuthService(),
        ); // Inject AuthService for authentication management
      }),
      initialRoute: "/splash",
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/', page: () => SignupScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/project-detail', page: () => ProjectDetailScreen()),
        GetPage(name: '/payment-schedule', page: () => PaymentScheduleScreen()),
        GetPage(name: '/cost-sheet', page: () => CostSheetScreen()),
        GetPage(name: '/activity-log', page: () => ActivityLogScreen()),
        GetPage(name: '/modification', page: () => ModificationScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/about', page: () => AboutScreen()),
        GetPage(name: '/change-password', page: () => PasswordChangeScreen()),
        GetPage(name: '/refer', page: () => ReferScreen()),
        GetPage(name: '/document', page: () => DocumentsScreen()),
        GetPage(name: '/transaction', page: () => TransactionScreen()),
        GetPage(
          name: '/transaction-detail',
          page: () => TransactionDetailsScreen(),
        ),
        GetPage(name: '/notification', page: () => NotificationsScreen()),
      ],
    );
  }
}
