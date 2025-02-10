import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final bool? canPress;
  final VoidCallback onPress;
  final double height;
  final double width;

  const MyButton(
      {this.canPress,
      required this.onPress,
      required this.height,
      required this.width,
      required this.text,
      super.key});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xffe61c50),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
