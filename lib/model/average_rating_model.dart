class AverageRatingModel {
  final String? id;
  final String? propertyId;
  final double? averageRating;

  AverageRatingModel({
    this.id,
    this.propertyId,
    this.averageRating,
  });

  AverageRatingModel.fromJson(Map<String, dynamic> json)
      : id = json['_id']?.toString(),
        propertyId = json['propertyId']?.toString(),
        averageRating = json['averageRating']?.toDouble();

  Map<String, dynamic> toJson() => {
        '_id': id,
        'propertyId': propertyId,
        'averageRating': averageRating,
      };
}
