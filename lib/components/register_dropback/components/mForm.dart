import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MForm extends StatefulWidget {
  final String hintText;
  final bool hasObscure;
  final TextEditingController controller;
  const MForm({
    required this.hasObscure,
    required this.hintText,
    required this.controller,
    super.key,
  });

  @override
  State<MForm> createState() => _MFormState();
}

class _MFormState extends State<MForm> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              showCursor: true,
              obscureText:
                  widget.hasObscure == true ? isObscure : widget.hasObscure,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 20,
                ),
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          if (widget.hasObscure == true) ...[
            IconButton(
              onPressed: () {
                setState(() {});
                isObscure = !isObscure;
              },
              icon: Icon(isObscure == true
                  ? CupertinoIcons.eye_slash
                  : CupertinoIcons.eye_solid),
            ),
          ]
        ],
      ),
    );
  }
}
