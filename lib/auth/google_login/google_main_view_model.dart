import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_taylor/auth/google_login/google_social_login.dart';

class google_MainViewModel extends ChangeNotifier {
  User? user;
  final google_SocialLogin google_socialLogin;

  google_MainViewModel(this.google_socialLogin);

  bool _isLogined = false;
  bool get isLogined => _isLogined;

  Future<void> login() async {
    try {
      User? signInSuccess = await google_socialLogin.login();
      user = signInSuccess;
      _isLogined = user != null;
      notifyListeners();
    } catch (e) {
      print("Error signing in with Google: $e");
      _isLogined = false;
    }
  }

  Future<void> logout() async {
    try {
      await google_socialLogin.logout();
      user = null;
      _isLogined = false;
      notifyListeners();
    } catch (e) {
      print("Error signing out with Google: $e");
    }
  }
}