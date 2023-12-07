import 'package:flutter/material.dart';

class googleButton extends StatelessWidget {
  final Function ontap;
  final String text;
  const googleButton({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ontap(),
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Color(0xFF18A5FD)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Image.asset(
                  'assets/google.jpg',
                  scale: 20,
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
    );
  }
}