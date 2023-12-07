import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_taylor/pages/SocialPage/detail_page.dart';

class Post extends StatefulWidget {
  final String title, content, img, user, postId, time;
  final List<String> likes;
  const Post({
    super.key,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
    required this.title,
    required this.content,
    required this.img,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final commenttextEditingController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isliked = true;

  @override
  void initState() {
    super.initState();
    isliked = widget.likes.contains(currentUser?.email);
  }

  void toggleLike() {
    setState(() {
      isliked = !isliked;
    });

    // access the document firbase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isliked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser?.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser?.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                title: widget.title,
                content: widget.content,
                img: widget.img,
                user: widget.user,
                postId: widget.postId,
                time: widget.time,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: toggleLike,
                            child: Icon(
                              isliked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isliked ? Colors.red : Colors.black,
                              size: 28,
                            ),
                          ),
                          Text(widget.likes.length.toString()),
                        ],
                      ),

                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 215,
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                  fontSize: 18, overflow: TextOverflow.clip),
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.user.split('@')[0]} •',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(widget.time,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                      // 글삭제
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
