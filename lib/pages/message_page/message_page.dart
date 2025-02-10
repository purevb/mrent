import 'package:flutter/material.dart';
import 'package:mrent/pages/components/button.dart';
import 'package:mrent/pages/login_dropback/login.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Wishlists",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Flexible(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Log in to view your wishlists",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              const Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "You can create, view or edit wishlists once you've logged in.",
                    style: TextStyle(fontSize: 16),
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
