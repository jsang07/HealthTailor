import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_taylor/open_api/load.dart';
import 'package:health_taylor/pages/PortfolioPage/Portfolio_Page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:health_taylor/pages/my_detail/body_detail.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool _showQrCodeScreen = false;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  kakao.User? user;
  String? uid;
  var qrData = '';

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
        uid = isGoogleLoggedIn
            ? currentUser?.uid
            : isKakaoLoggedIn
                ? user?.id.toString()
                : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Determine_Uid();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(children: [
        if (_showQrCodeScreen == true)
          Stack(
            children: [
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.white,
                  )),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showQrCodeScreen = false;
                  });
                  print(_showQrCodeScreen);
                },
                child: Center(
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
            ],
          ),
        if (_showQrCodeScreen == false)
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Image.asset(
                    'assets/ht.png',
                    scale: 3,
                  ),
                ),
                Center(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '신체정보',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BodyDetail(
                                              height: data['height'],
                                              weight: data['weight'],
                                              fat: data['fat'],
                                              muscle: data['muscle']),
                                        ));
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '키: ${data['height']} cm',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '몸무게: ${data['weight']} kg',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '체지방률: ${data['fat']} %',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '골격근량: ${data['muscle']} kg',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    portFolio()));
                                      },
                                      child: Container(
                                        width: width / 2.3,
                                        height: 200,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '현재목표',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.lightBlue[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Text(
                                                data['goal'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 30),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const load(
                                                isFromHome_Page: true),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width / 2.3,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/health_information.png',
                                            ),
                                            Text('건강정보 불러오기',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: width,
                  height: 200,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Text('QR',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                      Expanded(
                          child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('selectPofol')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 26),
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final user = snapshot.data!.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text('단백질: ${user['Protein']}'),
                                            Text('크레아틴: ${user['Creatine']}'),
                                            Text('아르기닌: ${user['Arginin']}'),
                                            Text('Bcaa: ${user['Bcaa']}'),
                                          ],
                                        ),
                                        Container(
                                          color: Colors.grey,
                                          height: 100,
                                          width: 3,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showQrCodeScreen = true;
                                              qrData =
                                                  '단백질: ${user['Protein']}g, 크레아틴: ${user['Creatine']}g, 아르기닌: ${user['Arginin']}g, BCAA: ${user['Bcaa']}g';
                                            });
                                            print(_showQrCodeScreen);
                                          },
                                          child: QrImageView(
                                            data:
                                                '단백질: ${user['Protein']}g, 크레아틴: ${user['Creatine']}g, 아르기닌: ${user['Arginin']}g, BCAA: ${user['Bcaa']}g',
                                            version: QrVersions.auto,
                                            size: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          return Center(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[200]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('골라주세요'),
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}
