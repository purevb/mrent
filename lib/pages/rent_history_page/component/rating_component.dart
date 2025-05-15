import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class RatingComponent extends StatefulWidget {
  final String propertyId;
  const RatingComponent({required this.propertyId, super.key});

  @override
  State<RatingComponent> createState() => _RatingComponentState();
}

class _RatingComponentState extends State<RatingComponent> {
  Api api = Api();
  double value = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        spacing: 10,
        children: [
          Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 190, 190, 190),
                borderRadius: BorderRadius.circular(30)),
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RatingStars(
                value: value,
                onValueChanged: (v) {
                  setState(() {
                    value = v;
                  });
                },
                starBuilder: (index, color) => Icon(
                  Icons.star,
                  size: 50,
                  color: color,
                ),
                starCount: 5,
                starSize: 50,
                valueLabelColor: Colors.white,
                valueLabelTextStyle: TextStyle(
                    color: mRed,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 22.0),
                valueLabelRadius: 10,
                maxValue: 5,
                starSpacing: 1,
                maxValueVisibility: true,
                valueLabelVisibility: false,
                animationDuration: const Duration(milliseconds: 600),
                valueLabelPadding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                valueLabelMargin: const EdgeInsets.only(right: 8),
                starOffColor: const Color(0xffe7e8ea),
                starColor: Colors.yellow,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: MyButton(
                  canPress: true,
                  onPress: () async {
                    await api
                        .postRating(
                      userId: provider.getUser?.id ?? "",
                      propertyId: widget.propertyId,
                      rating: value,
                    )
                        .then((value) {
                      if (value == 201) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  height: 45,
                  width: 70,
                  text: "Үнэлэх",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
