import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> _createUserDocument(User user) {
    //... (this method is unchanged)
    return _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    //... (this method is unchanged)
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      await _createUserDocument(userCredential.user!);
    }
    return userCredential;
  }

  Future<UserCredential> signInWithEmailAndPassword({
    //... (this method is unchanged)
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    //... (this method is unchanged)
    return _firebaseAuth.signOut();
  }
  
  // --- New Method for Password Reset ---
  Future<void> changePassword() async {
    final user = _firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw Exception("User not found or has no email.");
    }
    await _firebaseAuth.sendPasswordResetEmail(email: user.email!);
  }

  Future<void> deleteAccount() async {
    //... (this method is unchanged)
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    try {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final watchlistSnapshot = await userDocRef.collection('watchlist').get();
      final batch = _firestore.batch();
      for (final doc in watchlistSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      await userDocRef.delete();
      await user.delete();
    } catch (e) {
      print("Error deleting account and all data: $e");
      rethrow;
    }
  }
}