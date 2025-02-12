import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/pages/profile_page/components/list_tiles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<int, Map<String, String>> profileListTileDatas = {
    0: {
      "iconPath": "assets/profile/Vector.svg",
      "description": "Personal information",
    },
    1: {
      "iconPath": "assets/profile/Vector-1.svg",
      "description": "Payments and payouts",
    },
    2: {
      "iconPath": "assets/profile/Vector-2.svg",
      "description": "Notificattion",
    },
    3: {
      "iconPath": "assets/profile/Icon.svg",
      "description": "Privacy and sharing",
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQsySfc8vjrF2k0NXJEeR6ytsTxmigCwb8Nw&s",
                  ),
                ),
              ),
              const Text(
                "John",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                "View profile",
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
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
                      height: 50,
                      child: SvgPicture.asset("assets/profile/Earn-Money.svg")),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: const [
                          TextSpan(text: "Earn money from your extra space"),
                          TextSpan(
                            text: "\nLearn more",
                            style: TextStyle(
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
                height: 20,
              ),
              const Text(
                "Account settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: profileListTileDatas.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProfileListTiles(
                    iconPath:
                        profileListTileDatas[index]!["iconPath"].toString(),
                    description:
                        profileListTileDatas[index]!["description"].toString(),
                    onPressed: () {},
                  );
                },
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                  child: GestureDetector(
                    // onTap: ,
                    child: const Text(
                      "Logout",
                      style: TextStyle(decoration: TextDecoration.underline),
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
}
