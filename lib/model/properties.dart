
class PropertyData {
  final String? id;
  final String? propertyTypeId;
  final String? userId;
  final String? regionId;
  final String? nightlyPrice;
  final String? propertyName;
  final int? numBeds;
  final int? squares;
  final String? description;
  final String? location;
  final String? anotherThings;
  final List<String>? images;
  final int? v;

  PropertyData({
    this.id,
    this.propertyTypeId,
    this.userId,
    this.regionId,
    this.nightlyPrice,
    this.propertyName,
    this.numBeds,
    this.squares,
    this.description,
    this.location,
    this.anotherThings,
    this.images,
    this.v,
  });

  PropertyData.fromJson(Map<String, dynamic> json)
    : id = json['_id'] as String?,
      propertyTypeId = json['property_type_id'] as String?,
      userId = json['user_id'] as String?,
      regionId = json['region_id'] as String?,
      nightlyPrice = json['nightly_price'] as String?,
      propertyName = json['property_name'] as String?,
      numBeds = json['num_beds'] as int?,
      squares = json['squares'] as int?,
      description = json['description'] as String?,
      location = json['location'] as String?,
      anotherThings = json['another_things'] as String?,
      images = (json['images'] as List?)?.map((dynamic e) => e as String).toList(),
      v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'property_type_id' : propertyTypeId,
    'user_id' : userId,
    'region_id' : regionId,
    'nightly_price' : nightlyPrice,
    'property_name' : propertyName,
    'num_beds' : numBeds,
    'squares' : squares,
    'description' : description,
    'location' : location,
    'another_things' : anotherThings,
    'images' : images,
    '__v' : v
  };
}