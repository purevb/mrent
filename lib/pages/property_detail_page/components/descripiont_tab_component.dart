import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrent/components/map_component.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/components/listing_agent.dart';
import 'package:mrent/pages/property_detail_page/components/tabbar_description.dart';

class DescriptionTab extends StatelessWidget {
  const DescriptionTab({
    super.key,
    required this.advantages,
    required this.propertyData,
  });

  final PropertyModel propertyData;
  final Map<int, Map<String, dynamic>> advantages;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final Map<int, Map<String, dynamic>> filledAdvantages = {
      0: {
        "label": advantages[0]!["label"],
        "value": "${propertyData.numGuests}",
        "icon": advantages[0]!["icon"],
      },
      1: {
        "label": advantages[1]!["label"],
        "value": "${propertyData.numBeds}",
        "icon": advantages[1]!["icon"],
      },
      2: {
        "label": advantages[2]!["label"],
        "value": "${propertyData.numBathrooms}",
        "icon": advantages[2]!["icon"],
      },
      3: {
        "label": advantages[3]!["label"],
        "value": "${propertyData.numBedrooms}",
        "icon": advantages[3]!["icon"],
      },
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SizedBox(
          height: height * 0.128,
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20, left: 5),
            scrollDirection: Axis.horizontal,
            itemCount: filledAdvantages.length,
            itemBuilder: (BuildContext context, int index) {
              var advantage = filledAdvantages[index];
              return TabbarDescription(
                label: advantage!["label"] ?? "",
                value: advantage["value"] ?? "",
                icon: advantage["icon"] as IconData? ?? Icons.error,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 12,
              );
            },
          ),
        ),
        ListingAgent(
          user: propertyData.userId!,
        ),
        const Divider(),
        const Row(
          spacing: 5,
          children: [
            Icon(
              CupertinoIcons.placemark,
              size: 25,
            ),
            Text("Газарзүйн байршил")
          ],
        ),
        SizedBox(
          height: height * 0.3,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: MapComponent(
              longitude: propertyData.longitude!,
              latitude: propertyData.latitude!,
            ),
          ),
        ),
      ],
    );
  }
}
