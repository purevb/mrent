import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/pages/components/text_field.dart';
import 'package:mrent/pages/components/touchable_scale.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class RentalSearchPage extends StatefulWidget {
  const RentalSearchPage({super.key});

  @override
  State<RentalSearchPage> createState() => _RentalSearchPageState();
}

class _RentalSearchPageState extends State<RentalSearchPage> {
  List<String> types = ["s?", "Байшин", "Гэр", "Майхан"];
  int? typeSelectedIndex;
  List<String> period = ["Цаг", "Өдөр", "Сар", "Улирал"];
  int? periodSelectedIndex;

  double _lowerValue = 50;
  double _upperValue = 180;
  @override
  void initState() {
    super.initState();
  }

  bool toggleButton = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 25,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: const CustomizedTextField(
                            text: "Search",
                            prefixIcon: "assets/images/searchicon.png",
                          ),
                        ),
                      ),
                      TouchableScale(
                        onPressed: () {
                          toggleButton = !toggleButton;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          width: 48,
                          height: 48,
                          child: Image.asset(
                              fit: BoxFit.fill,
                              toggleButton == false
                                  ? "assets/search/disableshatbutton.png"
                                  : "assets/search/pisda.png"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Хэр хугацаанд түрээслэх вэ?',
                      style: GoogleFonts.roboto(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      child: OmniExample(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Түрээслэх объектийн төрөл',
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 30,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: types.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = typeSelectedIndex == index;
                      return TouchableScale(
                        onPressed: () {
                          setState(() {});
                          typeSelectedIndex = index;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(92),
                            border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xffE3E3E7)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isSelected
                                  ? [
                                      const Color(0xff917AFD),
                                      const Color(0xff6246EA),
                                    ]
                                  : [
                                      const Color.fromARGB(255, 228, 228, 230),
                                      const Color.fromARGB(255, 226, 226, 226)
                                    ],
                            ),
                          ),
                          child: Transform.translate(
                            offset: const Offset(0, -1),
                            child: Text(
                              types[index],
                              style: GoogleFonts.rubik(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Үнээ тохируулна уу',
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1E25)),
                ),

                Text(
                  "1.,200 - 3,000+ / сард",
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1E25)),
                ),

                FlutterSlider(
                  values: [_lowerValue, _upperValue],
                  rangeSlider: true,
                  max: 500,
                  min: 0,
                  handlerWidth: 20,
                  handlerHeight: 20,
                  trackBar: FlutterSliderTrackBar(
                    activeTrackBarHeight: 8,
                    activeTrackBar: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff917AFD),
                            Color(0xff6246EA),
                          ]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    inactiveTrackBar: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  handler: FlutterSliderHandler(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xff6246EA), width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(
                      width: 1,
                      height: 1,
                    ),
                  ),
                  rightHandler: FlutterSliderHandler(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xff6246EA), width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(),
                  ),
                  tooltip: FlutterSliderTooltip(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    boxStyle: FlutterSliderTooltipBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    setState(() {
                      _lowerValue = lowerValue;
                      _upperValue = upperValue;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: period.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = periodSelectedIndex == index;
                      return TouchableScale(
                        onPressed: () {
                          setState(() {});
                          periodSelectedIndex = index;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(92),
                            border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xffE3E3E7)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isSelected
                                  ? [
                                      const Color(0xff917AFD),
                                      const Color(0xff6246EA),
                                    ]
                                  : [
                                      const Color.fromARGB(255, 228, 228, 230),
                                      const Color.fromARGB(255, 226, 226, 226)
                                    ],
                            ),
                          ),
                          child: Transform.translate(
                            offset: const Offset(0, -1),
                            child: Text(
                              period[index],
                              style: GoogleFonts.rubik(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Counters
                _buildCounterSection('Өрөө болон ор', [
                  _buildCounterRow('Унтлагын өрөө'),
                  _buildCounterRow('Угаалгын өрөө'),
                  _buildCounterRow('Ор'),
                ]),
                const SizedBox(height: 16),

                _buildCounterSection('Хэдэн хүнтэй ирэх вэ?', [
                  _buildCounterRow('Насанд хүрсэн'),
                  _buildCounterRow('Хүүхэд'),
                  _buildCounterRow('Нярай хүүхэд'),
                ]),

                // Buttons
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TouchableScale(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                  fit: BoxFit.fill,
                                  "assets/search/rotate-left.png"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('Бүгдийг шинэчлэх',
                                style: GoogleFonts.roboto(
                                    color: const Color(0xff7D7F88))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TouchableScale(
                        onPressed: () {},
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(72),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          child: Center(
                            child: Text(
                              'Хайх',
                              style: GoogleFonts.roboto(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounterSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildCounterRow(String label) {
    int counter = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.roboto(fontSize: 14)),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (counter > 0) counter--;
                      });
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$counter', style: GoogleFonts.roboto(fontSize: 16)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        counter++;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class OmniExample extends StatefulWidget {
  const OmniExample({super.key});

  @override
  State<OmniExample> createState() => _OmniExampleState();
}

class _OmniExampleState extends State<OmniExample> {
  String selectedDateRange = "Өдрөө сонгох";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final List<DateTime>? dateTimeRange =
                await showOmniDateTimeRangePicker(
                    context: context,
                    startWidget: const Text("Эхлэх огноо"),
                    endWidget: const Text("Дуусах огноо"));
            if (dateTimeRange != null && dateTimeRange.length == 2) {
              final String startDate =
                  "${dateTimeRange[0].day.toString().padLeft(2, '0')}/${dateTimeRange[0].month.toString().padLeft(2, '0')}";
              final String endDate =
                  "${dateTimeRange[1].day.toString().padLeft(2, '0')}/${dateTimeRange[1].month.toString().padLeft(2, '0')}";

              setState(() {
                selectedDateRange = "$startDate - $endDate";
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(94),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    "assets/search/calendar.png",
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDateRange,
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
