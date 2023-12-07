import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_taylor/open_api/load.dart';
import 'package:health_taylor/pages/onboarding_page.dart';

class Select extends StatelessWidget {
  const Select({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const load(
                          isFromHome_Page: false,
                        ),
                      ),
                    );
                  },
                  child: Text("건강검진데이터 불러오기"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnBoardingPage(startPageIndex: 0),
                      ),
                    );
                  },
                  child: Text("직접 입력하기"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
