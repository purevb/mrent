import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrent/pages/components/text_field.dart';
import 'package:mrent/pages/login_page.dart';

import 'components/button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding:
            const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Container(
                color: Colors.amber,
                width: screen.width * 0.4,
                height: screen.width * 0.4,
                child: Image.asset(fit: BoxFit.fill, "assets/images/logo.png"),
              ),
            ),
            SizedBox(
              height: screen.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CustomizedTextField(
                    title: "Нэвтрэх нэр",
                    text: "E-mail",
                    prefixIcon: "assets/images/noperson.png",
                  ),
                  const CustomizedTextField(
                      obscure: true,
                      title: "Нууц үг",
                      text: "Нууц үг",
                      prefixIcon: "assets/images/nocolorkey.png"),
                  const CustomizedTextField(
                      obscure: true,
                      title: "Нууц үг давтах",
                      text: "Нууц үг",
                      prefixIcon: "assets/images/nocolorkey.png"),
                  MyButton(
                    onPress: () {},
                    text: "Бүртгүүлэх",
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Divider(
                  color: Colors.black.withOpacity(0.1),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffF3F0FF),
                      borderRadius: BorderRadius.circular(24)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  child: const Text(
                    "Эсвэл",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff9E91DA), fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: screen.width,
              height: screen.height * 0.07,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(81)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: screen.height * 0.035,
                        height: screen.height * 0.035,
                        child: Image.asset(
                            fit: BoxFit.fill, "assets/images/google.png")),
                    const Text(
                      "Sign in with Google",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 30,
                      height: 30,
                    ),
                  ]),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Та ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: 'бүртгэлтэй?',
                    style: const TextStyle(
                      color: Color(0xff6246EA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(() => const LoginPage());
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
