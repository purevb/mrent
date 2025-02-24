import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

class ContinueWith extends StatelessWidget {
  const ContinueWith({
    super.key,
    required this.working,
    required this.onPressed,
    required this.width,
    required this.path,
    required this.text,
  });
  final bool working;
  final double width;
  final String path;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: width,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(path),
                ),
                Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          if (working == true) ...[
            Positioned(
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: mRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Working",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
          // if (working == false) ...[
          //   FractionalTranslation(
          //     translation: const Offset(3.5, -0.5),
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          //       decoration: BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: const Text(
          //         "Not working",
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ]
        ],
      ),
    );
  }
}
