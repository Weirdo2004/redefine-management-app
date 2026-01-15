import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable user state
  Rx<User?> currentUser = Rx<User?>(null);

  // Authentication state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString orgId = ''.obs;
  RxString leadsCollectionName = ''.obs;
  RxString siteVisitsCollectionName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set up auth state listener
    currentUser.value = _auth.currentUser;
    if (currentUser.value != null) {
      _fetchUserOrgId(currentUser.value!.uid);
    }
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user != null) {
        _fetchUserOrgId(user.uid);
      } else {
        orgId.value = '';
        leadsCollectionName.value = '';
        siteVisitsCollectionName.value = '';
      }
    });
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      errorMessage.value = 'Error signing out';
    }
  }

  // Check if email is verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Reload user to check for email verification
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      currentUser.value = _auth.currentUser;
    } catch (e) {
      errorMessage.value = 'Error refreshing user state';
    }
  }

  // Send OTP (verification email)
  Future<bool> sendOTP() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _auth.currentUser?.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return false;
    } catch (e) {
      errorMessage.value = 'Error sending verification email';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get current user's email
  String? getCurrentUserEmail() {
    return currentUser.value?.email;
  }

  // Handle Firebase Auth exceptions
  void _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage.value = 'Email is already in use. Please login instead.';
        break;
      case 'invalid-email':
        errorMessage.value = 'Invalid email address.';
        break;
      case 'weak-password':
        errorMessage.value =
            'Password is too weak. Please use a stronger password.';
        break;
      case 'user-not-found':
        errorMessage.value = 'No user found with this email. Please sign up.';
        break;
      case 'wrong-password':
        errorMessage.value = 'Incorrect password. Please try again.';
        break;
      case 'user-disabled':
        errorMessage.value =
            'This account has been disabled.'; // Corrected message
        break;
      case 'too-many-requests':
        errorMessage.value = 'Too many requests. Please try again later.';
        break;
      case 'operation-not-allowed':
        errorMessage.value = 'This operation is not allowed.';
        break;
      case 'network-request-failed':
        errorMessage.value = 'Network error. Please check your connection.';
        break;
      case 'credential-already-in-use': // Added commonly encountered error
        errorMessage.value =
            'This credential is already associated with a different user account.';
        break;
      default:
        errorMessage.value = 'An error occurred: ${e.message}';
    }
  }

  // Fetch user's orgId
  Future<void> _fetchUserOrgId(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        // Assuming the field is explicitly 'orgId' based on user request ("orgId_leads")
        // and the path /users/.../orgId
        if (data.containsKey('orgId')) {
          // TESTING: Hardcoded OrgID
          String fetchedOrgId = "maahomes"; // <--- CHANGE THIS VALUE TO TEST
          //String fetchedOrgId = data['orgId'].toString();

          orgId.value = fetchedOrgId;
          leadsCollectionName.value = "${fetchedOrgId}_leads";
          siteVisitsCollectionName.value = "${fetchedOrgId}_siteVisits";
          print(
            "✅ OrgId Fetched: $fetchedOrgId | Collection: ${leadsCollectionName.value}",
          );

          // Fetch projects for this org
          await _fetchProjects(fetchedOrgId);
        } else {
          print("⚠️ User document exists but no 'orgId' field found.");
        }
      } else {
        print("⚠️ User document not found for uid: $uid");
      }
    } catch (e) {
      print("❌ Error fetching user orgId: $e");
    }
  }

  // Projects list for filter
  RxList<Map<String, dynamic>> projects = <Map<String, dynamic>>[].obs;

  Future<void> _fetchProjects(String orgId) async {
    try {
      String projectsCollection = "${orgId}_projects";
      print("Fetching projects from: $projectsCollection");

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(projectsCollection)
              .where('status', isEqualTo: 'ongoing')
              .get();

      List<Map<String, dynamic>> fetchedProjects = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Assuming project documents have 'name' or 'projectName' and we use doc.id as ID.
        // We'll trust the doc ID for filtering and display a name if available, else ID.
        String pid = data['uid'] ?? doc.id;
        String name = data['projectName'] ?? data['name'] ?? pid;
        fetchedProjects.add({
          'id': pid, // Use uid if available, else doc.id
          'name': name,
          'logoUrl': data['projectLogoUrl'], // Add Logo URL
        });
      }

      projects.value = fetchedProjects;
      print("✅ Fetched ${projects.length} ongoing projects.");
    } catch (e) {
      print("❌ Error fetching projects: $e");
    }
  }
}
