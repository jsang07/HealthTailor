import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_taylor/components/google_button.dart';
import 'package:health_taylor/components/kakao_button.dart';
import 'package:health_taylor/pages/All_Pages.dart';
import 'package:health_taylor/open_api/Select.dart';
import 'package:health_taylor/auth/google_login/google_login.dart';
import 'package:health_taylor/auth/google_login/google_main_view_model.dart';
import 'package:health_taylor/auth/kakao_login/kakao_login.dart';
import 'package:health_taylor/auth/kakao_login/kakao_main_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;

Future<DocumentSnapshot?> fetchUserInfo(String? uid) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final documentSnapshot = await firestore.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      return documentSnapshot;
    }
  } catch (e) {
    print('Error fetching user info from Firestore: $e');
  }
  return null;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final kakaoviewModel = kakao_MainViewModel(KakaoLogin());
  final googleviewModel = google_MainViewModel(GoogleLogin());

  Future<void> uploadUserInfoToFirestore(kakao.User? user) async {
    if (user == null || user.kakaoAccount == null) return;

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String ageRange =
          (user.kakaoAccount?.ageRange ?? '').toString().split('.').last;

      await firestore.collection('users').doc(user.id.toString()).set({
        'nickname': user.kakaoAccount?.profile?.nickname,
        'email': user.kakaoAccount?.email ?? '',
        'gender': (user.kakaoAccount?.gender ?? '').toString().split('.').last,
        'ageRange': ageRange == 'null' ? null : ageRange,
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/loginlogo.png',
                      scale: 1.8,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      '개인맞춤형 운동보조식품 제공 솔루션',
                      style: TextStyle(fontSize: 10, color: Colors.grey[850]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    //   child: TextField(
                    //     cursorColor: Colors.black,
                    //     decoration: InputDecoration(
                    //         contentPadding: const EdgeInsets.only(bottom: 3),
                    //         isDense: true,
                    //         focusedBorder: const UnderlineInputBorder(
                    //             borderSide: BorderSide(color: Colors.black)),
                    //         enabledBorder: const UnderlineInputBorder(
                    //             borderSide: BorderSide(color: Colors.black)),
                    //         hintText: '아이디',
                    //         hintStyle: TextStyle(
                    //             fontSize: 14, color: Colors.grey[600])),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    //   child: TextField(
                    //     cursorColor: Colors.black,
                    //     decoration: InputDecoration(
                    //         contentPadding: const EdgeInsets.only(bottom: 3),
                    //         isDense: true,
                    //         focusedBorder: const UnderlineInputBorder(
                    //             borderSide: BorderSide(color: Colors.black)),
                    //         enabledBorder: const UnderlineInputBorder(
                    //             borderSide: BorderSide(color: Colors.black)),
                    //         hintText: '비밀번호',
                    //         hintStyle: TextStyle(
                    //             fontSize: 14, color: Colors.grey[600])),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Select(),
                              ));
                        },
                        child: const Text('일단 로그인')),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '3초만에 로그인',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130.0),
                      child: Divider(
                        color: Colors.grey[500],
                        thickness: 2,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 10),
                        child: kakaoButton(
                            ontap: () async {
                              await kakaoviewModel.login();
                              kakao.User? user =
                                  await kakao.UserApi.instance.me();
                              final userInfo =
                                  await fetchUserInfo(user.id.toString());
                              final hasEmptyFields = userInfo == null ||
                                  userInfo.get('gender') == null ||
                                  userInfo.get('age') == null ||
                                  userInfo.get('nickname') == null ||
                                  userInfo.get('height') == null ||
                                  userInfo.get('weight') == null ||
                                  userInfo.get('goal') == null ||
                                  userInfo.get('fat') == null ||
                                  userInfo.get('muscle') == null;
                              if (kakaoviewModel.isLogined) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => hasEmptyFields
                                        ? const Select()
                                        : const All_Page(),
                                  ),
                                );
                              }
                              setState(() {});
                            },
                            text: '카카오계정으로 로그인')),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 5),
                        child: googleButton(
                            ontap: () async {
                              await googleviewModel.login();
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              final userInfo =
                                  await fetchUserInfo(currentUser?.uid);
                              final hasEmptyFields =
                                  userInfo?.get('gender') == null ||
                                      userInfo?.get('age') == null ||
                                      userInfo?.get('nickname') == null ||
                                      userInfo?.get('height') == null ||
                                      userInfo?.get('weight') == null ||
                                      userInfo?.get('goal') == null ||
                                      userInfo?.get('fat') == null ||
                                      userInfo?.get('muscle') == null;
                              print(hasEmptyFields);
                              if (googleviewModel.isLogined) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => hasEmptyFields
                                        ? const Select()
                                        : const All_Page(),
                                  ),
                                );
                              }
                            },
                            text: '구글계정으로 로그인')),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '아이디 혹은 비밀번호를 잊었습니다.',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
