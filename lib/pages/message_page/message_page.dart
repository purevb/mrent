import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/utils/constants.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({required this.user, super.key});
  final User user;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
    );
  }
}
