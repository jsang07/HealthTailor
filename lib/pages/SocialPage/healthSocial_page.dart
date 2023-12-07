import 'package:flutter/material.dart';

class HealthSocial extends StatefulWidget {
  const HealthSocial({super.key});

  @override
  State<HealthSocial> createState() => _HealthSocialState();
}

class _HealthSocialState extends State<HealthSocial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/work.jpg', fit: BoxFit.cover),
              );
            },
          ),
        ));
  }
}
