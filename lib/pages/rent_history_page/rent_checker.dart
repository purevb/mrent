import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/rent_history_page/unauthorized_rent_history_page.dart';
import 'package:mrent/pages/rent_history_page/rent_history_page.dart';

@RoutePage()
class RentChecker extends StatefulWidget {
  const RentChecker({this.user, super.key});
  final User? user;

  @override
  State<RentChecker> createState() => _RentCheckerState();
}

class _RentCheckerState extends State<RentChecker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.user != null
        ? RentHistoryPage(user: widget.user!)
        : const UnauthorizedRentHistory();
  }
}
