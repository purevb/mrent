import 'package:flutter/material.dart';

class CustomizedTextField extends StatefulWidget {
  final bool? obscure;
  final String? text;
  final String? title;
  final String? prefixIcon;
  final String? suffixIcon;
  final Color? color;
  final bool? isDense;

  const CustomizedTextField({
    this.isDense,
    this.obscure,
    this.color,
    this.suffixIcon,
    this.prefixIcon,
    this.title,
    this.text,
    super.key,
  });

  @override
  State<CustomizedTextField> createState() => _CustomizedTextFieldState();
}

class _CustomizedTextFieldState extends State<CustomizedTextField> {
  final controller = TextEditingController();
  String result = "";
  final FocusNode focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title ?? "",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          decoration: BoxDecoration(
            color: isFocused
                ? const Color(0xfff1f1fd)
                : widget.color ?? Colors.white,
            borderRadius: BorderRadius.circular(81),
          ),
          child: TextFormField(
            focusNode: focusNode,
            obscureText: widget.obscure ?? false,
            controller: controller,
            decoration: InputDecoration(
              isDense: widget.isDense,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(81),
                borderSide: const BorderSide(
                  color: Color(0xff6246EA),
                  width: 1.0,
                ),
              ),
              prefixIcon: Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                width: 10,
                height: 10,
                child: Image.asset(
                  color: isFocused
                      ? const Color(0xff6246EA)
                      : const Color(0xff7D7F88),
                  widget.prefixIcon ?? "",
                ),
              ),
              suffixIcon: widget.suffixIcon != null
                  ? Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      width: 10,
                      height: 10,
                      child: Image.asset(
                        color: isFocused
                            ? const Color(0xff6246EA)
                            : const Color(0xff7D7F88),
                        widget.suffixIcon!,
                      ),
                    )
                  : null,
              labelText: widget.text,
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(81),
                  borderSide: BorderSide(
                      color: Colors.black.withOpacity(
                        0.1,
                      ),
                      width: 1)),
              enabledBorder: OutlineInputBorder(
                // Set enabledBorder
                borderRadius: BorderRadius.circular(81),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            textAlign: TextAlign.start,
            onChanged: (value) {
              result = value;
            },
            validator: (name) =>
                name!.isEmpty ? "Survey name is required" : null,
          ),
        ),
      ],
    );
  }
}