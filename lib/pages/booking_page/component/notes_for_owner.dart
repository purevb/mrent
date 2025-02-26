import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/utils/constants.dart';

class NotesForOwnerComponent extends StatefulWidget {
  const NotesForOwnerComponent({super.key});

  @override
  State<NotesForOwnerComponent> createState() => _NotesForOwnerComponentState();
}

class _NotesForOwnerComponentState extends State<NotesForOwnerComponent> {
  bool ontap = false;
  double height = 65;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {
        ontap = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Түрээслэгчид ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          child: AnimatedContainer(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: ontap == true ? 150 : 65,
            width: double.infinity,
            decoration: BoxDecoration(
              color: bookingColor,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
            child: Row(
              children: [
                SvgPicture.asset(width: 20, "assets/booking/Messaging.svg"),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    focusNode: focusNode,
                    maxLines: ontap ? 5 : 1,
                    minLines: 1,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: "Нэмэлт хүсэлт илгээх",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: textDefaultColor.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
