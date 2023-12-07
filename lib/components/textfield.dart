import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String text;
  final TextEditingController textEditingController;
  const Mytextfield(
      {super.key, required this.text, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            hintText: text,
            contentPadding: const EdgeInsets.only(left: 20),
            filled: true,
            fillColor: Colors.grey[200],
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
