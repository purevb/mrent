import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/pages/components/button.dart';
import 'package:mrent/pages/login_dropback/component/continue_with.dart';
import 'package:mrent/pages/login_dropback/component/login_form.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      height: height * 0.92,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBar(
            shadowColor: Colors.black,
            elevation: 0.8,
            backgroundColor: Colors.white,
            leading: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                "assets/images/navigationbar/Close.svg",
                width: 20,
                height: 20,
              ),
            ),
            title: const Text(
              "Log in or sign up",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            centerTitle: true,
          ),
          const LoginForm(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MyButton(
                onPress: () {}, height: 55, width: width, text: "Continue"),
          ),
          customDivider(),
          Expanded(
            child: Column(
              spacing: 15,
              children: [
                ContinueWith(
                  onPressed: () {},
                  width: width,
                  path: "assets/login/mail-inbox-app.png",
                  text: "Continue with email",
                ),
                ContinueWith(
                  onPressed: () {},
                  width: width,
                  path: "assets/login/gmail.png",
                  text: "Continue with gmail",
                ),
                ContinueWith(
                  onPressed: () {},
                  width: width,
                  path: "assets/login/apple-logo.png",
                  text: "Continue with apple",
                ),
                ContinueWith(
                  onPressed: () {},
                  width: width,
                  path: "assets/login/facebook.png",
                  text: "Continue with facebook",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container customDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 30,
                right: 15,
              ),
              height: 1,
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          const Text("or"),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 15,
                right: 30,
              ),
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.4),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
