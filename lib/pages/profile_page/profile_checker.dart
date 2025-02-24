import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/profile_page/profile_page.dart';
import 'package:mrent/pages/profile_page/unauthorized_user_profile_page.dart';

@RoutePage()
class ProfileChecker extends StatefulWidget {
  const ProfileChecker({this.user, super.key});
  final User? user;

  @override
  State<ProfileChecker> createState() => _ProfileCheckerState();
}

class _ProfileCheckerState extends State<ProfileChecker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.user != null
        ? ProfilePage(user: widget.user!)
        : const UnauthorizedUserProfilePage();
  }
}
