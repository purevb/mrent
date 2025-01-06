import 'package:flutter/material.dart';
import 'package:mrent/pages/components/touchable_scale.dart';
import 'package:mrent/pages/search_page.dart';

class CustomizedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? obscure;
  final String? text;
  final String? title;
  final String? prefixIcon;
  final String? suffixIcon;
  final Color? color;
  final bool? isDense;
  final void Function(String)? onChanged;

  const CustomizedTextField({
    this.controller,
    this.isDense,
    this.obscure,
    this.color,
    this.suffixIcon,
    this.prefixIcon,
    this.title,
    this.text,
    this.onChanged,
    super.key,
  });

  @override
  State<CustomizedTextField> createState() => _CustomizedTextFieldState();
}

class _CustomizedTextFieldState extends State<CustomizedTextField> {
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
        if (widget.title != null) ...[
          Text(
            widget.title ?? "",
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
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
            controller: widget.controller,
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
                  ? TouchableScale(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RentalSearchPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        width: 10,
                        height: 10,
                        child: Image.asset(
                          color: isFocused
                              ? const Color(0xff6246EA)
                              : const Color(0xff7D7F88),
                          widget.suffixIcon!,
                        ),
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
            onChanged: widget.onChanged,
            validator: (name) => name!.isEmpty ? "Fill this form" : null,
          ),
        ),
      ],
    );
  }
}
