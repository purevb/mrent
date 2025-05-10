import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrent/components/appbar.dart';
import 'package:mrent/components/button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        _message = 'Password reset email sent. Please check your inbox.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = _getErrorMessage(e.code);
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      default:
        return 'Something went wrong. Please try again';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        height: height * 0.3,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: -12,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.cancel),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const Text(
                "Нууц үг сэргээх",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              MyButton(
                  canPress: true,
                  onPress: () {
                    _isLoading ? null : _sendPasswordResetEmail;
                  },
                  height: 50,
                  width: width,
                  text: "Илгээх"),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color: _message!.startsWith('Password reset')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }
}
