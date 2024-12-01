import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrent/pages/components/touchable_scale.dart';

class DetailOfObjectPage extends StatefulWidget {
  const DetailOfObjectPage({super.key});

  @override
  State<DetailOfObjectPage> createState() => _DetailOfObjectPageState();
}

class _DetailOfObjectPageState extends State<DetailOfObjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            // padding: const EdgeInsets.all(4), // Adjust padding to reduce size
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: TouchableScale(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),Container(
            // padding: const EdgeInsets.all(4), // Adjust padding to reduce size
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: TouchableScale(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(4), // Adjust padding to reduce size
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: TouchableScale(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow for cleaner design
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl:
                "https://scontent.xx.fbcdn.net/v/t1.15752-9/465779527_553811244179204_8313992589326752841_n.png?stp=dst-png_s526x395&_nc_cat=101&ccb=1-7&_nc_sid=0024fc&_nc_ohc=QAArbCk6_O4Q7kNvgH7fJmr&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEXZnVXYuRx8XPzwqnfnuZs-QHo-s7yqt1-1MoMclgvZQ&oe=676E27F3",
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ],
      ),
    );
  }
}
