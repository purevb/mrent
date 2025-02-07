import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.black)),
      child: Column(
        children: [
          TextFormField(
            showCursor: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 10, top: 5),
              hintText: "E-mail",
              border: InputBorder.none,
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          TextFormField(
            showCursor: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 10, bottom: 10),
              hintText: "Password",
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
