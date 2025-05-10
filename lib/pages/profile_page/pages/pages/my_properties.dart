import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/core/services/api.dart';
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

class _MyPropertiesPageState extends State<MyPropertiesPage>
    with TickerProviderStateMixin {
  late SlidableController controller;
  @override
  void initState() {
    super.initState();
    controller = SlidableController(this);
  }

  void _handleDeleteProperty(int index) async {
    try {
      final statusCode = await api.deleteProperties(
        properyId: widget.userPropertyDatas[index].id!,
      );

      if (statusCode == 200) {
        if (mounted) {
          setState(() {
            widget.userPropertyDatas.removeAt(index);
          });
        }
      }
    } catch (e) {
      debugPrint("Error deleting property: $e");
    }
  }

  Api api = Api();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // double responsiveExtentRatio = width > 600 ? 0.15 : 0.2;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: backgroundColor,
        title: const Text(
          "Миний түрээслүүлж буй",
        ),
      ),
      body: widget.userPropertyDatas.isEmpty
          ? const Center(
              child: Text(
                "Танд одоогоор түрээсэлж буй сууц алга",
                style: TextStyle(fontSize: 18),
              ),
            )
          : SizedBox(
              width: width,
              height: height,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.userPropertyDatas.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Slidable.of(context)?.close();
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
                    child: ClipRRect(
                      child: Slidable(
                        key: ValueKey(widget.userPropertyDatas[index].id),
                        groupTag: 'properties',
                        closeOnScroll: true,
                        endActionPane: ActionPane(
                          extentRatio: 0.2,
                          motion: const DrawerMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () => _handleDeleteProperty(index),
                            closeOnCancel: true,
                          ),
                          children: [
                            CustomSlidableAction(
                              onPressed: (context) {
                                _handleDeleteProperty(index);
                              },
                              backgroundColor: const Color(0xffFF2761),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    "assets/trash.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: HorizontalProperty(
                            propertyData: widget.userPropertyDatas[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: height * 0.015,
                  );
                },
              ),
            ),
    );
  }
}
