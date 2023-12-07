import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_taylor/auth/login_page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;

GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signOut() async {
  try {
    bool isGoogleLoggedIn = await _googleSignIn.isSignedIn();
    bool isKakaoLoggedIn = false;

    try {
      await kakao.UserApi.instance.accessTokenInfo();
      isKakaoLoggedIn = true;
    } catch (e) {
      isKakaoLoggedIn = false;
    }

    if (isGoogleLoggedIn) {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print("Google sign out success");
    } else if (isKakaoLoggedIn) {
      await kakao.UserApi.instance.logout();
      print("Kakao sign out success");
    }

  } catch (error) {
    print("Error signing out: $error");
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  kakao.User? user;
  String? uid;

  void Determine_Uid() async {
    //로그인 확인
    bool isGoogleLoggedIn = await _googleSignIn.isSignedIn();
    bool isKakaoLoggedIn = false;

    try {
      await kakao.UserApi.instance.accessTokenInfo();
      isKakaoLoggedIn = true;
      user = await kakao.UserApi.instance.me();
    } catch (e) {
      isKakaoLoggedIn = false;
    }

    if (mounted) {
      setState(() {
        uid = isGoogleLoggedIn ? currentUser?.uid : isKakaoLoggedIn ? user?.id.toString() : null;
      });
    }
  }

  box(Icon icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: () {},
        child: Row(
          children: [
            icon,
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Determine_Uid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'MY PROFILE',
          style: TextStyle(color: Colors.black),
        ),actions: [IconButton(onPressed: () async {
        await signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }, icon: Icon(Icons.logout, color: Colors.black,))],

        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  return Center(
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(data['photoURL']?? '',
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(data['nickname']),
                        SizedBox(
                          height: 10,
                        ),
                        Text(uid ?? ''),                        SizedBox(
                          height: 30,
                        ),
                        box(Icon(Icons.person), '내정보'),
                        box(Icon(Icons.notifications), '알림 설정'),
                        box(Icon(Icons.announcement_rounded), '공지사항 및 문의'),
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                style: TextButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                await signOut();
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                builder: (context) => LoginPage(),
                ),
                );},
                child: Row(
                children: const [
                Icon(Icons.logout),
                SizedBox(width: 20),
                Expanded(child: Text('로그아웃')),
                Icon(Icons.arrow_forward_ios),
                ],
                ),
                ),
                ),],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return Center(
                  child: Container(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
