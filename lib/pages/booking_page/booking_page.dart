import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/booking_page/component/booking_period_chooser.dart';
import 'package:mrent/pages/booking_page/component/booking_property.dart';
import 'package:mrent/pages/booking_page/component/notes_for_owner.dart';
import 'package:mrent/pages/booking_page/component/payment_types.dart';
import 'package:mrent/pages/booking_page/component/total_price.dart';
import 'package:mrent/utils/constants.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({required this.propertyData, super.key});
  final PropertyModel propertyData;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _firstSelectedDay;
  DateTime? _secondSelectedDay;
  int getSelectedDaysDifference() {
    if (_firstSelectedDay != null && _secondSelectedDay != null) {
      return _secondSelectedDay!.difference(_firstSelectedDay!).inDays;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(
            color: textDefaultColor,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
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
                onDatesSelected: (start, end) {
                  setState(() {
                    _firstSelectedDay = start;
                    _secondSelectedDay = end;
                  });
                },
              ),
              const NotesForOwnerComponent(),
              const PaymentTypesComponent(),
              TotalPriceComponent(
                totalDays: getSelectedDaysDifference(),
              ),
              MyButton(
                  canPress: true,
                  onPress: () {
                    Fluttertoast.showToast(
                        msg: "See u soon",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: mRed,
                        textColor: Colors.white,
                        fontSize: 30.0);
                  },
                  height: 60,
                  width: double.infinity,
                  text: "Түрээслэх"),
            ],
          ),
        ),
      ),
    );
  }
}
