import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/add_property_pages/add_property_details.dart';
import 'package:mrent/pages/profile_page/components/list_tiles.dart';
import 'package:mrent/pages/profile_page/components/profile_image.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:mrent/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.user, super.key});
  final User user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<int, Map<String, String>> profileListTileDatas = {
    0: {
      "iconPath": "assets/profile/Vector.svg",
      "description": "Хувийн мэдээлэл",
      "path": "/personal_information"
    },
    1: {
      "iconPath": "assets/profile/Vector-1.svg",
      "description": "Төлбөр төлөлт",
      "path": "/payment"
    },
    2: {
      "iconPath": "assets/profile/Vector-2.svg",
      "description": "Notificattion",
      "path": "/noti"
    },
    3: {
      "iconPath": "assets/profile/Icon.svg",
      "description": "Нууцлал",
      "path": "/privacy",
    }
  };

  final Map<int, Map<String, String>> tiles = {
    0: {
      "number": "10",
      "description": "Түрээслүүлж буй",
    },
    1: {
      "number": "0",
      "description": "Tөлөлтүүд",
    },
    2: {
      "number": "20",
      "description": "Захиалгууд",
    },
  };

  String FirstLetterUpper(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ProfileImage(
              proImage:
                  "https://cdn-icons-png.flaticon.com/128/4140/4140047.png",
            ),
            Text(
              FirstLetterUpper(
                widget.user.name.replaceAll(" ", ""),
              ),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.user.email,
              style: const TextStyle(
                fontSize: 15,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return my_containers(
                    width,
                    tiles[index]!['number']!,
                    tiles[index]!['description']!,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 5,
                  );
                },
                itemCount: tiles.length,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),
            Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  height: 40,
                  child: Image.asset(
                    "assets/profile/money.png",
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        const TextSpan(
                            text: "Та өөрийн сууцаа түрээсэлж мөнгө олоорой."),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AddPropertyDetails(
                                        name: widget.user.name,
                                      );
                                    },
                                  ),
                                ),
                          text: "\nДэлгэрэнгүй",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Бүртгэлийн тохиргоо",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: profileListTileDatas.length,
              itemBuilder: (BuildContext context, int index) {
                return ProfileListTiles(
                  iconPath: profileListTileDatas[index]!["iconPath"].toString(),
                  description:
                      profileListTileDatas[index]!["description"].toString(),
                  onPressed: () {
                    String? path = profileListTileDatas[index]?["path"];
                    if (path != null && path.isNotEmpty) {
                      context.router.pushNamed(path);
                    } else {
                      debugPrint(
                          "Navigation path is null or empty for index: $index");
                    }
                  },
                );
              },
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                child: GestureDetector(
                  onTap: () async {
                    AuthService authService = AuthService();
                    await authService.signout(context);
                  },
                  child: const Text(
                    "Гарах",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container my_containers(double width, String number, String description) {
    return Container(
      width: width * 0.33 - 40,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          18,
        ),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 19),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
