import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrent/pages/login.dart';

import 'components/button.dart';

class Beginning extends StatelessWidget {
  const Beginning({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            SizedBox(
              height: height*0.73,
                width: width,
                child: Image.asset(
                    fit: BoxFit.fill, "assets/images/homebackground.png")),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Шинэ эхлэл, Шинэ аялал!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  const Text(
                    textAlign: TextAlign.center,
                    "Та шинэ газрын үндсийг нь сугалж, дахин эхлүүлэхэд бэлэн үү? Placoo танд аялалд тань туслах болно!",
                    style: TextStyle(fontSize: 16, color: Color(0xff7D7F88)),
                  ),
                  MyButton(
                    onPress: () => Get.to(() => const LoginPage()),
                    text: "Нэвтрэх",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
