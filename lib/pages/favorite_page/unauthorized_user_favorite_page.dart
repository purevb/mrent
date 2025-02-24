import 'package:flutter/material.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/login_dropback/login.dart';
import 'package:mrent/utils/constants.dart';

class UnauthorizedUserFavoritePage extends StatefulWidget {
  const UnauthorizedUserFavoritePage({
    this.user,
    super.key,
  });
  final User? user;

  @override
  State<UnauthorizedUserFavoritePage> createState() =>
      _UnauthorizedUserFavoritePageState();
}

class _UnauthorizedUserFavoritePageState
    extends State<UnauthorizedUserFavoritePage> {
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
                          fontWeight: FontWeight.bold,
                          color: textDefaultColor,
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
                    "Wishlists",
                    style: TextStyle(
                      color: textDefaultColor,
                      fontSize: 36,
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
                    "Log in to view your wishlists",
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
                    "You can create, view or edit wishlists once you've logged in.",
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
