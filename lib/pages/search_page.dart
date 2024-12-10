import 'package:flutter/material.dart';
import 'package:mrent/pages/components/text_field.dart';

class RentalSearchPage extends StatefulWidget {
  const RentalSearchPage({super.key});

  @override
  State<RentalSearchPage> createState() => _RentalSearchPageState();
}

class _RentalSearchPageState extends State<RentalSearchPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  height: height * 0.2,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        height: height*0.1,
                        width: width*0.5,
                        child: const CustomizedTextField(
                          text: "Ulaanbaatar Mongolia",
                          prefixIcon: "assets/images/searchicon.png",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Хэр хугацаанд түрээслэх вэ?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('11/12 - 30/12', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),

                const Text(
                  'Түрээслэх объектийг төрөл',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ToggleButtons(
                  isSelected: const [true, false, false],
                  onPressed: (int index) {},
                  fillColor: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Байшин'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Гэр'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Майхан'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Price Range Slider
                const Text(
                  'Үнийг тохируулаач уу',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: 50,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '\$1,200 - \$3,000',
                  onChanged: (value) {},
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Бүгдийг шинэчлэх',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Хайх'),
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

  // Helper for Counter Section
  Widget _buildCounterSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  // Helper for Counter Rows
  Widget _buildCounterRow(String label) {
    int counter = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
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
                  Text('$counter', style: const TextStyle(fontSize: 16)),
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
