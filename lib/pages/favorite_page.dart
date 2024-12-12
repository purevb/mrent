import 'package:flutter/material.dart';
import 'package:mrent/model/properties.dart';
import 'package:mrent/pages/components/tips_for_you.dart';
import 'package:mrent/pages/components/touchable_scale.dart';
import 'package:mrent/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

import 'components/horizantal_card.dart';
import 'components/text_field.dart';
import 'components/vertical_card.dart';
import 'detail_of_object_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<PropertyData> _founders = [];
  @override
  void initState() {
    super.initState();
    _founders = [];
  }

  void _runFilter(String enteredKeyword) {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    List<PropertyData> results = [];
    if (enteredKeyword.isEmpty) {
      results = provider.ids;
    } else {
      results = provider.ids
          .where((property) => property.description!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _founders = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final id = _founders.isNotEmpty ? _founders : provider.ids;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchBar(width),
                const SizedBox(
                  height: 10,
                ),
                if (id.isEmpty) ...[
                  const Center(
                      child: Text("Tand odoogoor taalagdsan object alga")),
                ] else ...[
                  Container(
                    margin: const EdgeInsets.only(left: 28, right: 28),
                    height: height,
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return TouchableScale(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailOfObjectPage(
                                          propertyData: id[index],
                                        )));
                          },
                          child: SizedBox(
                            height: height * 0.22,
                            child: NearToYouComponenState(
                              key: ValueKey(id[index].id),
                              propertyData: id[index],
                              path: [id[index].images![0]],
                              text: id[index].description!,
                              location: id[index].location!,
                              rent: id[index].nightlyPrice,
                              roomCount: id[index].numBeds.toString(),
                              square: id[index].squares.toString(),
                              rating: "5",
                              ratingCount: id[index].squares.toString(),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: id.length,
                    ),
                  ),
                ],
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fix searchBar to properly call the _runFilter function with entered value
  Container searchBar(double width) {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, bottom: 10),
      width: width,
      child: CustomizedTextField(
        onChanged: (value) => _runFilter(value),
        isDense: true,
        color: Colors.black.withOpacity(0.03),
        text: "Таалагдсан объектүүдаас хайх",
        prefixIcon: "assets/images/search-normal.png",
        suffixIcon: "assets/images/setting-5.png",
      ),
    );
  }
}
