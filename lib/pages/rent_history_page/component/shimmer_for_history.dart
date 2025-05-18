import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerForRentHistory extends StatelessWidget {
  const ShimmerForRentHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.white,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: height * 0.35,
              width: width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black,
              ),
            );
          },
          itemCount: 10,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
        ),
      ),
    );
  }
}
