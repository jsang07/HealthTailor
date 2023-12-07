import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_taylor/helper/helper_method.dart';
import 'package:health_taylor/pages/SocialPage/add_page.dart';

class DetailPage extends StatefulWidget {
  final String title, content, img, user, postId, time;
  const DetailPage(
      {super.key,
      required this.title,
      required this.content,
      required this.user,
      required this.postId,
      required this.time,
      required this.img});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final commenttextEditingController = TextEditingController();

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser?.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentUserDialog() {
    showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: AlertDialog(
          content: Container(
            height: 240,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      deleteComment();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: Size(180, 50),
                        backgroundColor: Colors.lightBlue[100]),
                    child: const Text(
                      '삭제하기',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: Size(180, 50),
                        backgroundColor: Colors.lightBlue[100]),
                    child: const Text('신고하기',
                        style: TextStyle(fontWeight: FontWeight.w600))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: Size(180, 50),
                        backgroundColor: Colors.lightBlue[100]),
                    child: const Text('취소',
                        style: TextStyle(fontWeight: FontWeight.w600)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPostUserDialog() {
    showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            height: 240,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.user == currentUser?.email)
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDeleteCheckDialog();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0.2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          fixedSize: Size(180, 50),
                          backgroundColor: Colors.lightBlue[100]),
                      child: const Text(
                        '삭제하기',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                if (widget.user == currentUser?.email)
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPage(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0.2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          fixedSize: Size(180, 50),
                          backgroundColor: Colors.lightBlue[100]),
                      child: Text('수정하기',
                          style: TextStyle(fontWeight: FontWeight.w600))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: Size(180, 50),
                        backgroundColor: Colors.lightBlue[100]),
                    child: Text('신고하기',
                        style: TextStyle(fontWeight: FontWeight.w600))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: Size(180, 50),
                        backgroundColor: Colors.lightBlue[100]),
                    child: Text('취소',
                        style: TextStyle(fontWeight: FontWeight.w600)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deletePost() async {
    final commentDocs = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .get();

    for (var doc in commentDocs.docs) {
      FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .collection('Comments')
          .doc(doc.id)
          .delete();
    }

    // delete post
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .delete()
        .then((value) => print('post deleted'))
        .catchError((error) => print('failed to delete: $error'));

    Navigator.pop(context);
  }

  Future<void> deleteComment() async {
    final commentDocs = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .get();

    for (var doc in commentDocs.docs) {
      FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .collection('Comments')
          .doc(doc.id)
          .delete();
    }

    Navigator.pop(context);
  }

  void showDeleteCheckDialog() {
    showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: AlertDialog(
          title: const Text('글을 삭제하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: Container(
            height: 170,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('삭제한 글은 되돌릴 수 없습니다',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    onPressed: () {
                      deletePost();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: const Size(180, 50),
                        backgroundColor: Colors.lightBlue[100]),
                    child: const Text('삭제하기',
                        style: TextStyle(fontWeight: FontWeight.w600))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: const Size(180, 50),
                        backgroundColor: Colors.lightBlue[100]),
                    child: const Text('취소',
                        style: TextStyle(fontWeight: FontWeight.w600)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            '???',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(fontSize: 20),
                          ),
                          GestureDetector(
                            onTap: showPostUserDialog,
                            child: const Icon(
                              Icons.more_horiz_rounded,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                        children: [
                          Text(widget.user.split('@')[0]),
                          Text('• ${widget.time}'),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.content,
                        style: TextStyle(overflow: TextOverflow.clip),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      widget.img != ''
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Image.network(
                                  widget.img,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 10,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  '댓글',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User Posts')
                      .doc(widget.postId)
                      .collection('Comments')
                      .orderBy("CommentTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 90.0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((doc) {
                          final commentData =
                              doc.data() as Map<String, dynamic>;
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        commentData['CommentedBy']
                                            .split('@')[0],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      GestureDetector(
                                        onTap: showCommentUserDialog,
                                        child: const Icon(
                                          Icons.more_horiz_rounded,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    commentData['CommentText'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(formDate(commentData['CommentTime']),
                                      style:
                                          const TextStyle(color: Colors.grey))
                                ]),
                          );
                        }).toList(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
              child: TextField(
                controller: commenttextEditingController,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        addComment(commenttextEditingController.text);
                        commenttextEditingController.clear();
                      },
                      child: const Icon(Icons.arrow_upward_rounded,
                          color: Colors.grey),
                    ),
                    hintText: '댓글을 입력하세요',
                    contentPadding: const EdgeInsets.only(left: 20),
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
