import 'package:flutter/material.dart';
import 'package:mrent/pages/components/touchable_scale.dart';

class MyButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  const MyButton({required this.onPress, required this.text, super.key});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return TouchableScale(
      onPressed: widget.onPress,
      child: Container(
        width: screen.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(81),
          gradient: const LinearGradient(
            transform: GradientRotation(1),
            colors: [Color(0xff917AFD), Color(0xff6246EA)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xff6246EA),
              offset: Offset(0, 8),
              blurRadius: 6,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
