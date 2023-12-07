import 'package:flutter/material.dart';
import 'package:health_taylor/pages/SocialPage/freeSocial_page.dart';
import 'package:health_taylor/pages/SocialPage/healthSocial_page.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  bool free = true;
  bool health = false;
  bool shop = false;
  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: 0);

    void goToPage(int page) {
      _pageController.jumpToPage(page);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                GestureDetector(
                    onTap: () {
                      goToPage(0);
                      setState(() {
                        free = true;
                        health = false;
                        shop = false;
                      });
                    },
                    child: Text(
                      '자유게시판',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: free == true ? Colors.black : Colors.grey),
                    )),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      goToPage(1);
                      setState(() {
                        free = false;
                        health = true;
                        shop = false;
                      });
                    },
                    child: Text(
                      '운동 게시판',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: health == true ? Colors.black : Colors.grey),
                    )),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      goToPage(2);
                      setState(() {
                        free = false;
                        health = false;
                        shop = true;
                      });
                    },
                    child: Text(
                      '장터 게시판',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: shop == true ? Colors.black : Colors.grey),
                    )),
                const SizedBox(
                  width: 10,
                ),
              ]),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: const [
                  FreeSocial(),
                  HealthSocial(),
                  Center(
                      child: Icon(
                    Icons.question_mark_rounded,
                    size: 80,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
