import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  static FirebaseController instance = Get.find();
  late Rx<User?> firebaseUser;
  final Rx<String> userToken = ''.obs;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> signinAnony() async {
    await firebaseAuth.signInAnonymously();
  }

  Future<void> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final UserCredential createdUser =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (createdUser.user != null) {
        await createdUser.user!.updateDisplayName(
          displayName,
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
