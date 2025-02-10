import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mForm extends StatefulWidget {
  final String hintText;
  final bool hasObscure;
  final TextEditingController controller;
  const mForm({
    required this.hasObscure,
    required this.hintText,
    required this.controller,
    super.key,
  });

  @override
  State<mForm> createState() => _mFormState();
}

class _mFormState extends State<mForm> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xffC4C4C4).withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              showCursor: true,
              obscureText: isObscure,
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
