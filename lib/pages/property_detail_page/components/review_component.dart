import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/users_review_model.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
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

  Future<void> _editComment(int index) async {
    final commentData = dataController.propertyReviewNotifier.value;
    if (commentData == null || index >= commentData.length) return;

    final review = commentData[index];
    final commentId = review.id ?? "";

    final editedComment = await showDialog<String>(
      context: context,
      builder: (context) => EditCommentDialog(
        initialText: review.comment?[0].text ?? "",
        initialImages: review.comment?[0].images ?? [],
      ),
    );

    if (editedComment != null) {
      final response = await api.updateReviewComment(
        id: commentId,
        comment: editedComment,
        images: review.comment?[0].images,
      );

      if (response == 200) {
        _loadReviews();
      }
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
            int reversedIndex = commentData.length - index - 1;
            final comment = commentData[reversedIndex];
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
                        imageUrl: comment.userId?.profileImage ?? "",
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
                                comment.userId?.name ?? "",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (provider.getUser!.id ==
                                  comment.userId?.id) ...[
                                const Spacer(),
                                IconButton(
                                  onPressed: () => _editComment(reversedIndex),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _deleteComment(reversedIndex),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            comment.comment?[0].text ?? "",
                            style: GoogleFonts.inter(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              comment.comment?[0].images?.length ?? 0,
                              (imgIndex) {
                                return SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        comment.comment?[0].images?[imgIndex] ??
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

class EditCommentDialog extends StatefulWidget {
  final String initialText;
  final List<String> initialImages;

  const EditCommentDialog({
    required this.initialText,
    required this.initialImages,
    super.key,
  });

  @override
  State<EditCommentDialog> createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<EditCommentDialog> {
  late TextEditingController _controller;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    images = List.from(widget.initialImages);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: const Text('Сэтгэгдэл өөрчлөх'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                focusColor: mRed,
                fillColor: mRed,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mRed, width: 2),
                ),
                border: const OutlineInputBorder(),
                labelText: 'Сэтгэгдэл',
              ),
            ),
            const SizedBox(height: 16),
            if (images.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                children: images.map((image) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 5,
                        top: 5,
                        child: GestureDetector(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: mRed,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              images.remove(image);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Гарах',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text(
            'Хадгалах',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
