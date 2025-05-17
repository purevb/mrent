import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/pages/naviagation_page.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:mrent/utils/constants.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  final String password;

  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final AuthService _authService = AuthService();
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;
  int resendCooldown = 0;
  late Timer cooldownTimer;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    if (mounted && resendCooldown > 0) {
      cooldownTimer.cancel();
    }
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await _authService.signin(
        email: widget.email,
        password: widget.password,
        context: context,
      );
      return;
    }

    await user.reload();

    if (user.emailVerified && mounted) {
      setState(() {
        isEmailVerified = true;
      });

      timer?.cancel();
      await _authService.updateEmailVerificationStatus(user.uid);

      if (mounted) {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => NavigationPage(id: user.uid),
          ),
        );
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    if (!canResendEmail) return;

    setState(() {
      canResendEmail = false;
      resendCooldown = 60; // 60 seconds cooldown
    });

    await _authService.resendVerificationEmail();

    // Set up cooldown timer
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SvgPicture.asset(
                  "assets/verification/email_verification.svg",
                  height: height * 0.3,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
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
                    "Бүртгэлээ баталгаажуулах холбоос бүхий имэйл ${widget.email} хаяг руу илгээгдсэн байгаа. Таны имэйл хаягийг баталгаажуулснаар бид таныг хамгаалж чадна.",
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
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => _authService.signout(context),
                  child: Text(
                    "Гарах",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
