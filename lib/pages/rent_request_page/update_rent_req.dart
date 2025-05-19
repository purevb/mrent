import 'package:flutter/material.dart';
import 'package:mrent/components/mongolian_calendar.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/model/property_table_calendar.dart';
import 'package:mrent/utils/constants.dart';

class EditBookingPage extends StatefulWidget {
  final BookingModel booking;

  const EditBookingPage({
    required this.booking,
    super.key,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final DataController dataController = DataController();
  final Api api = Api();
  late TextEditingController _notesController;

  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;
  List<PropertyTableCalendar> bookedDates = [];

  @override
  void initState() {
    super.initState();

    _startDate = widget.booking.checkinDate != null
        ? DateTime.parse(widget.booking.checkinDate!)
        : null;

    _endDate = widget.booking.checkoutDate != null
        ? DateTime.parse(widget.booking.checkoutDate!)
        : null;

    _notesController = TextEditingController(
      text: widget.booking.additionalRequest ?? '',
    );

    _fetchBookedDates();
  }

  Future<void> _fetchBookedDates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.booking.propertyId?.id != null) {
        await dataController.getTableDateData(widget.booking.propertyId!.id!);
        setState(() {
          bookedDates = dataController.tableDateDataNotifier.value ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Түрээсийн мэдээлэл засах"),
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: mRed))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (widget.booking.propertyId?.images != null &&
                            widget.booking.propertyId!.images!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.booking.propertyId!.images!.first,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.home),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.booking.propertyId?.propertyName ??
                                    'Байршил',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.booking.propertyId?.placeTypeId
                                        ?.provinceName ??
                                    'Хаяг',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.booking.propertyId?.nightlyPrice ?? 0}₮ / өдөр',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: mRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Түрээсийн хугацаа",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ImprovedMongolianCalendar(
                    bookedDates: bookedDates,
                    onDatesSelected: (startDate, endDate) {
                      Future.microtask(() {
                        setState(() {
                          _startDate = startDate;
                          _endDate = endDate;
                        });
                      });
                    },
                    initialStartDate: widget.booking.checkinDate != null
                        ? DateTime.parse(widget.booking.checkinDate!)
                        : null,
                    initialEndDate: widget.booking.checkoutDate != null
                        ? DateTime.parse(widget.booking.checkoutDate!)
                        : null,
                    currentBookingId: widget.booking.id,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Нэмэлт хүсэлт",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Үйлчилгээний талаар хүсэлт бичнэ үү',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.booking.approved == true
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.booking.approved == true
                              ? Icons.check_circle
                              : Icons.pending,
                          color: widget.booking.approved == true
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.booking.approved == true
                              ? "Батлагдсан"
                              : "Хүлээгдэж буй",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: widget.booking.approved == true
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _startDate != null && _endDate != null
                          ? () async {
                              setState(() {
                                _isLoading = true;
                              });

                              await api
                                  .updateBooking(
                                bookingId: widget.booking.id ?? "",
                                checkinDate: _startDate,
                                checkoutDate: _endDate,
                                additionalRequest: _notesController.text,
                              )
                                  .then((value) {
                                setState(() {
                                  _isLoading = false;
                                });

                                if (value == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: mRed,
                                      content: const Text(
                                        'Түрээсийн мэдээлэл амжилттай шинэчлэгдлээ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: mRed,
                                      content: const Text(
                                        'Алдаа гарлаа: ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mRed,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Хадгалах",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
