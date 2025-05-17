import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/earnings_model.dart';
import 'package:mrent/model/mongo_user_model.dart';

import 'package:mrent/utils/constants.dart';

@RoutePage()
class EarningPage extends StatefulWidget {
  const EarningPage({super.key, required this.user});
  final MongoUserModel user;

  @override
  State<EarningPage> createState() => _EarningPageState();
}

class _EarningPageState extends State<EarningPage>
    with TickerProviderStateMixin {
  late SlidableController controller;

  Api api = Api();

  final DataController dataController = DataController();
  late TabController _tabController;
  String _selectedTimeframe = 'Сар';
  final List<String> _timeframes = ['7 хоног', 'Сар', 'Жил'];

  @override
  void initState() {
    super.initState();
    controller = SlidableController(this);
    _tabController = TabController(length: 2, vsync: this);
    if (widget.user.id != null) {
      dataController.getEarningDateData(widget.user.id!);
    }
  }

  void refresh() {
    if (widget.user.id != null) {
      dataController.getEarningDateData(widget.user.id!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        refresh();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text(
            "Орлогын тайлан",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: mRed,
            labelColor: mRed,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Тойм"),
              Tab(text: "Гүйлгээ"),
            ],
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataController.earningDataNotifier,
          builder: (context, earningData, child) {
            if (earningData == null) {
              return Center(
                child: CircularProgressIndicator(color: mRed),
              );
            }

            if (earningData.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Танд одоохондоо орлого бүртгэгдээгүй байна",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Таны сууцуудаас олсон орлого энд харагдах болно",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final List<EarningsModel> earnings = [];
            try {
              for (var item in earningData) {
                if (item is EarningsModel) {
                  earnings.add(item);
                }
              }
            } catch (e) {
              debugPrint("Error casting data: $e");
              return Center(
                child: Text("Өгөгдөл боловсруулахад алдаа гарлаа: $e"),
              );
            }

            final double totalEarnings = earnings.fold(
                0,
                (sum, item) =>
                    sum + (item.bookingId?.totalPrice?.toDouble() ?? 0));

            final double thisMonthEarnings =
                _calculateMonthlyEarnings(earnings);
            final double previousMonthEarnings =
                _calculatePreviousMonthEarnings(earnings);

            final double changePercentage = previousMonthEarnings > 0
                ? ((thisMonthEarnings - previousMonthEarnings) /
                        previousMonthEarnings) *
                    100
                : 0;

            return TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimeframeSelector(),
                      const SizedBox(height: 24),
                      _buildSummaryCard(totalEarnings, thisMonthEarnings,
                          changePercentage, previousMonthEarnings),
                      const SizedBox(height: 24),
                      _buildEarningChart(earnings),
                      const SizedBox(height: 24),
                      _buildEarningBreakdown(earnings),
                      const SizedBox(height: 24),
                      _buildRecentTransactions(earnings),
                    ],
                  ),
                ),
                _buildTransactionsTab(earnings),
              ],
            );
          },
        ),
      ),
    );
  }

  double _calculateMonthlyEarnings(List<EarningsModel> earnings) {
    try {
      final now = DateTime.now();
      final currentMonth = DateTime(now.year, now.month);

      return earnings.fold(0, (sum, earning) {
        if (earning.createdAt != null) {
          try {
            final earningDate = DateTime.parse(earning.createdAt!);
            if (earningDate.year == currentMonth.year &&
                earningDate.month == currentMonth.month) {
              return sum + (earning.bookingId?.totalPrice?.toDouble() ?? 0);
            }
          } catch (e) {
            debugPrint("Invalid date format: ${earning.createdAt}");
          }
        }
        return sum;
      });
    } catch (e) {
      debugPrint("Error calculating monthly earnings: $e");
      return 0;
    }
  }

  double _calculatePreviousMonthEarnings(List<EarningsModel> earnings) {
    try {
      final now = DateTime.now();
      final int year = now.month == 1 ? now.year - 1 : now.year;
      final int month = now.month == 1 ? 12 : now.month - 1;
      final previousMonth = DateTime(year, month);

      return earnings.fold(0, (sum, earning) {
        if (earning.createdAt != null) {
          try {
            final earningDate = DateTime.parse(earning.createdAt!);
            if (earningDate.year == previousMonth.year &&
                earningDate.month == previousMonth.month) {
              return sum + (earning.bookingId?.totalPrice?.toDouble() ?? 0);
            }
          } catch (e) {
            debugPrint("Invalid date format: ${earning.createdAt}");
          }
        }
        return sum;
      });
    } catch (e) {
      debugPrint("Error calculating previous month earnings: $e");
      return 0;
    }
  }

  Widget _buildTimeframeSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: _timeframes.map((timeframe) {
          final bool isSelected = _selectedTimeframe == timeframe;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeframe = timeframe;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? mRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  timeframe,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCard(double totalEarnings, double thisMonthEarnings,
      double changePercentage, double previousMonthEarnings) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'mn_MN',
      symbol: '₮',
      decimalDigits: 0,
    );

    final bool isPositiveChange = changePercentage >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [mRed, mRed.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mRed.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Нийт орлого",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositiveChange
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${changePercentage.abs().toStringAsFixed(1)}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(thisMonthEarnings),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Энэ сард",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(thisMonthEarnings),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Өмнөх сард",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(previousMonthEarnings),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningChart(List<EarningsModel> earnings) {
    final List<FlSpot> spots = _generateChartData(earnings);

    double maxY = 10000;
    if (spots.isNotEmpty) {
      maxY = spots.fold(0.0, (max, spot) => spot.y > max ? spot.y : max);
      maxY = maxY * 1.2;
      maxY = maxY < 10000 ? 10000 : maxY;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Орлогын график",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: spots.isEmpty
              ? Center(
                  child: Text(
                    "Графикт харуулах өгөгдөл алга байна",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            );

                            String text;
                            switch (value.toInt()) {
                              case 0:
                                text = 'Дав';
                                break;
                              case 1:
                                text = 'Мяг';
                                break;
                              case 2:
                                text = 'Лха';
                                break;
                              case 3:
                                text = 'Пүр';
                                break;
                              case 4:
                                text = 'Баа';
                                break;
                              case 5:
                                text = 'Бям';
                                break;
                              case 6:
                                text = 'Ням';
                                break;
                              default:
                                text = '';
                            }

                            return SideTitleWidget(
                              space: 4.0,
                              meta: meta,
                              child: Text(text, style: style),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: maxY / 5,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) {
                              return const Text('');
                            }

                            String label;
                            if (value >= 1000000) {
                              label =
                                  '${(value / 1000000).toStringAsFixed(1)}M';
                            } else if (value >= 1000) {
                              label = '${(value / 1000).toStringAsFixed(0)}K';
                            } else {
                              label = value.toStringAsFixed(0);
                            }

                            return Text(
                              label,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: mRed,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: mRed.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  List<FlSpot> _generateChartData(List<EarningsModel> earnings) {
    try {
      final now = DateTime.now();
      final Map<int, double> dayTotals = {};

      for (int i = 0; i < 7; i++) {
        dayTotals[i] = 0;
      }

      for (var earning in earnings) {
        if (earning.createdAt != null) {
          try {
            final earningDate = DateTime.parse(earning.createdAt!);
            final dayDiff = now.difference(earningDate).inDays;

            if (dayDiff >= 0 && dayDiff < 7) {
              final index = 6 - dayDiff;
              dayTotals[index] = (dayTotals[index] ?? 0) +
                  (earning.bookingId?.totalPrice?.toDouble() ?? 0);
            }
          } catch (e) {
            debugPrint("Invalid date format: ${earning.createdAt}");
          }
        }
      }

      return List.generate(
          7, (index) => FlSpot(index.toDouble(), dayTotals[index] ?? 0));
    } catch (e) {
      debugPrint("Error generating chart data: $e");
      return [];
    }
  }

  Widget _buildEarningBreakdown(List<EarningsModel> earnings) {
    try {
      final Map<String, double> propertyTotals = {};
      final Map<String, Color> propertyColors = {};
      final List<Color> colorPalette = [
        Colors.blue,
        Colors.green,
        Colors.purple,
        Colors.orange,
        Colors.teal,
        Colors.pink,
        Colors.amber,
      ];

      int colorIndex = 0;

      for (var earning in earnings) {
        final propertyName =
            earning.bookingId?.propertyId?.propertyName ?? "Unknown";
        final amount = earning.bookingId?.totalPrice?.toDouble() ?? 0;

        propertyTotals[propertyName] =
            (propertyTotals[propertyName] ?? 0) + amount;

        if (!propertyColors.containsKey(propertyName)) {
          propertyColors[propertyName] =
              colorPalette[colorIndex % colorPalette.length];
          colorIndex++;
        }
      }

      if (propertyTotals.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Байршлаар",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Байршлаар харуулах өгөгдөл алга байна",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      }

      final List<MapEntry<String, double>> sortedProperties =
          propertyTotals.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      final int topCount =
          sortedProperties.length > 4 ? 4 : sortedProperties.length;
      final List<Map<String, dynamic>> propertyBreakdown = sortedProperties
          .take(topCount)
          .map((entry) => {
                'name': entry.key,
                'amount': entry.value,
                'color': propertyColors[entry.key] ?? Colors.grey
              })
          .toList();

      final NumberFormat currencyFormat = NumberFormat.currency(
        locale: 'mn_MN',
        symbol: '₮',
        decimalDigits: 0,
      );

      final double total = propertyBreakdown.fold(
          0, (sum, item) => sum + (item['amount'] as num));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Байршлаар",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: propertyBreakdown.map((property) {
                final double percentage =
                    total > 0 ? (property['amount'] as num) / total * 100 : 0;

                final double screenWidth = MediaQuery.of(context).size.width;
                final double barWidth = (screenWidth - 72) * percentage / 100;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: property['color'] as Color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    property['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currencyFormat.format(property['amount']),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: barWidth.isFinite ? barWidth : 0,
                            height: 8,
                            decoration: BoxDecoration(
                              color: property['color'] as Color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    } catch (e) {
      debugPrint("Error building earning breakdown: $e");
      return const SizedBox.shrink();
    }
  }

  Widget _buildRecentTransactions(List<EarningsModel> earnings) {
    try {
      final sortedEarnings = List<EarningsModel>.from(earnings)
        ..sort((a, b) {
          try {
            final dateA = a.createdAt != null
                ? DateTime.parse(a.createdAt!)
                : DateTime(1900);
            final dateB = b.createdAt != null
                ? DateTime.parse(b.createdAt!)
                : DateTime(1900);
            return dateB.compareTo(dateA);
          } catch (e) {
            debugPrint("Date sorting error: $e");
            return 0;
          }
        });

      final transactions = sortedEarnings
          .take(sortedEarnings.length < 3 ? sortedEarnings.length : 3)
          .toList();

      if (transactions.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Сүүлийн гүйлгээ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Сүүлийн үеийн гүйлгээ байхгүй байна",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Сүүлийн гүйлгээ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(1);
                },
                child: Text(
                  "Бүгдийг үзэх",
                  style: TextStyle(
                    color: mRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...transactions.map((transaction) {
            try {
              final String propertyName =
                  transaction.bookingId?.propertyId?.propertyName ?? "Байршил";

              String formattedDate = "Огноо байхгүй";
              if (transaction.createdAt != null) {
                try {
                  final dateTime = DateTime.parse(transaction.createdAt!);
                  formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                } catch (e) {
                  debugPrint("Date parsing error: $e");
                }
              }

              final NumberFormat currencyFormat = NumberFormat.currency(
                locale: 'mn_MN',
                symbol: '₮',
                decimalDigits: 0,
              );

              final double amount =
                  transaction.bookingId?.totalPrice?.toDouble() ?? 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: mRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.home_outlined,
                        color: mRed,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propertyName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      currencyFormat.format(amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            } catch (e) {
              debugPrint("Error rendering transaction: $e");
              return const SizedBox.shrink();
            }
          }).toList(),
        ],
      );
    } catch (e) {
      debugPrint("Error building recent transactions: $e");
      return const SizedBox.shrink();
    }
  }

  Widget _buildTransactionsTab(List<EarningsModel> earnings) {
    try {
      final sortedEarnings = List<EarningsModel>.from(earnings)
        ..sort((a, b) {
          try {
            final dateA = a.createdAt != null
                ? DateTime.parse(a.createdAt!)
                : DateTime(1900);
            final dateB = b.createdAt != null
                ? DateTime.parse(b.createdAt!)
                : DateTime(1900);
            return dateB.compareTo(dateA);
          } catch (e) {
            debugPrint("Date sorting error: $e");
            return 0;
          }
        });

      final Map<String, List<EarningsModel>> groupedTransactions = {};

      for (var transaction in sortedEarnings) {
        try {
          if (transaction.createdAt != null) {
            final date = DateTime.parse(transaction.createdAt!);
            final monthKey = DateFormat('yyyy-MM').format(date);

            if (!groupedTransactions.containsKey(monthKey)) {
              groupedTransactions[monthKey] = [];
            }

            groupedTransactions[monthKey]!.add(transaction);
          }
        } catch (e) {
          debugPrint("Error grouping transaction: $e");
        }
      }

      final NumberFormat currencyFormat = NumberFormat.currency(
        locale: 'mn_MN',
        symbol: '₮',
        decimalDigits: 0,
      );

      if (groupedTransactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                "Бүртгэлтэй гүйлгээ байхгүй байна",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: groupedTransactions.length,
        itemBuilder: (context, index) {
          try {
            final monthKey = groupedTransactions.keys.elementAt(index);
            final transactions = groupedTransactions[monthKey]!;

            String monthDisplay;
            try {
              final date = DateTime.parse("$monthKey-01");
              monthDisplay = DateFormat('yyyy оны MM сар').format(date);
            } catch (e) {
              monthDisplay = monthKey;
              debugPrint("Error formatting month: $e");
            }

            final double monthTotal = transactions.fold(
                0,
                (sum, transaction) =>
                    sum + (transaction.bookingId?.totalPrice?.toDouble() ?? 0));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        monthDisplay,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        currencyFormat.format(monthTotal),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mRed,
                        ),
                      ),
                    ],
                  ),
                ),
                ...transactions.map((transaction) {
                  try {
                    final String propertyName =
                        transaction.bookingId?.propertyId?.propertyName ??
                            "Байршил";

                    String formattedDate = "Огноо байхгүй";
                    if (transaction.createdAt != null) {
                      try {
                        final dateTime = DateTime.parse(transaction.createdAt!);
                        formattedDate =
                            DateFormat('yyyy-MM-dd').format(dateTime);
                      } catch (e) {
                        debugPrint("Date parsing error: $e");
                      }
                    }

                    final double amount =
                        transaction.bookingId?.totalPrice?.toDouble() ?? 0;

                    return Column(
                      children: [
                        ClipRRect(
                          child: Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.15,
                              motion: const BehindMotion(),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) {
                                    log(transaction.id!);
                                    api
                                        .deleteEarning(
                                      earningId: transaction.id!,
                                    )
                                        .then((statusCode) {
                                      if (statusCode == 200) {
                                        if (mounted) {
                                          setState(() {
                                            transactions.removeAt(index);
                                          });
                                          refresh();
                                        }
                                      }
                                    });
                                  },
                                  backgroundColor: const Color(0xffFF2761),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.asset(
                                    "assets/trash.png",
                                  ),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: mRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.home_outlined,
                                      color: mRed,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          propertyName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    currencyFormat.format(amount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  } catch (e) {
                    debugPrint("Error rendering transaction: $e");
                    return const SizedBox.shrink();
                  }
                }).toList(),
              ],
            );
          } catch (e) {
            debugPrint("Error building month section: $e");
            return const SizedBox.shrink();
          }
        },
      );
    } catch (e) {
      debugPrint("Error building transactions tab: $e");
      return Center(
        child: Text("Өгөгдөл боловсруулахад алдаа гарлаа: $e"),
      );
    }
  }
}
