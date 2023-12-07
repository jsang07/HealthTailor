import 'package:flutter/material.dart';
import 'package:health_taylor/pages/HomePage/Home_Page.dart';
import 'package:health_taylor/pages/SocialPage/social_page.dart';
import 'package:health_taylor/pages/ProfilePage/profile_page.dart';
import 'package:health_taylor/pages/shopPage/shopping_page.dart';

class All_Page extends StatefulWidget {
  const All_Page({super.key});

  @override
  State<All_Page> createState() => _HomePageState();
}

class _HomePageState extends State<All_Page> {
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget? _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return const Home_Page();
      case 1:
        return const ShoppingPage();
      case 2:
        return const SocialPage();
      case 3:
        return const ProfilePage();
    }
    return null;
  }

  Widget _bottomWidget() {
    return BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        // Color(0xff1e2c5b)
        backgroundColor: Colors.white,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        unselectedItemColor: Colors.indigo,
        selectedItemColor: Colors.indigo,
        selectedFontSize: 13,
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.home_rounded,
                  color: Colors.indigo,
                )),
            label: '홈',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.home_rounded, color: Colors.indigo)),
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.indigo,
                )),
            label: '보충제',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.shopping_cart, color: Colors.indigo)),
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.chat_bubble,
                  color: Colors.indigo,
                )),
            label: '소셜',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.chat_bubble, color: Colors.indigo)),
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.person,
                  color: Colors.indigo,
                )),
            label: '마이',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.tag_faces_rounded, color: Colors.indigo)),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _bodyWidget(),
        bottomNavigationBar: _bottomWidget(),
      ),
    );
  }
}
