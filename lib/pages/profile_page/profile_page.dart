import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/profile_page/components/list_tiles.dart';
import 'package:mrent/pages/profile_page/components/profile_image.dart';
import 'package:mrent/route/route.gr.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
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
    },
    4: {
      "iconPath": "assets/profile/property-svgrepo-com.svg",
      "description": "Cууц түрээслүүлэх",
      "path": "/add_property",
    }
  };

  final Map<int, Map<String, String>> tiles = {
    0: {
      "number": "10",
      "description": "Түрээслүүлж буй",
      "path": "/my_properties",
    },
    1: {
      "number": "0",
      "description": "Tөлөлтүүд",
      "path": "/payment",
    },
    2: {
      "number": "20",
      "description": "Захиалгууд",
      "path": "/orders",
    },
  };

  String firstLetterUpper(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
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
                firstLetterUpper(
                  widget.user.name.replaceAll(" ", ""),
                ),
                style: GoogleFonts.inter(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.user.email,
                style: GoogleFonts.inter(
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
                    return myContainers(
                      tiles[index]!['path']!,
                      width,
                      tiles[index]!['number']!,
                      tiles[index]!['description']!,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 15,
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
                              text:
                                  "Та өөрийн сууцаа түрээсэлж мөнгө олоорой."),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.router.push(
                                    AddPropertyDetailsRoute(
                                      name: widget.user.name,
                                      id: widget.user.id,
                                    ),
                                  ),
                            text: "\nДэлгэрэнгүй",
                            style: GoogleFonts.inter(
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
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Бүртгэлийн тохиргоо",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: profileListTileDatas.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      String? path = profileListTileDatas[index]?["path"];
                      if (path != null && path.isNotEmpty) {
                        if (path == "/add_property") {
                          context.router.push(
                            AddPropertyDetailsRoute(
                              name: widget.user.name,
                              id: widget.user.id,
                            ),
                          );
                        } else {
                          context.router.pushNamed(path);
                        }
                      } else {
                        debugPrint(
                            "Navigation path is null or empty for index: $index");
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: ProfileListTiles(
                        iconPath:
                            profileListTileDatas[index]!["iconPath"].toString(),
                        description: profileListTileDatas[index]!["description"]
                            .toString(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20, right: 10.0, bottom: 20),
                  child: GestureDetector(
                    onTap: () async {
                      AuthService authService = AuthService();
                      await authService.signout(context);
                    },
                    child: Text(
                      "Гарах",
                      style: GoogleFonts.inter(
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector myContainers(
      String path, double width, String number, String description) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed(path);
      },
      child: Container(
        padding: const EdgeInsets.all(2),
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
              style: GoogleFonts.inter(fontSize: 19),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
