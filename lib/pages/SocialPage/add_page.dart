import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final titleEditingController = TextEditingController();
  final contentEditingController = TextEditingController();

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
      if (_image != null) {
        final refImage = FirebaseStorage.instance
            .ref()
            .child('PostPhotos')
            .child(
                '${currentUser!.email?.split('@')[0]}${Timestamp.now()}.png');
        await refImage.putFile(_image!);
        final imgUrl = await refImage.getDownloadURL();

        FirebaseFirestore.instance.collection('User Posts').add({
          'UserEmail': currentUser?.email,
          'Title': titleEditingController.text,
          'Content': contentEditingController.text,
          'Timestamp': Timestamp.now(),
          'Image': imgUrl,
          'Likes': [],
        });
      } else if (_image == null) {
        FirebaseFirestore.instance.collection('User Posts').add({
          'UserEmail': currentUser?.email,
          'Title': titleEditingController.text,
          'Content': contentEditingController.text,
          'Timestamp': Timestamp.now(),
          'Image': '',
          'Likes': [],
        });
      }
    }
    Navigator.pop(context);
  }

  void showPostCheckDialog() {
    showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: AlertDialog(
          title: const Text('글을 등록하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          content: Container(
            height: 170,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('주제에 벗어나거나 악의적인 글은 관리자에 의해 삭제될 수 있습니다',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          postMessage();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fixedSize: const Size(120, 50),
                            backgroundColor: Colors.lightBlue[100]),
                        child: const Text('등록하기',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            fixedSize: const Size(120, 50),
                            backgroundColor: Colors.lightBlue[100]),
                        child: const Text('취소',
                            style: TextStyle(fontWeight: FontWeight.w600)))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          title: Text(
            '???',
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
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
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
                        maxLines: 12,
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
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.file(
                                    _image!,
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ],
                ),
              ]),
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
                      '글 올리기',
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
