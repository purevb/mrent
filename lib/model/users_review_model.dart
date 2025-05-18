import 'package:mrent/model/mongo_user_model.dart';

class UsersReviewModel {
  final String? id;
  final String? propertyId;
  final MongoUserModel? userId;
  final List<UsersReviewModelComment>? comment;

  UsersReviewModel({
    this.id,
    this.propertyId,
    this.userId,
    this.comment,
  });

  UsersReviewModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        propertyId = json['property_id'] as String?,
        userId = (json['user_id'] as Map<String, dynamic>?) != null
            ? MongoUserModel.fromJson(json['user_id'] as Map<String, dynamic>)
            : null,
        comment = (json['comment'] as List?)
            ?.map((dynamic e) =>
                UsersReviewModelComment.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'property_id': propertyId,
        'user_id': userId,
        'comment': comment?.map((e) => e.toJson()).toList()
      };
}

class UsersReviewModelComment {
  final String? text;
  final List<String>? images;

  UsersReviewModelComment({
    this.text,
    this.images,
  });

  UsersReviewModelComment.fromJson(Map<String, dynamic> json)
      : text = json['text'] as String?,
        images =
            (json['images'] as List?)?.map((dynamic e) => e as String).toList();

  Map<String, dynamic> toJson() => {'text': text, 'images': images};
}
