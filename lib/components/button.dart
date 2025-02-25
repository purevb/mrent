import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

class MyButton extends StatefulWidget {
  final String text;
  final bool canPress;
  final VoidCallback onPress;
  final double height;
  final double width;
  final double? borderRadius;
  final double? fontSize;

  const MyButton({
    required this.canPress,
    required this.onPress,
    required this.height,
    required this.width,
    required this.text,
    this.borderRadius,
    this.fontSize,
    super.key,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.canPress
          ? widget.onPress
          : null, // Changed to null when not pressable
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
          color: widget.canPress ? mRed : const Color(0xffc4c4c4),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.canPress ? Colors.white : Colors.black,
              fontSize: widget.fontSize ?? 18,
            ),
          ),
        ),
      ),
    );
  }
}
