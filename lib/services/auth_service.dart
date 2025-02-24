import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mrent/pages/naviagation_page.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google Sign-In cancelled by user.");
        return null;
      }
      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(cred);

      if (userCredential.user != null) {
        print("Google Sign-In successful!");
        print("User UID: ${userCredential.user?.uid}");
        print("User Email: ${userCredential.user?.email}");
        print("User Display Name: ${userCredential.user?.displayName}");

        await addUserDetails(
          userId: userCredential.user!.uid,
          gmail: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? 'Unknown Name',
          phone: userCredential.user!.phoneNumber ?? 'Unknown Phone',
        );

        String userId = userCredential.user!.uid;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => NavigationPage(
              id: userId,
            ),
          ),
        );
        return userCredential;
      } else {
        print("Google Sign-In failed: User is null.");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print(
          "Firebase Auth Error during Google Sign-In: ${e.code} - ${e.message}");
    } on PlatformException catch (e) {
      print(
          "Platform Exception during Google Sign-In: ${e.code} - ${e.message}");
    } catch (e) {
      print("Unexpected Error during Google Sign-In: $e");
    }
    return null;
  }

  Future<void> signup(
      {required String name,
      required String phone,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await addUserDetails(
          userId: userCredential.user!.uid,
          gmail: email,
          name: name,
          phone: phone,
        );
        showToast(
          'Registration successful!',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
        showToast(
          message.isNotEmpty ? message : 'An error occurred during signup',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
        );
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
        showToast(
          message.isNotEmpty ? message : 'An error occurred during signup',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
        );
      }

      showToast(
          message.isNotEmpty ? message : 'An error occurred during signup',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom);

      log(e.code);
      log(message);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addUserDetails({
    required String gmail,
    required String userId,
    required String name,
    required String phone,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'gmail': gmail,
      'name': name,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NavigationPage(
            id: userId,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
        log(message);
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
        showToast('Wrong password provided for that user.',
            // ignore: use_build_context_synchronously
            context: context,
            axis: Axis.horizontal,
            alignment: Alignment.center,
            position: StyledToastPosition.bottom);
        log(message);
      } else {
        log("${e.code} medegdhgu aldaa");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const NavigationPage()));
  }
}
