import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController padsswordController;

  const LoginForm({
    required this.emailController,
    required this.padsswordController,
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: widget.emailController,
            showCursor: true,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              hintText: "И-мэйл",
              border: InputBorder.none,
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.padsswordController,
                  showCursor: true,
                  obscureText: isObscure,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    hintText: "Нууц үг",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye_solid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
