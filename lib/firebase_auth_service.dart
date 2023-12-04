import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthService{
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);


  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn({required String email, required String password}) async {
    log("${password}Ww");
    try {

      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return e.message;
    }
  }
  Future<String?> resetPassword({required String email}) async {
    try {

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String?> signUp({required String email,required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}