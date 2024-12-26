import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mrent/pages/home_page.dart';
import 'package:mrent/pages/login_page.dart';
import 'package:mrent/pages/naviagation_page.dart';

class AuthService {
  Future<void> signup(
      {required String ovog,
      required String ner,
      required int age,
      required String phone,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      addUserDetails(
          ovog: ovog, ner: ner, age: age, email: email, phone: phone);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const MyHomePage()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else {
        log(e.code);
        log(message);
      }
    } catch (e) {}
  }

  Future addUserDetails(
      {required String ovog,
      required String ner,
      required int age,
      required String email,
      required String phone}) async {
    await FirebaseFirestore.instance.collection('users').add({
      'ovog': ovog,
      'ner': ner,
      'age': age,
      'email': email,
      'phone': phone,
    });
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const NavigationPage(
                    id: '',
                  )));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      } else {
        log(e.code);
      }

      // Fluttertoast.showToast(
      //   msg: message,
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.SNACKBAR,
      //   backgroundColor: Colors.black54,
      //   textColor: Colors.white,
      //   fontSize: 14.0,
      // );
    } catch (e) {}
  }

  Future<void> signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()));
  }
}
