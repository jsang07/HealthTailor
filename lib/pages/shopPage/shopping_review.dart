import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShoppingReview extends StatefulWidget {
  final String postId;
  const ShoppingReview({super.key, required this.postId});

  @override
  State<ShoppingReview> createState() => _ShoppingReviewState();
}

class _ShoppingReviewState extends State<ShoppingReview> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final reviewtextEditingController = TextEditingController();
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  void postReview() async {
    if (reviewtextEditingController.text.isNotEmpty) {
      if (_image != null) {
        final refImage = FirebaseStorage.instance.ref().child('Reviews').child(
            '${currentUser!.email?.split('@')[0]}${Timestamp.now()}.png');
        await refImage.putFile(_image!);
        final imgUrl = await refImage.getDownloadURL();

        FirebaseFirestore.instance
            .collection('Products')
            .doc(widget.postId)
            .collection('Reviews')
            .add({
          "ReviewText": reviewtextEditingController.text,
          "ReviewedBy": currentUser?.email,
          'ReviewImage': imgUrl,
          "ReviewTime": Timestamp.now()
        });
      } else if (_image == null) {
        FirebaseFirestore.instance
            .collection('Products')
            .doc(widget.postId)
            .collection('Reviews')
            .add({
          "ReviewText": reviewtextEditingController.text,
          "ReviewedBy": currentUser?.email,
          'ReviewImage': '',
          "ReviewTime": Timestamp.now()
        });
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('리뷰 작성'),
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '별점을 눌러 만족도를 알려주세요',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('만족도'),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                star1 = !star1;
                              });
                            },
                            child: Icon(
                              Icons.star_rounded,
                              size: 35,
                              color: star1 ? Colors.amber : Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                star1 = !star1;
                                star2 = !star2;
                              });
                            },
                            child: Icon(
                              Icons.star_rounded,
                              size: 35,
                              color: star2 ? Colors.amber : Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                star1 = !star1;
                                star2 = !star2;
                                star3 = !star3;
                              });
                            },
                            child: Icon(
                              Icons.star_rounded,
                              size: 35,
                              color: star3 ? Colors.amber : Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                star1 = !star1;
                                star2 = !star2;
                                star3 = !star3;
                                star4 = !star4;
                              });
                            },
                            child: Icon(
                              Icons.star_rounded,
                              size: 35,
                              color: star4 ? Colors.amber : Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                star1 = !star1;
                                star2 = !star2;
                                star3 = !star3;
                                star4 = !star4;
                                star5 = !star5;
                              });
                            },
                            child: Icon(
                              Icons.star_rounded,
                              size: 35,
                              color: star5 ? Colors.amber : Colors.grey,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '사진 업로드 (선택)',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: getImage,
                        child: _image != null
                            ? Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.file(
                                  _image!,
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15)),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text('사진 업로드'),
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '리뷰 작성하기',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        maxLines: 8,
                        controller: reviewtextEditingController,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 18, top: 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(child: Text('취소')),
                      )),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          postReview();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Center(
                              child: Text(
                            '작성하기',
                            style: TextStyle(color: Colors.white),
                          )),
                        )),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
