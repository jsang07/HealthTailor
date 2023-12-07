import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_taylor/components/post.dart';
import 'package:health_taylor/helper/helper_method.dart';
import 'package:health_taylor/pages/SocialPage/add_page.dart';

class FreeSocial extends StatefulWidget {
  const FreeSocial({super.key});

  @override
  State<FreeSocial> createState() => _FreeSocialState();
}

class _FreeSocialState extends State<FreeSocial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User Posts')
            .orderBy('Timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.docs[index];
                return Post(
                  title: post['Title'],
                  content: post['Content'],
                  img: post['Image'],
                  user: post['UserEmail'],
                  time: formDate(post['Timestamp']),
                  postId: post.id,
                  likes: List<String>.from(post['Likes'] ?? []),
                );
              },
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
    );
  }
}
