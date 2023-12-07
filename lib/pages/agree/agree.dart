import 'package:flutter/material.dart';

class Agree extends StatelessWidget {
  const Agree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '블라블라 이용약관',
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(
              height: 20,
            ),
            Text('ㅏ \n ㅏ \n ㅏ \n ㅏ \n ㅏ')
          ],
        ),
      ),
    );
  }
}
