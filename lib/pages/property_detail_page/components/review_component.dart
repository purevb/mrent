import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/users_review_model.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ReviewComponent extends StatefulWidget {
  const ReviewComponent({
    required this.propertyId,
    this.refreshTrigger,
    super.key,
  });

  final String propertyId;
  final Stream<void>? refreshTrigger;

  @override
  State<ReviewComponent> createState() => _ReviewComponentState();
}

class _ReviewComponentState extends State<ReviewComponent> {
  final DataController dataController = DataController();
  StreamSubscription? _refreshSubscription;
  Api api = Api();

  @override
  void initState() {
    super.initState();
    _loadReviews();

    if (widget.refreshTrigger != null) {
      _refreshSubscription = widget.refreshTrigger!.listen((_) {
        _loadReviews();
      });
    }
  }

  @override
  void dispose() {
    _refreshSubscription?.cancel();
    super.dispose();
  }

  void _loadReviews() {
    dataController.getReviewData(widget.propertyId);
  }

  Future<void> _deleteComment(int index) async {
    final commentData = dataController.propertyReviewNotifier.value;
    if (commentData == null || index >= commentData.length) return;

    final commentId = commentData[index].id ?? "";
    final response = await api.deleteComment(commentId);

    if (response == 200) {
      final List<UsersReviewModel> newList = List.from(commentData)
        ..removeAt(index);
      dataController.propertyReviewNotifier.value = newList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: dataController.propertyReviewNotifier,
      builder: (context, commentData, child) {
        if (commentData == null) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(),
                    const SizedBox(width: 10),
                    Container(
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 25,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 50),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ],
            ),
          );
        }

        if (commentData.isEmpty) {
          return Center(
            child: Text(
              "Энэ сууцад сэтгэгдэл алга",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          shrinkWrap: true,
          itemCount: commentData.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: commentData[index].userId?.profileImage ?? "",
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.person, color: Colors.white);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffedf2f5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                commentData[index].userId?.name ?? "",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (provider.getUser!.id ==
                                  commentData[index].userId?.id) ...[
                                const Spacer(),
                                IconButton(
                                  onPressed: () => _deleteComment(index),
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            commentData[index].comment?[0].text ?? "",
                            style: GoogleFonts.inter(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              commentData[index].comment?[0].images?.length ??
                                  0,
                              (imgIndex) {
                                return SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CachedNetworkImage(
                                    imageUrl: commentData[index]
                                            .comment?[0]
                                            .images?[imgIndex] ??
                                        "",
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.image_not_supported),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
