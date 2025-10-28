import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Add Firestore instance

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // A private helper to create the user document
  Future<void> _createUserDocument(User user) {
    return _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(), // Good practice to store this
    });
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // First, create the user in Firebase Auth
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // If successful, create their document in Firestore
    if (userCredential.user != null) {
      await _createUserDocument(userCredential.user!);
    }

    return userCredential;
  }

  // Sign in and sign out methods remain the same
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}