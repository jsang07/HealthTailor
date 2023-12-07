import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:health_taylor/pages/shopPage/shopping_add_page.dart';

import 'package:health_taylor/pages/shopPage/shopping_review.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../../helper/helper_method.dart';

class ShoppingDetailPage extends StatefulWidget {
  final String url, title, content, brand, price, img, user, postId, time;

  const ShoppingDetailPage(
      {super.key,
      required this.title,
      required this.content,
      required this.user,
      required this.postId,
      required this.time,
      required this.img,
      required this.brand,
      required this.price,
      required this.url});

  @override
  State<ShoppingDetailPage> createState() => _ShoppingDetailPageState();
}

class _ShoppingDetailPageState extends State<ShoppingDetailPage>
    with SingleTickerProviderStateMixin {
  final currentUser = FirebaseAuth.instance.currentUser;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController =
        TabController(length: 2, vsync: this); // Adjust the tab count
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
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
                                builder: (context) => ShoppingAddPage()));
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
        .collection('Products')
        .doc(widget.postId)
        .collection('Comments')
        .get();

    for (var doc in commentDocs.docs) {
      FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.postId)
          .collection('Comments')
          .doc(doc.id)
          .delete();
    }

    // delete post

    FirebaseFirestore.instance
        .collection('Products')
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  title: Text(
                    widget.title,
                    style: TextStyle(color: Colors.black),
                  ),
                  pinned: true,
                  expandedHeight: 500.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          widget.img,
                        ),
                        Text(
                          widget.brand,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.price}원',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    labelColor: Colors.black,
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    indicatorColor: Colors.black,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: '상세 정보'),
                      Tab(text: '리뷰'),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Text(widget.content),
                            Text(widget.content),
                            Text(widget.content),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 80),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text('별점 들어갈자리 5.0')),
                            ),
                            Expanded(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Products')
                                    .doc(widget.postId)
                                    .collection('Reviews')
                                    .orderBy("ReviewTime", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return ListView.builder(
                                      shrinkWrap: false,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final ReviewData =
                                            snapshot.data!.docs[index];

                                        return Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      ReviewData['ReviewedBy']
                                                          .split('@')[0],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons
                                                            .more_horiz_rounded,
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  children: [
                                                    ReviewData['ReviewImage'] ==
                                                            ''
                                                        ? Container()
                                                        : Image.network(
                                                            ReviewData[
                                                                'ReviewImage'],
                                                            scale: 4,
                                                          ),
                                                    Text(
                                                      ReviewData['ReviewText'],
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                    formDate(ReviewData[
                                                        'ReviewTime']),
                                                    style: const TextStyle(
                                                        color: Colors.grey)),
                                              ]),
                                        );
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 8.0, right: 5),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShoppingReview(postId: widget.postId),
                                    ));
                              },
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(child: Text('리뷰작성')),
                              )),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 8.0),
                          child: InkWell(
                              onTap: () {
                                launchUrlString(widget.url);
                              },
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                    child: Text(
                                  '구매하기',
                                  style: TextStyle(color: Colors.white),
                                )),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
