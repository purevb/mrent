import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class EarningPage extends StatefulWidget {
  const EarningPage({super.key, required this.user});
  final MongoUserModel user;

  @override
  State<EarningPage> createState() => _EarningPageState();
}

class _EarningPageState extends State<EarningPage> {
  final DataController dataController = DataController();

  @override
  void initState() {
    super.initState();
    dataController.getEarningDateData(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Төлбөр"),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ValueListenableBuilder(
          valueListenable: dataController.earningDataNotifier,
          builder: (context, earningData, child) {
            if (earningData == null) {
              return SizedBox(
                height: height,
                child: Center(
                  child: CircularProgressIndicator(color: mRed),
                ),
              );
            }
            if (earningData.isEmpty) {
              return SizedBox(
                height: height,
                child: const Center(
                  child: Text(
                    "Танд одоохондоо түрээслүүлсэн сууц алга",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    earningData[0].userId ?? "Хэрэглэгчийн ID байхгүй",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
