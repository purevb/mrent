import 'package:flutter/material.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/components/favorite_property.dart';
import 'package:mrent/pages/login_dropback/login.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    this.user,
    super.key,
  });
  final User? user;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final provider =
        Provider.of<PropertyProvider>(context).userFavoriteProperties;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return FavoriteProperty(
                  propertyData: provider[index],
                );
              },
              itemCount: provider!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: height * 0.3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
