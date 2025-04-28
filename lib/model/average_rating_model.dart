class AverageRatingModel {
  final String? propertyId;
  final int? averageRating;

  AverageRatingModel({
    this.propertyId,
    this.averageRating,
  });

  AverageRatingModel.fromJson(Map<String, dynamic> json)
      : propertyId = json['propertyId'] as String?,
        averageRating = json['averageRating'] as int?;

  Map<String, dynamic> toJson() =>
      {'propertyId': propertyId, 'averageRating': averageRating};
}
