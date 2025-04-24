class AverageRatingModel {
  final String? propertyId;
  final double? averageRating;

  AverageRatingModel({
    this.propertyId,
    this.averageRating,
  });

  AverageRatingModel.fromJson(Map<String, dynamic> json)
      : propertyId = json['propertyId'] as String?,
        averageRating = json['averageRating'] as double?;

  Map<String, dynamic> toJson() =>
      {'propertyId': propertyId, 'averageRating': averageRating};
}
