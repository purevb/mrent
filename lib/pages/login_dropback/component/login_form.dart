import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController padsswordController;

  const LoginForm({
    required this.emailController,
    required this.padsswordController,
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
            controller: emailController,
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
            controller: padsswordController,
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
