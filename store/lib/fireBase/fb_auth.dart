// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';

class FbAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential?> createUser(String email, String password) async {
    try {
      var user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) return user;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      var user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> loginAsVisitor() async {
    try {
      return await auth.signInAnonymously();
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<bool> foreGetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .catchError((onError) => false);
    return true;
  }
}
