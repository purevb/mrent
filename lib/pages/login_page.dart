import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mrent/pages/components/text_field.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/button.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> signUserIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (emailController.text.isNotEmpty && passWordController.text.isNotEmpty) {
      await AuthService().signin(
          email: emailController.text,
          password: passWordController.text,
          context: context);
      //   var reqBody = {
      //     "email": emailController.text,
      //     "password": passWordController.text,
      //   };

      //   try {
      //     var response = await http.post(
      //       Uri.parse('http://10.0.2.2:3106/api/login'),
      //       headers: {"Content-Type": "application/json"},
      //       body: jsonEncode(reqBody),
      //     );

      //     if (response.statusCode == 200) {
      //       var jsonResponse = jsonDecode(response.body);
      //       bool status = jsonResponse['status'] ?? false;

      //       if (status) {
      //         var myToken = jsonResponse['token'];
      //         var id = jsonResponse['id'];

      //         await prefs.setString('token', myToken);

      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => NavigationPage(
      //               id: id,
      //             ),
      //           ),
      //         );
      //         print('Token checked');
      //       } else {
      //         // Handle login failure
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(content: Text('Invalid email or password')),
      //         );
      //       }
      //     } else {
      //       print('Server returned an error: ${response.statusCode}');
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text('Invalid email or password')),
      //       );
      //     }
      //   } catch (e) {
      //     print('Error during login: $e');
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('Error: $e')),
      //     );
      //   }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Email and password cannot be empty')),
      //   );
      // }
    }
  }

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: screen.width * 0.35,
                  height: screen.width * 0.35,
                  child: Image.asset(
                      fit: BoxFit.fill, "assets/images/logologo.png"),
                ),
              ),
            ),
            SizedBox(
              height: screen.height * 0.1,
            ),
            SizedBox(
              height: screen.height * 0.4,
              child: Form(
                key: _formKey,
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
                      controller: passWordController,
                      obscure: true,
                      title: "Нууц үг",
                      text: "Нууц үг",
                      prefixIcon: "assets/images/nocolorkey.png",
                    ),
                    MyButton(
                      width: screen.width,
                      height: screen.height * 0.06,
                      onPress: signUserIn,
                      text: "Нэвтрэх",
                    ),
                    const Text(
                      "Нууц үгээ мартсан уу?",
                      style: TextStyle(color: Color(0xff7D7F88)),
                    ),
                  ],
                ),
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
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: screen.width,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(81)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 30,
                        height: 30,
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
            SizedBox(height: screen.height * 0.04),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Шинэ хэрэглэгч? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: 'Бүртгүүлэх',
                    style: const TextStyle(
                      color: Color(0xff6246EA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.router.pushNamed('/register');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const RegisterPage()));
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
