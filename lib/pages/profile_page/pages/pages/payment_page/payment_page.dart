import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/payments_model.dart';
import 'package:mrent/utils/constants.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.user,
    required this.paymentData,
  });

  final List<PaymentsModel> paymentData;
  final MongoUserModel user;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

enum SortOption { dateNewest, dateOldest, priceHighest, priceLowest }

class _PaymentPageState extends State<PaymentPage> {
  List<PaymentsModel> _sortedPayments = [];
  SortOption _currentSortOption = SortOption.dateNewest;
  Api api = Api();

  @override
  void initState() {
    super.initState();
    _sortedPayments = List.from(widget.paymentData);
    _sortPayments();
  }

  void _sortPayments() {
    setState(() {
      switch (_currentSortOption) {
        case SortOption.dateNewest:
          _sortedPayments.sort((a, b) {
            DateTime? dateA = _parseDateTime(a.createdAt);
            DateTime? dateB = _parseDateTime(b.createdAt);
            if (dateA == null || dateB == null) return 0;
            return dateB.compareTo(dateA);
          });
          break;
        case SortOption.dateOldest:
          _sortedPayments.sort((a, b) {
            DateTime? dateA = _parseDateTime(a.createdAt);
            DateTime? dateB = _parseDateTime(b.createdAt);
            if (dateA == null || dateB == null) return 0;
            return dateA.compareTo(dateB);
          });
          break;
        case SortOption.priceHighest:
          _sortedPayments.sort((a, b) {
            num priceA = a.bookingId?.totalPrice ?? 0;
            num priceB = b.bookingId?.totalPrice ?? 0;
            return priceB.compareTo(priceA);
          });
          break;
        case SortOption.priceLowest:
          _sortedPayments.sort((a, b) {
            num priceA = a.bookingId?.totalPrice ?? 0;
            num priceB = b.bookingId?.totalPrice ?? 0;
            return priceA.compareTo(priceB);
          });
          break;
      }
    });
  }

  DateTime? _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString.split("T")[0]);
    } catch (_) {
      return null;
    }
  }

  String _formatAmount(num? amount) => "${(amount ?? 0).toStringAsFixed(0)} ₮";

  IconData _getSortIcon() {
    switch (_currentSortOption) {
      case SortOption.dateNewest:
      case SortOption.priceHighest:
        return Icons.arrow_downward;
      case SortOption.dateOldest:
      case SortOption.priceLowest:
        return Icons.arrow_upward;
    }
  }

  String _getSortLabel() {
    switch (_currentSortOption) {
      case SortOption.dateNewest:
        return "Сүүлийн";
      case SortOption.dateOldest:
        return "Эхний";
      case SortOption.priceHighest:
        return "Үнэ ↓";
      case SortOption.priceLowest:
        return "Үнэ ↑";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title:
            const Text("Төлөлт", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Эрэмбэлэх",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ...SortOption.values.map((option) {
                        return ListTile(
                          title: Text(
                            option == SortOption.dateNewest
                                ? 'Хамгийн сүүлийн'
                                : option == SortOption.dateOldest
                                    ? 'Хамгийн эхний'
                                    : option == SortOption.priceHighest
                                        ? 'Үнэ - Их → Бага'
                                        : 'Үнэ - Бага → Их',
                          ),
                          leading: Icon(option == SortOption.dateNewest ||
                                  option == SortOption.priceHighest
                              ? Icons.arrow_downward
                              : Icons.arrow_upward),
                          selected: _currentSortOption == option,
                          selectedTileColor: Colors.blue.withOpacity(0.1),
                          selectedColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              _currentSortOption = option;
                              _sortPayments();
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: widget.paymentData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text("Төлөлтийн түүх хоосон байна",
                      style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  Text("Таны төлөлтийн түүх энд харагдах болно",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text("Төлөлтийн түүх",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800])),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getSortIcon(),
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(_getSortLabel(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _sortedPayments.length,
                    itemBuilder: (context, index) {
                      final payment = _sortedPayments[index];
                      final date = payment.createdAt?.split("T") ?? ["", ""];
                      return ClipRRect(
                        child: Slidable(
                          endActionPane: ActionPane(
                            extentRatio: 0.1,
                            motion: const BehindMotion(),
                            children: [
                              CustomSlidableAction(
                                padding: EdgeInsets.zero,
                                onPressed: (context) async {
                                  try {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Deleting payment...'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );

                                    final result = await api.deletePayment(
                                        paymentId: payment.id!);

                                    if (result == 200) {
                                      setState(() {
                                        widget.paymentData.removeWhere(
                                            (p) => p.id == payment.id);

                                        _sortedPayments.removeWhere(
                                            (p) => p.id == payment.id);
                                      });
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Payment deleted successfully'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Failed to delete payment'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Error: ${e.toString()}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
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
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                spacing: 16,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: CachedNetworkImageProvider(
                                      payment.bookingId?.propertyId?.userId
                                              ?.profileImage ??
                                          "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          payment.bookingId?.propertyId
                                                  ?.propertyName ??
                                              "Байршил",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${date[0]} ${date.length > 1 ? date[1].split(".")[0] : ""}",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatAmount(
                                            payment.bookingId?.totalPrice),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
