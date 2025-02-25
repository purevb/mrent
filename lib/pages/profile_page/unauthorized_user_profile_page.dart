import 'package:flutter/material.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/pages/login_dropback/login.dart';
import 'package:mrent/utils/constants.dart';

class UnauthorizedUserProfilePage extends StatefulWidget {
  const UnauthorizedUserProfilePage({super.key});

  @override
  State<UnauthorizedUserProfilePage> createState() => _UnauthorizedUserState();
}

class _UnauthorizedUserState extends State<UnauthorizedUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Профайл",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: textDefaultColor),
              ),
              Text(
                "Дараагийн аялалаа эхлэхийн тулд нэвтэрнэ үү!",
                style: TextStyle(color: textDefaultColor, fontSize: 16),
              ),
              MyButton(
                canPress: true,
                onPress: () {
                  showModalBottomSheet(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const Login();
                    },
                  );
                },
                height: 60,
                width: 240,
                text: "Нэвтрэх",
              )
            ],
          ),
        ),
      ),
    );
  }
}
