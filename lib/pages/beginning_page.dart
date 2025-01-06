import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'components/button.dart';

@RoutePage()
class BeginningPage extends StatelessWidget {
  const BeginningPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: SizedBox(
                  width: width,
                  child: Image.asset(
                      fit: BoxFit.fill, "assets/images/homebackground.png")),
            ),
            Flexible(
              flex: 2,
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
                    width: width,
                    height: 50,
                    onPress: () => context.router.pushNamed('/login'),
                    //  Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const LoginPage(),
                    //   ),
                    // ),
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
