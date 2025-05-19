import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/pages/rent_request_page/components/rented_component.dart';
import 'package:mrent/pages/rent_request_page/update_rent_req.dart';
import 'package:mrent/utils/constants.dart';

enum SortOption {
  dateNewest,
  dateOldest,
  priceHighToLow,
  priceLowToHigh,
}

@RoutePage()
class RentReqPage extends StatefulWidget {
  final MongoUserModel user;
  const RentReqPage({required this.user, super.key});

  @override
  State<RentReqPage> createState() => _RentReqPageState();
}

class _RentReqPageState extends State<RentReqPage>
    with TickerProviderStateMixin {
  DataController dataController = DataController();
  Api api = Api();
  late TabController _tabController;

  SortOption _currentSortOption = SortOption.dateNewest;

  @override
  void initState() {
    dataController.getUsersBookingData(widget.user.id!);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<void> refresh() async {
    await dataController.getUsersBookingData(widget.user.id!);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  List<BookingModel> _sortBookings(List<BookingModel> bookings) {
    final sortedBookings = List<BookingModel>.from(bookings);

    switch (_currentSortOption) {
      case SortOption.dateNewest:
        sortedBookings
            .sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
        break;
      case SortOption.dateOldest:
        sortedBookings
            .sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));
        break;
      case SortOption.priceHighToLow:
        sortedBookings
            .sort((a, b) => (b.totalPrice ?? 0).compareTo(a.totalPrice ?? 0));
        break;
      case SortOption.priceLowToHigh:
        sortedBookings
            .sort((a, b) => (a.totalPrice ?? 0).compareTo(b.totalPrice ?? 0));
        break;
    }

    return sortedBookings;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "Эрэмбэлэх",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildSortOption(
              "Шинэ",
              SortOption.dateNewest,
            ),
            _buildSortOption(
              "Хуучин",
              SortOption.dateOldest,
            ),
            _buildSortOption(
              "Үнэ (Өндрөөс Доош)",
              SortOption.priceHighToLow,
            ),
            _buildSortOption(
              "Үнэ (Доороос Дээш)",
              SortOption.priceLowToHigh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, SortOption option) {
    return ListTile(
      title: Text(title),
      leading: Radio<SortOption>(
        value: option,
        groupValue: _currentSortOption,
        activeColor: mRed,
        onChanged: (SortOption? value) {
          if (value != null) {
            setState(() {
              _currentSortOption = value;
            });
            Navigator.pop(context);
          }
        },
      ),
      onTap: () {
        setState(() {
          _currentSortOption = option;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget bookingList(List<BookingModel> bookings, bool isApproved) {
    final filteredBookings =
        bookings.where((booking) => booking.approved == isApproved).toList();
    final sortedBookings = _sortBookings(filteredBookings);
    if (sortedBookings.isEmpty) {
      return Center(
        child: Text(
          isApproved
              ? "Батлагдсан түрээслэх хүсэлт байхгүй байна"
              : "Хүлээгдэж буй эсвэл цуцлагдсан хүсэлт байхгүй байна",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }
    return RefreshIndicator(
      color: mRed,
      onRefresh: refresh,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        shrinkWrap: true,
        itemCount: sortedBookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final booking = sortedBookings[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  //
                  if (isApproved != true) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditBookingPage(
                          booking: booking,
                        ),
                      ),
                    );
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
                            _formatDateTime(booking.createdAt),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                booking.propertyId?.propertyName ?? 'Байршил',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: const BehindMotion(),
                        children: [
                          CustomSlidableAction(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 2),
                            onPressed: (context) async {
                              await api
                                  .deleteBookingRequest(
                                      bookingId: booking.id ?? "")
                                  .then((statusCode) {
                                if (statusCode == 200) {
                                  final List<BookingModel> currentBookings =
                                      List.from(dataController
                                              .userBookingsDataNotifier.value ??
                                          []);
                                  currentBookings.remove(booking);

                                  dataController.userBookingsDataNotifier
                                      .value = currentBookings;
                                }
                              });
                            },
                            backgroundColor: const Color(0xffFF2761),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Устгах",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      child: booking.propertyId != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RentedComponent(bookingData: booking),
                            )
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

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        refresh();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text("Түрээслэх хүсэлт"),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: _showSortOptions,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: mRed,
            unselectedLabelColor: Colors.grey,
            indicatorColor: mRed,
            tabs: const [
              Tab(text: "Хүлээгдэж буй & Цуцлагдсан"),
              Tab(text: "Батлагдсан"),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        body: ValueListenableBuilder(
            valueListenable: dataController.userBookingsDataNotifier,
            builder: (context, bookingData, child) {
              if (bookingData == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: mRed,
                  ),
                );
              }

              return TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: bookingList(bookingData, false),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: bookingList(bookingData, true),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
