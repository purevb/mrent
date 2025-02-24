import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/favorite_page.dart';
import 'package:mrent/pages/favorite_page/unauthorized_user_favorite_page.dart';

@RoutePage()
class FavoriteChecker extends StatefulWidget {
  const FavoriteChecker({this.user, super.key});
  final User? user;

  @override
  State<FavoriteChecker> createState() => _ProfileCheckerState();
}

class _ProfileCheckerState extends State<FavoriteChecker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.user != null
        ? FavoritePage(user: widget.user!)
        : const UnauthorizedUserFavoritePage();
  }
}
