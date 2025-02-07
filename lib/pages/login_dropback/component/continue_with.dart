import 'package:flutter/material.dart';

class ContinueWith extends StatelessWidget {
  const ContinueWith({
    super.key,
    required this.onPressed,
    required this.width,
    required this.path,
    required this.text,
  });

  final double width;
  final String path;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.asset(path),
            ),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
