import 'package:ebbok/models/book.dart';
import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final Book book;

  const SingleProduct({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/book-details',
          arguments: book,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Image.network(
          book.image,
          fit: BoxFit.fitHeight,
          width: 180,
        ),
      ),
    );
  }
}
