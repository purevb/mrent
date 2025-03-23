import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class MyPropertiesPage extends StatefulWidget {
  const MyPropertiesPage({super.key});

  @override
  State<MyPropertiesPage> createState() => _MyPropertiesPageState();
}

class _MyPropertiesPageState extends State<MyPropertiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Миний түрээслүүлж буй",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Text("sad"),
          ],
        ),
      ),
    );
  }
}
