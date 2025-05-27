import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_table_calendar.dart';
import 'package:mrent/pages/booking_page/component/booking_period_chooser.dart';
import 'package:mrent/pages/booking_page/component/booking_property.dart';
import 'package:mrent/pages/booking_page/component/notes_for_owner.dart';
import 'package:mrent/pages/booking_page/component/total_price.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({required this.propertyData, super.key});
  final PropertyModel propertyData;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController additionalRequestController =
      TextEditingController();
  Api api = Api();
  DataController dataController = DataController();
  List<PropertyTableCalendar> bookedDates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedDates();
  }

  Future<void> _fetchBookedDates() async {
    setState(() {
      isLoading = true;
    });

    try {
      await dataController.getTableDateData(widget.propertyData.id ?? "");
      setState(() {
        bookedDates = dataController.tableDateDataNotifier.value!;
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching booked dates: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime? _firstSelectedDay;
  DateTime? _secondSelectedDay;
  int serviceFee = 20000;

  int getSelectedDaysDifference() {
    if (_firstSelectedDay != null && _secondSelectedDay != null) {
      return _secondSelectedDay!.difference(_firstSelectedDay!).inDays + 1;
    } else if (_firstSelectedDay != null) {
      return 1;
    }
    return 0;
  }

  int calculateTotalPayment() {
    return widget.propertyData.nightlyPrice! * getSelectedDaysDifference() +
        serviceFee;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertyProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Icon(
              CupertinoIcons.back,
            ),
          ),
        ),
        title: Text(
          "Түрээсийн хүсэлт",
          style: GoogleFonts.inter(
            color: textDefaultColor,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: mRed,
            ))
          : Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingPropertyComponent(
                      propertyData: widget.propertyData,
                    ),
                    Text(
                      "Түрээслэх хугацаа",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    BookingPeriodChooserComponent(
                      forAddProperties: false,
                      bookedDates: bookedDates,
                      onDatesSelected: (start, end) {
                        setState(() {
                          _firstSelectedDay = start;
                          if (end == null) {
                            _secondSelectedDay = start.add(Duration(days: 1));
                          } else {
                            _secondSelectedDay = end;
                          }
                        });
                      },
                    ),
                    NotesForOwnerComponent(
                      controller: additionalRequestController,
                    ),
                    // const PaymentTypesComponent(),
                    TotalPriceComponent(
                      nightlyPrice: widget.propertyData.nightlyPrice ?? 0,
                      totalDays: getSelectedDaysDifference(),
                      perDayServiceCost: serviceFee,
                    ),
                    MyButton(
                      canPress: _firstSelectedDay != null,
                      onPress: () {
                        if (_firstSelectedDay == null) {
                          Fluttertoast.showToast(
                            msg: "Түрээслэх хугацааг сонгоно уу",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: mRed,
                            textColor: Colors.white,
                            fontSize: 20,
                          );
                          return;
                        }
                        DateTime checkoutDate = _secondSelectedDay ??
                            _firstSelectedDay!.add(const Duration(days: 1));
                        print('--- Booking Request Data ---');
                        print('Property ID: ${widget.propertyData.id ?? ""}');
                        print('User ID: ${provider.getUser?.id ?? ""}');
                        print(
                            'Host ID: ${widget.propertyData.userId?.id ?? ""}');
                        print(
                            'Additional Request: ${additionalRequestController.text}');
                        print('Check-in Date: $_firstSelectedDay');
                        print('Checkout Date: $checkoutDate');
                        print('Total Price: ${calculateTotalPayment()}');

                        api
                            .postBookingRequest(
                          propertyId: widget.propertyData.id ?? "",
                          userId: provider.getUser?.id ?? "",
                          hostId: widget.propertyData.userId?.id ?? "",
                          additionalRequest: additionalRequestController.text,
                          checkInDate: _firstSelectedDay!,
                          checkoutDate: checkoutDate,
                          totalPrice: calculateTotalPayment(),
                        )
                            .then(
                          (res) {
                            if (res == 201) {
                              Fluttertoast.showToast(
                                msg: "Захиалгын хүсэлт илгээгдлээ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: mRed,
                                textColor: Colors.white,
                                fontSize: 20,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                msg: res.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: mRed,
                                textColor: Colors.white,
                                fontSize: 20,
                              );
                            }
                          },
                        );
                      },
                      height: 60,
                      width: double.infinity,
                      text: "Захиалах",
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
