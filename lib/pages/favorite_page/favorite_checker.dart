import 'package:flutter/material.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/pages/favorite_page/favorite_page.dart';
import 'package:mrent/pages/favorite_page/unauthorized_user_favorite_page.dart';

class FavoriteChecker extends StatefulWidget {
  const FavoriteChecker({
    this.user,
    super.key,
  });
  final MongoUserModel? user;

  @override
  State<FavoriteChecker> createState() => _FavoriteCheckerState();
}

class _FavoriteCheckerState extends State<FavoriteChecker> {
  @override
  Widget build(BuildContext context) {
    return widget.user != null
        ? FavoritePage(user: widget.user!)
        : const UnauthorizedUserFavoritePage();
  }
}
