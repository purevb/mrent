import 'package:flutter/material.dart';

class TextEditingComponent extends StatefulWidget {
  const TextEditingComponent({
    required this.hintText,
    required this.title,
    super.key,
  });
  final String hintText;
  final String title;

  @override
  State<TextEditingComponent> createState() => _TextEditingComponentState();
}

class _TextEditingComponentState extends State<TextEditingComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        TextField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
