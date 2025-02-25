import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrent/components/appbar.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/pages/register_dropback/components/mForm.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:mrent/utils/constants.dart';

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
  bool canCreate = false;

  // final Map<int, Map<String, String>> properties = {
  //   1: {
  //     "booster": "assets/subscription_loyalty/backgrounds/nbooster.png",
  //     "background": "assets/subscription_loyalty/backgrounds/nnbackground.png",
  //   },
  //   2: {
  //     "booster": "assets/subscription_loyalty/backgrounds/ubooster.png",
  //     "background": "assets/subscription_loyalty/backgrounds/ubackground.png",
  //   },
  //   3: {
  //     "booster": "assets/subscription_loyalty/backgrounds/obooster.png",
  //     "background": "assets/subscription_loyalty/backgrounds/obackground.png",
  //   },
  // };
  Map<int, Map<String, String>> profileListTile = {
    0: {"icon": ""}
  };
  Future<void> checkTwoPasswordsEqualThenSignUp(
      String password, String verifyPassword) async {
    if (password == verifyPassword) {
      setState(() {
        canCreate = true;
      });
      AuthService authService = AuthService();
      await authService.signup(
          name: nameController.text,
          phone: phoneNumberController.text,
          email: emailController.text,
          password: passwordController.text,
          context: context);
    } else {
      Fluttertoast.showToast(
          msg: "Passwords have to equal",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      height: height * 0.92,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 10,
        children: [
          const MappBar(),
          Container(
            height: height * 0.2,
            width: double.infinity,
            padding: EdgeInsets.only(left: width * 0.25),
            child: SvgPicture.asset(
                fit: BoxFit.contain, "assets/signup/signup_background.svg"),
          ),
          MForm(
            controller: emailController,
            hintText: "E-mail",
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
                  onChanged: ((value) {
                    setState(() {});
                    isCheck = value!;
                  }),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 10, color: Colors.black),
                      children: [
                        const TextSpan(
                          text: 'Та ',
                        ),
                        TextSpan(
                          text: 'шаардлага',
                          style: TextStyle(
                            color: mRed,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' ба '),
                        TextSpan(
                          text: 'нөхцөлийг',
                          style: TextStyle(
                            color: mRed,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(
                          text: 'зөвшөөрснөөр бүртгүүлэх боломжтой болно.г',
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
                canPress: isCheck == true ? true : false,
                onPress: () {
                  checkTwoPasswordsEqualThenSignUp(
                    passwordController.text,
                    verifypasswordController.text,
                  );
                },
                height: height * 0.07,
                width: width,
                text: "Бүртгүүлэх",
              ),
            ),
          )
        ],
      ),
    );
  }

  Container customDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 30,
                right: 15,
              ),
              height: 1,
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          const Text("or"),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 15,
                right: 30,
              ),
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.4),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
