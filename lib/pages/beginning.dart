import 'package:flutter/material.dart';

class Beginning extends StatelessWidget {
  const Beginning({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [SizedBox(child: Image.asset("assets/images/2.png"))],
        ),
      ),
    );
  }
}
