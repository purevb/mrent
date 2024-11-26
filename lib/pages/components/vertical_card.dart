import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VerticalCardComponent extends StatefulWidget {
  final String? path;
  final double? height;
  final double? width;
  final String? location;
  final String? rentCount;
  final bool? hasTitle;

  const VerticalCardComponent(
      {this.hasTitle,
      this.height,
      this.width,
      this.location,
      this.rentCount,
      this.path,
      super.key});

  @override
  State<VerticalCardComponent> createState() => _VerticalCardComponentState();
}

class _VerticalCardComponentState extends State<VerticalCardComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                offset: const Offset(0, 1))
          ]),
      child: Column(
        children: [
          SizedBox(
            height: widget.height! * 0.6,
            width: widget.width,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: widget.path ?? "http://via.placeholder.com/350x150",
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.location ?? "Bali, Indonesia",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                widget.hasTitle == false
                    ? Text(
                        "${widget.rentCount ?? 29} түрээслэсэн",
                        style: const TextStyle(fontSize: 13),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
