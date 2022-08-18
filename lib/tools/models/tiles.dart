import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    Key? key,
    required this.title,
    required this.content,
    required this.index,
    required this.isFav,
  }) : super(key: key);

  final String title;
  final String content;
  final int index;
  final bool isFav;

  Widget _indexItem() => SizedBox(
    height: 60,
    width: 60,
    child: Material(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
      child: Center(
        child: Text("$index"),
      ),
    ),
  );

  Widget _textItem(double size) => SizedBox(
    width: size,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            content,
            overflow: TextOverflow.clip,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _favItem() => Material(
    borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
    child: Center(
      child: Icon(isFav? Icons.favorite:Icons.favorite_border),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _indexItem(),
                const SizedBox(width: 24,),
                _textItem(MediaQuery.of(context).size.width/2),
              ],
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: _favItem(),
            ),
          ],
        ),
      ),
    );
  }
}