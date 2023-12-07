import 'package:firebase_auth/firebase_auth.dart';

abstract class google_SocialLogin {
  Future<User?> login();

  Future<bool> logout();
}