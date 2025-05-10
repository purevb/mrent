import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/core/services/api.dart';
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
  Api api = Api();
  List<BookingModel> _sortedOrders = [];

  @override
  void initState() {
    super.initState();
    _sortedOrders = List.from(widget.orderData);
    _sortOrders();
  }

  void _sortOrders() {
    setState(() {
      switch (_currentSortOption) {
        case SortOption.dateNewest:
          _sortedOrders
              .sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
          break;
        case SortOption.dateOldest:
          _sortedOrders
              .sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));
          break;
        case SortOption.nameAZ:
          _sortedOrders.sort((a, b) => (a.propertyId?.propertyName ?? '')
              .compareTo(b.propertyId?.propertyName ?? ''));
          break;
        case SortOption.nameZA:
          _sortedOrders.sort((a, b) => (b.propertyId?.propertyName ?? '')
              .compareTo(a.propertyId?.propertyName ?? ''));
          break;
      }
    });
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return '';
    try {
      final parts = dateTime.split('T');
      if (parts.length < 2) return dateTime;
      return '${parts[0]} ${parts[1].split('.').first}';
    } catch (e) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Захиалгууд"),
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
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _sortedOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final order = _sortedOrders[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailPage(
                              orderData: order,
                            ),
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            widget.orderData
                                .removeWhere((item) => item.id == order.id);
                            _sortedOrders.removeAt(index);
                          });
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, bottom: 10, right: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDateTime(order.createdAt),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  order.propertyId?.propertyName ?? 'Байршил',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.1,
                              motion: const BehindMotion(),
                              children: [
                                CustomSlidableAction(
                                  padding: EdgeInsets.zero,
                                  onPressed: (context) async {
                                    if (order.id == null) return;
                                    final responseCode =
                                        await api.deleteBookingRequest(
                                      bookingId: order.id!,
                                    );
                                    if (responseCode == 200) {
                                      setState(() {
                                        widget.orderData.removeWhere(
                                            (item) => item.id == order.id);
                                        _sortedOrders.removeAt(index);
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Устгах үед алдаа гарлаа")),
                                      );
                                    }
                                  },
                                  backgroundColor: const Color(0xffFF2761),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: SizedBox(
                                    height: 35,
                                    child: Image.asset(
                                      "assets/trash.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: order.propertyId != null
                                ? HorizontalProperty(
                                    propertyData: order.propertyId!)
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
