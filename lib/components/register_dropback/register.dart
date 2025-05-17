import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/appbar.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/components/register_dropback/components/mForm.dart';
import 'package:mrent/pages/naviagation_page.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:mrent/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifypasswordController =
      TextEditingController();

  bool isCheck = false;
  bool isLoading = false;
  bool isVerifying = false;
  bool canResendEmail = true;
  int resendCooldown = 0;
  Timer? verificationTimer;
  Timer? cooldownTimer;

  final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  final RegExp phoneRegex = RegExp(r'^[89][0-9]{7}$');

  @override
  void dispose() {
    verificationTimer?.cancel();
    cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.reload();

    if (user.emailVerified) {
      verificationTimer?.cancel();
      await AuthService().updateEmailVerificationStatus(user.uid);
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(id: user.uid),
          ),
        );
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    if (!canResendEmail) return;

    setState(() {
      canResendEmail = false;
      resendCooldown = 60;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }

    cooldownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {
            if (resendCooldown > 0) {
              resendCooldown--;
            } else {
              canResendEmail = true;
              timer.cancel();
            }
          });
        }
      },
    );
  }

  Future<void> checkInputsAndSignUp() async {
    String email = emailController.text.trim();
    String phone = phoneNumberController.text.trim();
    String password = passwordController.text;
    String verifyPassword = verifypasswordController.text;

    if (!gmailRegex.hasMatch(email)) {
      Fluttertoast.showToast(
        msg: "Зөвхөн Gmail хаяг оруулна уу",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      Fluttertoast.showToast(
        msg:
            "Утасны дугаар буруу байна (8 оронтой, 8 эсвэл 9-р эхэлсэн байх ёстой)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password.length < 6) {
      Fluttertoast.showToast(
        msg: "Нууц үг хамгийн багадаа 6 тэмдэгт байх ёстой",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password != verifyPassword) {
      Fluttertoast.showToast(
        msg: "Нууц үг таарахгүй байна",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await AuthService().addUserDetails(
          userId: userCredential.user!.uid,
          gmail: email,
          name: nameController.text,
          phone: phone,
        );

        await userCredential.user!.sendEmailVerification();

        setState(() {
          isLoading = false;
          isVerifying = true;
        });

        verificationTimer = Timer.periodic(
          const Duration(seconds: 3),
          (_) => checkEmailVerified(),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: _getFirebaseErrorMessage(e.code),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Алдаа гарлаа: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'Signup failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (isVerifying) {
      return Container(
        padding: const EdgeInsets.only(bottom: 30, top: 10),
        height: height * 0.52,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 60),
            Text(
              "Имэйл хаягаа баталгаажуулна уу",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Бүртгэлээ баталгаажуулах холбоос бүхий имэйл ${emailController.text.trim()} хаяг руу илгээгдсэн байгаа. Таны имэйл хаягийг баталгаажуулснаар бид таныг хамгаалж чадна.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MyButton(
                  canPress: canResendEmail,
                  onPress: resendVerificationEmail,
                  height: height * 0.07,
                  width: width * 0.7,
                  text: canResendEmail
                      ? "Имэйл дахин илгээх"
                      : "Дахин илгээх ($resendCooldownс)",
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => checkEmailVerified(),
              child: Text(
                "Би аль хэдийн баталгаажуулсан",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: mRed,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 5,
      ),
      margin: const EdgeInsets.only(
        top: 65,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Align(
                alignment: Alignment.topCenter,
                child: MappBar(title: 'Нэвтрэх эсвэл бүртгүүлэх'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: SingleChildScrollView(
                child: Container(
                  height: height * 0.92,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        height: height * 0.2,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: width * 0.25),
                        child: SvgPicture.asset(
                          "assets/signup/signup_background.svg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      MForm(
                        controller: emailController,
                        hintText: "E-mail (Gmail хаяг)",
                        hasObscure: false,
                      ),
                      MForm(
                        controller: nameController,
                        hintText: "Нэр",
                        hasObscure: false,
                      ),
                      MForm(
                        controller: phoneNumberController,
                        hintText: "Утасны дугаар",
                        hasObscure: false,
                      ),
                      MForm(
                        controller: passwordController,
                        hintText: "Нууц үг",
                        hasObscure: true,
                      ),
                      MForm(
                        controller: verifypasswordController,
                        hintText: "Нууц үг давтах",
                        hasObscure: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheck,
                              onChanged: (value) {
                                setState(() {
                                  isCheck = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                      fontSize: 10, color: Colors.black),
                                  children: [
                                    const TextSpan(text: 'Та '),
                                    TextSpan(
                                      text: 'шаардлага',
                                      style: GoogleFonts.inter(
                                        color: mRed,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' ба '),
                                    TextSpan(
                                      text: 'нөхцөлийг',
                                      style: GoogleFonts.inter(
                                        color: mRed,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          ' зөвшөөрснөөр бүртгүүлэх боломжтой болно. Та имэйл хаягаа заавал баталгаажуулах шаардлагатай.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: MyButton(
                            canPress: isCheck && !isLoading,
                            onPress: () => checkInputsAndSignUp(),
                            height: height * 0.07,
                            width: width,
                            text: isLoading ? "Бүртгэж байна..." : "Бүртгүүлэх",
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
