import 'package:health_taylor/auth/kakao_login/kakao_social_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_remote_data_source.dart';
class KakaoLogin implements kakao_SocialLogin {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  kakao.User? user;

  @override
  Future<bool> login() async {
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        user= await kakao.UserApi.instance.me();
        final token = await _firebaseAuthDataSource.createCustomToken({
          'uid': user!.id.toString(),
          'email':user!.kakaoAccount!.email ?? '',
          'displayName':user!.kakaoAccount!.profile!.nickname,
          'photoURL':user!.kakaoAccount!.profile!.profileImageUrl!,
        });
        await FirebaseAuth.instance.signInWithCustomToken(token);
        return true;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          return true;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } else {
      try {
        await kakao.UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        return true;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }
  }
  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }
}