import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/favorite_page.dart';
import 'package:mrent/pages/message_page/message_page.dart';
import 'package:mrent/pages/message_page/unauthorized_message_page.dart';

@RoutePage()
class MessageChecker extends StatefulWidget {
  const MessageChecker({this.user, super.key});
  final User? user;

  @override
  State<MessageChecker> createState() => _MessageCheckerState();
}

class _MessageCheckerState extends State<MessageChecker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.user != null
        ? MessagePage(user: widget.user!)
        : const UnauthorizedMessagePage();
  }
}
