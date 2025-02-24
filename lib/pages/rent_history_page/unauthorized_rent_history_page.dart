import 'package:flutter/material.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/login_dropback/login.dart';
import 'package:mrent/utils/constants.dart';

class UnauthorizedRentHistory extends StatefulWidget {
  const UnauthorizedRentHistory({
    this.user,
    super.key,
  });
  final User? user;

  @override
  State<UnauthorizedRentHistory> createState() => _RentHistoryPageState();
}

class _RentHistoryPageState extends State<UnauthorizedRentHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: textDefaultColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Trips",
                    style: TextStyle(
                      fontSize: 36,
                      color: textDefaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "No trips yet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: textDefaultColor,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "When you're ready to plan your next trip\nwe're here to help",
                    style: TextStyle(fontSize: 16, color: textDefaultColor),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(top: 60, left: 20),
                  child: MyButton(
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
                    height: 55,
                    width: 120,
                    text: "Log in",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
