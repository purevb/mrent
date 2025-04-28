import 'dart:developer';

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrent/components/calendar.dart';
import 'package:mrent/components/map_component.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/components/listing_agent.dart';
import 'package:mrent/pages/property_detail_page/components/tabbar_description.dart';
import 'package:table_calendar/table_calendar.dart';

class DescriptionTab extends StatefulWidget {
  const DescriptionTab({
    super.key,
    required this.advantages,
    required this.propertyData,
  });

  final PropertyModel propertyData;
  final Map<int, Map<String, dynamic>> advantages;

  @override
  State<DescriptionTab> createState() => _DescriptionTabState();
}

class _DescriptionTabState extends State<DescriptionTab> {
  String _locale = 'en_US';
  void _showDatePicker() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SimpleDatePicker(
          rangeStart: DateTime.now(),
          rangeEnd: DateTime.now().add(const Duration(days: 7)),
          onSelectDateRange: (start, end) {
            // Handle selected date range
            print('Selected date range: $start to $end');
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('mn', null);
  }

  void _changeLocale(String locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final Map<int, Map<String, dynamic>> filledAdvantages = {
      0: {
        "label": widget.advantages[0]!["label"],
        "value": "${widget.propertyData.numGuests}",
        "icon": widget.advantages[0]!["icon"],
      },
      1: {
        "label": widget.advantages[1]!["label"],
        "value": "${widget.propertyData.numBeds}",
        "icon": widget.advantages[1]!["icon"],
      },
      2: {
        "label": widget.advantages[2]!["label"],
        "value": "${widget.propertyData.numBathrooms}",
        "icon": widget.advantages[2]!["icon"],
      },
      3: {
        "label": widget.advantages[3]!["label"],
        "value": "${widget.propertyData.numBedrooms}",
        "icon": widget.advantages[3]!["icon"],
      },
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 10),
        ListingAgent(
          user: widget.propertyData.userId!,
        ),
        const SizedBox(height: 10),
        SimpleDatePicker(
          rangeStart: DateTime.now(),
          rangeEnd: DateTime.now().add(const Duration(days: 7)),
          onSelectDateRange: (start, end) {},
        ),
        const SizedBox(height: 10),
        const Row(
          children: const [
            Icon(
              CupertinoIcons.placemark,
              size: 25,
            ),
            SizedBox(width: 5),
            Text("Газарзүйн байршил")
          ],
        ),
        Container(
          height: height * 0.3,
          margin: const EdgeInsets.all(5),
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 3,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: MapComponent(
              longitude: widget.propertyData.longitude!,
              latitude: widget.propertyData.latitude!,
            ),
          ),
        ),
      ],
    );
  }
}
