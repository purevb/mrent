import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/profile_page/components/list_tiles.dart';
import 'package:mrent/pages/profile_page/components/profile_image.dart';
import 'package:mrent/pages/profile_page/pages/pages/my_properties.dart';
import 'package:mrent/pages/profile_page/pages/pages/personal_information_page/personal_information_page.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/route/route.gr.dart';
import 'package:mrent/services/auth_service.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.user, super.key});
  final MongoUserModel user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Api api = Api();
  DataController dataController = DataController();
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
  @override
  void initState() {
    dataController.getUserPropertiesData(widget.user.id!);
    super.initState();
  }

  String firstLetterUpper(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileImage(
                mongoUser: widget.user,
                proImage: widget.user.profileImage ??
                    "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
              ),
              Text(
                firstLetterUpper(
                  provider.fbUser?.name?.replaceAll(" ", "") ?? "",
                ),
                style: GoogleFonts.inter(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                provider.fbUser?.email ?? "",
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    ValueListenableBuilder<List<PropertyModel>?>(
                      valueListenable: dataController.usePropertyDataNotifier,
                      builder: (context, userProperties, child) {
                        if (userProperties == null) {
                          return const SizedBox();
                        } else {
                          return myContainers(
                            () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyPropertiesPage(
                                  userPropertyDatas: userProperties,
                                );
                              }));
                            },
                            width,
                            userProperties.length.toString(),
                            "Түрээслүүлж буй",
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    myContainers(
                      () {},
                      width,
                      tiles[1]!['number']!,
                      tiles[1]!['description']!,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    myContainers(
                      () {},
                      width,
                      tiles[2]!['number']!,
                      tiles[2]!['description']!,
                    ),
                  ],
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
                                      name: provider.fbUser?.name ?? "",
                                      id: provider.fbUser?.id ?? "",
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
                              name: widget.user.name!,
                              id: widget.user.id!,
                            ),
                          );
                        } else if (path == "/personal_information") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PersonalInformationPage(
                              mongoUser: widget.user,
                            );
                          }));
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
                      provider.clearFavoriteProperties();
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
      VoidCallback onTap, double width, String number, String description) {
    return GestureDetector(
      onTap: onTap,
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
