import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_taylor/pages/shopPage/shopping_add_page.dart';
import 'package:health_taylor/pages/shopPage/shopping_post.dart';

import '../../helper/helper_method.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          title: const Text(
            '프로틴 스토어',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .orderBy('Timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final products = snapshot.data!.docs[index];
                          return ShoppingPost(
                            url: products['Url'],
                            brand: products['Brand'],
                            price: products['Price'],
                            title: products['Title'],
                            content: products['Content'],
                            img: products['Image'],
                            user: products['UserEmail'],
                            time: formDate(products['Timestamp']),
                            postId: products.id,
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
                    child: Container(),
                  );
                },
              )),
            ],
          ),
        ),
        floatingActionButton: currentUser?.email == 'hsuwerr@gmail.com'
            ? FloatingActionButton(
                elevation: 0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingAddPage(),
                      ));
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
