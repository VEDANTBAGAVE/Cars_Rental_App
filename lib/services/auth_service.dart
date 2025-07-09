import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Save login state locally
  Future<void> saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Create user with Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Create user document in Firestore
        UserModel userModel = UserModel(
          uid: user.uid,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        // Save login state
        await saveLoginState(true);

        return userModel;
      }
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
    return null;
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Get user data from Firestore
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          // Update last login time
          await _firestore
              .collection('users')
              .doc(user.uid)
              .update({'lastLoginAt': DateTime.now()});

          // Save login state
          await saveLoginState(true);

          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await saveLoginState(false);
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    User? user = currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String fullName,
    required String phoneNumber,
  }) async {
    User? user = currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      });
    }
  }

  // Add car to favorites
  Future<void> addToFavorites(String carId) async {
    User? user = currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'favoriteCars': FieldValue.arrayUnion([carId]),
      });
    }
  }

  // Remove car from favorites
  Future<void> removeFromFavorites(String carId) async {
    User? user = currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'favoriteCars': FieldValue.arrayRemove([carId]),
      });
    }
  }

  // Get user favorites
  Future<List<String>> getUserFavorites() async {
    User? user = currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return List<String>.from(data['favoriteCars'] ?? []);
      }
    }
    return [];
  }

  // Google Sign In
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Check if user document exists in Firestore
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          // User exists, update last login time
          await _firestore
              .collection('users')
              .doc(user.uid)
              .update({'lastLoginAt': DateTime.now()});

          // Save login state
          await saveLoginState(true);

          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          // New user, create document in Firestore
          UserModel userModel = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Google User',
            phoneNumber: user.phoneNumber ?? '',
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
            isEmailVerified: user.emailVerified,
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());

          // Save login state
          await saveLoginState(true);

          return userModel;
        }
      }
    } catch (e) {
      print('Error during Google sign in: $e');
      rethrow;
    }
    return null;
  }
} 