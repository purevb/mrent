import 'package:flutter/material.dart';

class ConsumerReview extends StatefulWidget {
  const ConsumerReview({super.key});

  @override
  State<ConsumerReview> createState() => _ConsumerReviewState();
}

class _ConsumerReviewState extends State<ConsumerReview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            // child: CachedNetworkImage(
            //   imageUrl: "",
            //   errorWidget: (context, url, error) {
            //     return SizedBox();
            //   },
            // ),
          )
        ],
      ),
    );
  }
}
