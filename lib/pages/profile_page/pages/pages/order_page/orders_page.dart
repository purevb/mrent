import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/pages/profile_page/pages/pages/order_page/order_detail_page.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class OrdersPage extends StatefulWidget {
  const OrdersPage({
    required this.orderData,
    super.key,
  });

  final List<BookingModel> orderData;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

enum SortOption { dateNewest, dateOldest, nameAZ, nameZA }

class _OrdersPageState extends State<OrdersPage> {
  SortOption _currentSortOption = SortOption.dateNewest;

  List<BookingModel> _sortedOrders = [];

  @override
  void initState() {
    super.initState();
    _sortedOrders = List.from(widget.orderData);
    _sortOrders();
  }

  void _sortOrders() {
    switch (_currentSortOption) {
      case SortOption.dateNewest:
        _sortedOrders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        break;
      case SortOption.dateOldest:
        _sortedOrders.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        break;
      case SortOption.nameAZ:
        _sortedOrders.sort((a, b) =>
            a.propertyId!.propertyName!.compareTo(b.propertyId!.propertyName!));
        break;
      case SortOption.nameZA:
        _sortedOrders.sort((a, b) =>
            b.propertyId!.propertyName!.compareTo(a.propertyId!.propertyName!));
        break;
    }
  }

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
        actions: [
          PopupMenuButton<SortOption>(
            color: Colors.white,
            icon: const Icon(Icons.sort),
            onSelected: (SortOption result) {
              setState(() {
                _currentSortOption = result;
                _sortOrders();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.dateNewest,
                child: Text('Шинэ'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.dateOldest,
                child: Text('Хуучин'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.nameAZ,
                child: Text('Нэрээр А-Я'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.nameZA,
                child: Text('Нэрээр Я-А'),
              ),
            ],
          ),
        ],
      ),
      body: widget.orderData.isEmpty
          ? const Center(
              child: Text(
                "Танд одоогоор захиалга алга",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
              width: width,
              height: height,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _sortedOrders.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailPage(
                                orderData: _sortedOrders[index],
                              ),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              int originalIndex = widget.orderData.indexWhere(
                                  (item) => item.id == _sortedOrders[index].id);
                              if (originalIndex != -1) {
                                widget.orderData.removeAt(originalIndex);
                              }
                              _sortedOrders.removeAt(index);
                            });
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _sortedOrders[index]
                                        .createdAt
                                        .toString()
                                        .split("T")[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _sortedOrders[index]
                                        .propertyId!
                                        .propertyName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HorizontalProperty(
                              propertyData: _sortedOrders[index].propertyId!,
                            ),
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
