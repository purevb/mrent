import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VerticalCardComponent extends StatefulWidget {
  final String? path;
  final String? location;
  final String? rentCount;

  const VerticalCardComponent(
      {this.location, this.rentCount, this.path, super.key});

  @override
  State<VerticalCardComponent> createState() => _VerticalCardComponentState();
}

class _VerticalCardComponentState extends State<VerticalCardComponent> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width * 0.45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: screen.height * 0.18,
            width: screen.width,
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
                Text(
                  "${widget.rentCount ?? 29} түрээслэсэн",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
