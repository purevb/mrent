class UsersRatingsModel {
  final String? propertyId;
  final String? userId;
  final double? overallRating;

  UsersRatingsModel({
    this.propertyId,
    this.userId,
    this.overallRating,
  });

  UsersRatingsModel.fromJson(Map<String, dynamic> json)
      : propertyId = json['property_id'] as String?,
        userId = json['user_id'] as String?,
        overallRating = json['overall_rating'] as double?;

  Map<String, dynamic> toJson() => {
        'property_id': propertyId,
        'user_id': userId,
        'overall_rating': overallRating
      };
}
