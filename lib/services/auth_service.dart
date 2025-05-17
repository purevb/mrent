import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/pages/naviagation_page.dart';
import 'package:mrent/utils/constants.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  Api api = Api();

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
          api.postSyncUserFromFirebase().then((_) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NavigationPage(id: userId),
              ),
            );
          });
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

  Future<bool> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
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
          'Та амжилттай бүртгүүллээ.',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
        );

        await api.postSyncUserFromFirebase();
        Navigator.pop(context);
        Navigator.pop(context);

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseErrorMessage(e.code);
      showToast(
        message,
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        position: StyledToastPosition.bottom,
      );
      log('Signup Error: ${e.code} - $message');
      return false;
    } catch (e) {
      showToast(
        'An unexpected error occurred',
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        position: StyledToastPosition.bottom,
      );
      log('Unexpected Signup Error: ${e.toString()}');
      return false;
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
        Navigator.pop(context);
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

  Future<bool> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  Future<void> resendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> updateEmailVerificationStatus(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'emailVerified': true,
    });
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
