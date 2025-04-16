import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/update_properties_field/update_properties_page.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class MyPropertiesPage extends StatefulWidget {
  const MyPropertiesPage({
    required this.userPropertyDatas,
    super.key,
  });
  final List<PropertyModel> userPropertyDatas;

  @override
  State<MyPropertiesPage> createState() => _MyPropertiesPageState();
}

class _MyPropertiesPageState extends State<MyPropertiesPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Миний түрээслүүлж буй",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: width,
        height: height,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.userPropertyDatas.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UpdatePropertiesPage(
                        propertyData: widget.userPropertyDatas[index],
                      );
                    },
                  ),
                );
              },
              child: HorizontalProperty(
                propertyData: widget.userPropertyDatas[index],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 20,
            );
          },
        ),
      ),
    );
  }
}
