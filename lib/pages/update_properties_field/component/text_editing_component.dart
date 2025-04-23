import 'package:flutter/material.dart';

class TextEditingComponent extends StatefulWidget {
  const TextEditingComponent({
    required this.hintText,
    required this.title,
    super.key,
    required this.controller,
  });
  final String hintText;
  final String title;
  final TextEditingController controller;

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
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade300),
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
