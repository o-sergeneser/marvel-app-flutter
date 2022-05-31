import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final String message;
  final double height;
  final double width;

  const MyErrorWidget({
    Key? key,
    required this.message,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 2),
        ),
        height: height,
        width: width,
        child: AutoSizeText(
          message,
          maxLines: 5,
          style: const TextStyle(fontSize: 100),
        ),
      ),
    );
  }
}
