import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_taylor/auth/kakao_login/kakao_social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'dart:convert';
import 'package:http/http.dart' as http;

class kakao_MainViewModel {
  final kakao_SocialLogin kakao_socialLogin;
  bool isLogined = false;
  kakao.User? user;

  kakao_MainViewModel(this.kakao_socialLogin);

  Future login() async {
    isLogined = await kakao_socialLogin.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();

      Future<String> createCustomToken(
          String uid, String email, String displayName, String photoURL) async {
        final response = await http.post(
          Uri.parse(
              'https://asia-northeast3-health10293.cloudfunctions.net/createCustomToken'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'uid': uid,
            'email': email,
            'displayName': displayName,
            'photoURL': photoURL,
          }),
        );
        if (response.statusCode == 200) {
          return response.body;
        } else {
          throw Exception('Failed to create custom token');
        }
      }

      final token = await createCustomToken(
        user!.id.toString(),
        user!.kakaoAccount!.email ?? '',
        user!.kakaoAccount!.profile!.nickname!,
        user!.kakaoAccount!.profile!.profileImageUrl!,
      );

      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future logout() async {
    await kakao_socialLogin.logout();
    await FirebaseAuth.instance.signOut();
    isLogined = false;
    user = null;
  }
}
