import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/pages/add_property_pages/where_is_location.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class AddPropertyDetailsPage extends StatefulWidget {
  final String name;
  final String id;
  const AddPropertyDetailsPage(
      {required this.id, required this.name, super.key});

  @override
  State<AddPropertyDetailsPage> createState() => _AddPropertyDetailsState();
}

class _AddPropertyDetailsState extends State<AddPropertyDetailsPage> {
  final TextEditingController textController = TextEditingController();
  String? selectedPropertyCategory;
  bool _validate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  final Map<int, Map<String, dynamic>> appbarCategoryIcons = {
    0: {
      "icon": "assets/search/amazing_views.png",
      "iconName": "Байгалийн сайхан",
      "iconType": "Nature",
    },
    1: {
      "icon": "assets/search/house.png",
      "iconName": " Байшин",
      "iconType": "House",
    },
    2: {
      "icon": "assets/search/near_river.png",
      "iconName": "Голтой ойрхон",
      "iconType": "River",
    },
    3: {
      "icon": "assets/search/tent.png",
      "iconName": "Майхан",
      "iconType": "Tent",
    },
    4: {
      "icon": "assets/search/yurt.png",
      "iconName": "Гэр",
      "iconType": "Yurts",
    },
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Tүрээслүүлэх сууц нэмэх",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text:
                    "Сайн байна уу ? ${capitalizeFirstLetter(widget.name.replaceAll(" ", ""))} ,Та түрээслэх cууцын мэдээлэлүүдээ оруулна уу.",
                style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Нэр",
              style: GoogleFonts.lato(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 226, 230),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        errorText: _validate ? "Хоосон байж болохгүй" : null,
                        hintText: "Саравчтай байшин",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      "assets/add_property/House.png",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Сууцын төрлүүд",
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10), // Add spacing
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (int i = 0; i < appbarCategoryIcons.length; i++)
                  _typeXi(
                    appbarCategoryIcons[i]!['iconName'],
                  ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _validate = textController.text.isEmpty;
                });

                if (textController.text.isEmpty ||
                    selectedPropertyCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Нэр болон сууцын төрлийг оруулна уу."),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WhereIsLocation(
                          text: textController.text,
                          type: selectedPropertyCategory!,
                        );
                      },
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff8BC83F),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Дараах",
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeXi(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPropertyCategory = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: selectedPropertyCategory == text
              ? const Color(0xff234F68)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedPropertyCategory == text
                ? const Color(0xffF5F4F8)
                : const Color(0xff252B5C),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
