import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mrent/model/fb_user_model.dart';
import 'package:mrent/pages/naviagation_page.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: mRed,
          ),
        ),
      );

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log("Google Sign-In cancelled by user.");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
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
        log("Google Sign-In successful!");
        log("User UID: ${userCredential.user?.uid}");
        log("User Email: ${userCredential.user?.email}");
        log("User Display Name: ${userCredential.user?.displayName}");

        await addUserDetails(
          userId: userCredential.user!.uid,
          gmail: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? 'Unknown Name',
          phone: userCredential.user!.phoneNumber ?? 'Unknown Phone',
        );

        String userId = userCredential.user!.uid;

        await Future.delayed(const Duration(seconds: 3));

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => NavigationPage(id: userId),
            ),
          );
        }

        return userCredential;
      } else {
        log("Google Sign-In failed: User is null.");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return null;
      }
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.code} - ${e.message}");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on PlatformException catch (e) {
      log("Platform Exception: ${e.code} - ${e.message}");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      log("Unexpected Error: $e");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
          // ignore: use_build_context_synchronously
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
        showToast(
          message.isNotEmpty ? message : 'An error occurred during signup',
          // ignore: use_build_context_synchronously
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
        );
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
        showToast(
          message.isNotEmpty ? message : 'An error occurred during signup',
          // ignore: use_build_context_synchronously
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
        );
      }

      showToast(
          message.isNotEmpty ? message : 'An error occurred during signup',
          // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
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
        showToast('Password эсвэл нэвтрэх нэр буруу байна. ',
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
