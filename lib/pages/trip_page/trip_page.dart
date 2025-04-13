import 'package:flutter/material.dart';
import 'package:mrent/components/main_appbar.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
import 'package:mrent/pages/trip_page/component/object.dart';
import 'package:mrent/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class TripPage extends StatefulWidget {
  const TripPage({
    required this.propertyDatas,
    this.user,
    super.key,
    required this.getData,
  });
  final User? user;
  final List<PropertyModel> propertyDatas;
  final bool getData;
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  List<PropertyModel> filteredPropertyData = [];
  String selectedCategory = "Бүгд";

  void filterTypes(String categoryType) {
    setState(() {
      selectedCategory = categoryType;

      if (categoryType == "Бүгд") {
        filteredPropertyData = List.from(widget.propertyDatas);
      } else {
        filteredPropertyData = widget.propertyDatas
            .where(
                (property) => property.propertyTypeId!.typeName == categoryType)
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    filteredPropertyData = List.from(widget.propertyDatas);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MainAppBar(
        user: widget.user,
        hasLeading: false,
        properties: widget.propertyDatas,
        hasLocationBar: true,
        chooseType: filterTypes,
      ),
      body: Builder(
        builder: (context) {
          if (widget.getData == false) {
            return Shimmer.fromColors(
              // ignore: deprecated_member_use
              baseColor: Colors.grey.withOpacity(0.1),
              highlightColor: Colors.white,
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: height * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: Column(
                      spacing: 10,
                      children: [
                        Container(
                          width: double.infinity,
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              ),
            );
          } else {
            final displayData = selectedCategory == "Бүгд"
                ? widget.propertyDatas
                : filteredPropertyData;

            return Container(
              color: backgroundColor,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailPage(
                            user: widget.user,
                            propertyData: displayData[index],
                          ),
                        ),
                      );
                    },
                    child: TheObject(
                      user: widget.user,
                      propertyData: displayData[index],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 20);
                },
                itemCount: displayData.length,
              ),
            );
          }
        },
      ),
    );
  }
}
