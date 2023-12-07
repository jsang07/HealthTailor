import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShoppingAddPage extends StatefulWidget {
  const ShoppingAddPage({super.key});

  @override
  State<ShoppingAddPage> createState() => _ShoppingAddPageState();
}

class _ShoppingAddPageState extends State<ShoppingAddPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final titleEditingController = TextEditingController();
  final contentEditingController = TextEditingController();
  final priceEditingController = TextEditingController();
  final brandEditingController = TextEditingController();
  final urlEditingController = TextEditingController();

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

  void postMessage() async {
    if (titleEditingController.text.isNotEmpty &&
        contentEditingController.text.isNotEmpty) {
      final refImage = FirebaseStorage.instance
          .ref()
          .child('Products')
          .child('${currentUser!.email?.split('@')[0]}${Timestamp.now()}.png');
      await refImage.putFile(_image!);
      final imgUrl = await refImage.getDownloadURL();

      FirebaseFirestore.instance.collection('Products').add({
        'UserEmail': currentUser?.email,
        'Url': urlEditingController.text,
        'Brand': brandEditingController.text,
        'Title': titleEditingController.text,
        'Content': contentEditingController.text,
        'Price': priceEditingController.text,
        'Image': imgUrl,
        'Timestamp': Timestamp.now(),
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '양식 디자인 미정',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            GestureDetector(
              onTap: getImage,
              child: const Icon(Icons.add_a_photo_rounded),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _image != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.file(
                                      _image!,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 13, 10, 0),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(Icons.camera_alt),
                                  ),
                                ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(10, 13, 10, 5),
                        child: TextField(
                          maxLines: 1,
                          controller: urlEditingController,
                          decoration: InputDecoration(
                              hintText: '링크',
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
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(10, 13, 10, 5),
                        child: TextField(
                          controller: brandEditingController,
                          decoration: InputDecoration(
                              hintText: '회사명',
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
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(10, 13, 10, 5),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: priceEditingController,
                          decoration: InputDecoration(
                              hintText: '가격',
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
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(10, 13, 10, 5),
                        child: TextField(
                          controller: titleEditingController,
                          decoration: InputDecoration(
                              hintText: '제목을 입력하세요',
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
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                        child: TextField(
                          maxLines: 8,
                          controller: contentEditingController,
                          decoration: InputDecoration(
                              hintText: '내용을 입력하세요',
                              contentPadding:
                                  const EdgeInsets.only(left: 20, top: 30),
                              filled: true,
                              fillColor: Colors.grey[200],
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: GestureDetector(
                onTap: () {
                  postMessage();
                },
                child: Container(
                  width: width,
                  height: height * 0.065,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(
                    child: Text(
                      '올리기',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
