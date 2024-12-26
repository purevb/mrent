import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mrent/pages/home_page.dart';
import 'package:mrent/pages/naviagation_page.dart';
import 'package:mrent/services/auth_service.dart';

import 'components/button.dart';
import 'components/text_field.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final rePasswordController = TextEditingController();
  Future<void> postUser() async {
    if (!validateEmail(emailController.text)) {
      Fluttertoast.showToast(msg: "Email must include '@' and be valid.");
      return;
    }
    if (!validatePassword(passwordController.text)) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters.");
      return;
    }
    final authService = AuthService();
    await authService.signup(
        email: emailController.text,
        password: passwordController.text,
        context: context,
        ovog: nameController.text,
        ner: nameController.text,
        age: 15,
        phone: phoneController.text);
  }

  bool validateEmail(String email) {
    return email.contains('@');
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  // bool validatePhone(String phone) {
  //   final phoneRegex = RegExp(r'^\d{8}$');
  //   return phoneRegex.hasMatch(phone);
  // }

  void checkPasswordsAndRegister() async {
    if (passwordController.text != rePasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: 50,
              height: 100,
              child: const Center(child: Text("Таний 2 password uur baina.")),
            ),
          );
        },
      );
      return;
    }

    postUser();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: screen.width * 0.2,
                  height: screen.width * 0.2,
                  child: Image.asset(
                      fit: BoxFit.fill, "assets/images/logologo.png"),
                ),
              ),
            ),
            SizedBox(
              height: screen.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomizedTextField(
                    controller: emailController,
                    title: "Нэвтрэх нэр",
                    text: "E-mail",
                    prefixIcon: "assets/images/noperson.png",
                  ),
                  CustomizedTextField(
                    controller: passwordController,
                    obscure: false,
                    title: "Нууц үг",
                    text: "Нууц үг",
                    prefixIcon: "assets/images/nocolorkey.png",
                  ),
                  CustomizedTextField(
                    controller: rePasswordController,
                    obscure: false,
                    title: "Нууц үг давтах",
                    text: "Нууц үг давтах",
                    prefixIcon: "assets/images/nocolorkey.png",
                  ),
                  CustomizedTextField(
                    controller: phoneController,
                    obscure: false,
                    title: "Утасны дугаар",
                    text: "Утасны дугаар",
                    prefixIcon: "assets/images/noperson.png",
                  ),
                  CustomizedTextField(
                    controller: nameController,
                    obscure: false,
                    title: "Нэр",
                    text: "Нэр",
                    prefixIcon: "assets/images/noperson.png",
                  ),
                  MyButton(
                    width: screen.width,
                    height: screen.height * 0.07,
                    onPress: () => checkPasswordsAndRegister(),
                    text: "Бүртгүүлэх",
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Divider(color: Colors.black.withOpacity(0.1)),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F0FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  child: const Text(
                    "Эсвэл",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff9E91DA),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                // Google sign-in logic
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: screen.width,
                height: screen.height * 0.07,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(81),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/google.png",
                      width: screen.height * 0.035,
                      height: screen.height * 0.035,
                      fit: BoxFit.fill,
                    ),
                    const Text(
                      "Sign in with Google",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
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
