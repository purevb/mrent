import 'package:flutter/material.dart';
import 'package:mrent/model/properties.dart';
import 'package:mrent/pages/components/touchable_scale.dart';
import 'package:mrent/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class NearToYouComponenState extends StatefulWidget {
  final String? id;
  final bool? isPayment;
  final String? rating;
  final String? ratingCount;
  final String? text;
  final String? location;
  final String? roomCount;
  final String? square;
  final String? rent;
  final List<String>? path;
  final PropertyData propertyData;
  const NearToYouComponenState({
    required this.propertyData,
    this.id,
    this.isPayment,
    this.text,
    this.location,
    this.roomCount,
    this.square,
    this.rent,
    this.ratingCount,
    this.rating,
    this.path,
    super.key,
  });

  @override
  State<NearToYouComponenState> createState() => _NearToYouComponenStateState();
}

class _NearToYouComponenStateState extends State<NearToYouComponenState> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    final provider = Provider.of<FavoriteProvider>(context);
    return Container(
      width: widget.isPayment == true ? screen.width : screen.width * 0.85,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                spreadRadius: 2)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: SizedBox(
              width: screen.width * 0.33,
              height: screen.height,
              child: Image.network(
                fit: BoxFit.fitHeight,
                widget.path?[0] ??
                    "https://scontent.xx.fbcdn.net/v/t1.15752-9/462565873_886592826916950_4518783065590103332_n.png?_nc_cat=110&ccb=1-7&_nc_sid=0024fc&_nc_ohc=dvKk4Z2C0fsQ7kNvgHO5NQ8&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QGlXlS2YoiHDJQT7mN_zF200iJPUv3Le3C-CYVevSKrXw&oe=675FBF41",
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          width: 15,
                          height: 15,
                          child: Image.asset(
                            fit: BoxFit.fill,
                            "assets/images/star.png",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Text(widget.rating ?? "4.9"),
                        ),
                        Text(
                          "(${widget.ratingCount ?? 104})",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.text ?? "Завхан дахь байшин",
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff1A1E25),
                    ),
                  ),
                  Text(
                    widget.location ?? "Harapan Raya, Surabaya",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff7D7F88),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Image.asset(
                            "assets/images/bed.png",
                            width: 15,
                            height: 15,
                          ),
                        ),
                        Text(
                          "${widget.roomCount ?? "2"} өрөө",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff7D7F88),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.asset(
                            "assets/images/square.png",
                            width: 15,
                            height: 15,
                          ),
                        ),
                        Text(
                          "${widget.square ?? "673"} m2",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff7D7F88),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        Text(
                          "₮ ${widget.rent ?? 526}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          " / сард",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10, bottom: 10),
                          child: TouchableScale(
                            onPressed: () {
                              setState(() {});
                              provider.toggleFavorite(widget.propertyData);
                            },
                            child: Image.asset(
                                width: 20,
                                height: 20,
                                provider.isExist(widget.propertyData)
                                    ? "assets/images/like.png"
                                    : "assets/images/Vector.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
