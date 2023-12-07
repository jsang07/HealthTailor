import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_taylor/pages/shopPage/shopping_detail_page.dart';

class ShoppingPost extends StatefulWidget {
  final String url, title, content, img, brand, price, user, postId, time;
  const ShoppingPost({
    super.key,
    required this.user,
    required this.postId,
    required this.time,
    required this.title,
    required this.content,
    required this.img,
    required this.price,
    required this.brand,
    required this.url,
  });

  @override
  State<ShoppingPost> createState() => _ShoppingPostState();
}

class _ShoppingPostState extends State<ShoppingPost> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShoppingDetailPage(
                  url: widget.url,
                  brand: widget.brand,
                  price: widget.price,
                  title: widget.title,
                  content: widget.content,
                  img: widget.img,
                  user: widget.user,
                  postId: widget.postId,
                  time: widget.time,
                ),
              ));
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(5, 15, 0, 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.img,
                  scale: 2,
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.brand,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        Text(
                          '평점 들어갈자리',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.price}원',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
