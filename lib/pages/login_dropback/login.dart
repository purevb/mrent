import 'package:flutter/material.dart';
import 'package:mrent/components/appbar.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/pages/login_dropback/component/continue_with.dart';
import 'package:mrent/pages/login_dropback/component/login_form.dart';
import 'package:mrent/pages/register_dropback/register.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:mrent/utils/constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  Future<void> signUserIn() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      await AuthService().signin(
          email: emailController.text,
          password: passwordController.text,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
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
          const MappBar(),
          LoginForm(
            emailController: emailController,
            padsswordController: passwordController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MyButton(
              canPress: true,
              onPress: () async {
                signUserIn();
              },
              height: 55,
              width: width,
              text: "Үргэлжлүүлэх",
            ),
          ),
          customDivider(height),
          Expanded(
            child: Column(
              spacing: 20,
              children: [
                ContinueWith(
                  working: false,
                  onPressed: () {},
                  width: width,
                  path: "assets/login/mail-inbox-app.png",
                  text: "Email-ээр нэвтрэх",
                ),
                ContinueWith(
                  working: true,
                  onPressed: () async {
                    await _auth.loginWithGoogle(context);
                  },
                  width: width,
                  path: "assets/login/gmail.png",
                  text: "Gmail-ээр нэвтрэх",
                ),
                ContinueWith(
                  working: false,
                  onPressed: () {},
                  width: width,
                  path: "assets/login/apple-logo.png",
                  text: "Apple-ээр нэвтрэх",
                ),
                ContinueWith(
                  working: false,
                  onPressed: () {},
                  width: width,
                  path: "assets/login/facebook.png",
                  text: "Facebook-ээр нэвтрэх",
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Танд бүртгэл байгаа юу? ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const Register();
                            },
                          );
                        },
                        child: Text(
                          "Бүртгүүлэх",
                          style: TextStyle(
                              color: mRed, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container customDivider(double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
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
