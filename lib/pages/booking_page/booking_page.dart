import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/property_model.dart';
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
  DateTime? _firstSelectedDay;
  DateTime? _secondSelectedDay;
  int serviceFee = 20000;
  int getSelectedDaysDifference() {
    if (_firstSelectedDay != null && _secondSelectedDay != null) {
      return _secondSelectedDay!.difference(_firstSelectedDay!).inDays;
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
      appBar: AppBar(
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
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingPropertyComponent(
                propertyData: widget.propertyData,
              ),
              BookingPeriodChooserComponent(
                forAddProperties: false,
                onDatesSelected: (start, end) {
                  setState(() {
                    _firstSelectedDay = start;
                    _secondSelectedDay = end;
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
                canPress: true,
                onPress: () {
                  api
                      .postBookingRequest(
                    propertyId: widget.propertyData.id ?? "",
                    userId: provider.getUser?.id ?? "",
                    hostId: widget.propertyData.userId?.id ?? "",
                    additionalRequest: additionalRequestController.text,
                    checkInDate: _firstSelectedDay!,
                    checkoutDate: _secondSelectedDay!,
                    totalPrice: calculateTotalPayment(),
                  )
                      .then(
                    (res) {
                      if (res == 201) {
                        return Fluttertoast.showToast(
                          msg: "Захиалгын хүсэлт илгээгдлээ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: mRed,
                          textColor: Colors.white,
                          fontSize: 20,
                        );
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
