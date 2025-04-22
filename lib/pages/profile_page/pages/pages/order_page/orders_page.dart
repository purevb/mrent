import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/profile_page/pages/pages/order_page/order_detail_page.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class OrdersPage extends StatefulWidget {
  const OrdersPage({
    required this.orderData,
    super.key,
  });
  final List<OrderModel> orderData;
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Захиалгууд",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: width,
        height: height,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.orderData.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("2025.07.09"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return OrderDetailPage(
                            orderData: widget.orderData[index],
                          );
                        },
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      HorizontalProperty(
                        propertyData: widget.orderData[index].propertyId!,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                              color: mRed,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text("5"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
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
