import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_taylor/auth/login_page.dart';
import 'package:health_taylor/key.dart';
import 'package:health_taylor/pages/All_Pages.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(initialization);
  kakao.KakaoSdk.init(nativeAppKey: kakaoId);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future initialization(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));
}

Future<bool> isSignedInGoogle() async {
  return await _googleSignIn.isSignedIn();
}

Future<bool> isSignedInKakao() async {
  try {
    await kakao.UserApi.instance.accessTokenInfo();
    return true;
  } catch (e) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    bool isKakaoLoggedIn = await isSignedInKakao();
    bool isGoogleLoggedIn = await isSignedInGoogle();

    print(isKakaoLoggedIn);
    print(isGoogleLoggedIn);

    if (isKakaoLoggedIn || isGoogleLoggedIn) {
      return All_Page();
    } else {
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ko', 'KO'),
          Locale('en', 'US'),
        ],
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<Widget>(
          future: _getInitialScreen(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error occurred');
              } else {
                return snapshot.data!;
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
