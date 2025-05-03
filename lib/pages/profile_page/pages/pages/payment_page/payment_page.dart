import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
            DateTime? dateA = _parseDateTime(a.bookingId?.createdAt);
            DateTime? dateB = _parseDateTime(b.bookingId?.createdAt);
            if (dateA == null || dateB == null) return 0;
            return dateB.compareTo(dateA);
          });
          break;
        case SortOption.dateOldest:
          _sortedPayments.sort((a, b) {
            DateTime? dateA = _parseDateTime(a.bookingId?.createdAt);
            DateTime? dateB = _parseDateTime(b.bookingId?.createdAt);
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
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Төлөлт",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body:
          widget.paymentData.isEmpty ? _buildEmptyState() : _buildPaymentList(),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Эрэмбэлэх',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSortOptionTile(
                title: 'Хамгийн сүүлийн',
                icon: Icons.arrow_downward,
                option: SortOption.dateNewest,
              ),
              _buildSortOptionTile(
                title: 'Хамгийн эхний',
                icon: Icons.arrow_upward,
                option: SortOption.dateOldest,
              ),
              _buildSortOptionTile(
                title: 'Үнэ - Их → Бага',
                icon: Icons.arrow_downward,
                option: SortOption.priceHighest,
              ),
              _buildSortOptionTile(
                title: 'Үнэ - Бага → Их',
                icon: Icons.arrow_upward,
                option: SortOption.priceLowest,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOptionTile({
    required String title,
    required IconData icon,
    required SortOption option,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      selected: _currentSortOption == option,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      selectedColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _currentSortOption = option;
          _sortPayments();
        });
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Төлөлтийн түүх хоосон байна",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Таны төлөлтийн түүх энд харагдах болно",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  "Төлөлтийн түүх",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getSortIcon(),
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getSortLabel(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _sortedPayments.length,
            itemBuilder: (context, index) {
              final payment = _sortedPayments[index];
              return _buildPaymentItem(payment, context);
            },
          ),
        ],
      ),
    );
  }

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

  Widget _buildPaymentItem(PaymentsModel payment, BuildContext context) {
    final String formattedAmount =
        _formatAmount(payment.bookingId?.totalPrice ?? 0);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(
                payment.bookingId?.propertyId?.userId?.profileImage ??
                    "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.bookingId?.propertyId?.propertyName ?? "Байршил",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.bookingId?.createdAt ?? "",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedAmount,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(num? amount) {
    if (amount == null) return "0 ₮";
    return "${amount.toStringAsFixed(0)} ₮";
  }
}
