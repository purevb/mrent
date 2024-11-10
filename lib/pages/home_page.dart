import 'package:flutter/material.dart';

import 'components/text_field.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var rentToggle = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),
      body: Container(
        padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Таны байршил",
              style: TextStyle(fontSize: 11, color: Color(0xff7D7F88)),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image.asset(
                    "assets/images/location.png",
                    width: 20,
                  ),
                ),
                const Text(
                  "Улаанбаатар , Монгол",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            searchBar(width),
            const Text(
              "Tанд юу хэрэгтэй вэ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            toggler(width),
            const Text(
              "Тантай ойр",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Container toggler(double width) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: width,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F3),
        borderRadius: BorderRadius.circular(72),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  rentToggle = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72),
                  gradient: rentToggle
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                              Color(0xff917AFD),
                              Color(0xff6246EA),
                            ])
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                          ],
                        ),
                ),
                child: Center(
                  child: Text(
                    "Түрээслэх",
                    style: TextStyle(
                      color: rentToggle ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  rentToggle = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72),
                  gradient: rentToggle == false
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                              Color(0xff917AFD),
                              Color(0xff6246EA),
                            ])
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.transparent, Colors.transparent],
                        ),
                ),
                child: Center(
                  child: Text(
                    "Түрээслэх",
                    style: TextStyle(
                      color: rentToggle == false ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container searchBar(double width) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: width,
      child: const CustomizedTextField(
        isDense: true,
        color: Color(0xffF2F2F3),
        text: "Хайлт",
        prefixIcon: "assets/images/search-normal.png",
        suffixIcon: "assets/images/setting-5.png",
      ),
    );
  }
}
