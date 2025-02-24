import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/utils/constants.dart';

class RentHistoryPage extends StatefulWidget {
  const RentHistoryPage({required this.user, super.key});
  final User user;

  @override
  State<RentHistoryPage> createState() => _RentHistoryPageState();
}

class _RentHistoryPageState extends State<RentHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
    );
  }
}
