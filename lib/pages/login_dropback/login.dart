import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/components/appbar.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/pages/login_dropback/component/continue_with.dart';
import 'package:mrent/pages/login_dropback/component/login_form.dart';
import 'package:mrent/pages/register_dropback/register.dart';
import 'package:mrent/utils/constants.dart';

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
          const mAppBar(),
          const LoginForm(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: MyButton(
              canPress: true,
              onPress: () {},
              height: 55,
              width: width,
              text: "Continue",
            ),
          ),
          customDivider(height),
          Expanded(
            child: Column(
              spacing: 10,
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Dont you have account? ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const Register();
                            },
                          ).then((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Register",
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
