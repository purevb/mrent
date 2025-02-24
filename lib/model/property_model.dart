class PropertyModel {
  final String? id;
  final String? locationId;
  final String? placeTypeId;
  final String? propertyTypeId;
  final String? hostId;
  final int? nightlyPrice;
  final String? propertyName;
  final int? numGuests;
  final int? numBeds;
  final int? numBedrooms;
  final int? numBathrooms;
  final int? isGuestFavourite;
  final String? description;
  final int? addressLine1;
  final int? addressLine2;
  final List<String>? images;
  final int? rating;
  final String? placeName;

  PropertyModel({
    this.id,
    this.locationId,
    this.placeTypeId,
    this.propertyTypeId,
    this.hostId,
    this.nightlyPrice,
    this.propertyName,
    this.numGuests,
    this.numBeds,
    this.numBedrooms,
    this.numBathrooms,
    this.isGuestFavourite,
    this.description,
    this.addressLine1,
    this.addressLine2,
    this.images,
    this.rating,
    this.placeName,
  });

  PropertyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        locationId = json['location_id'] as String?,
        placeTypeId = json['place_type_id'] as String?,
        propertyTypeId = json['property_type_id'] as String?,
        hostId = json['host_id'] as String?,
        nightlyPrice = json['nightly_price'] as int?,
        propertyName = json['property_name'] as String?,
        numGuests = json['num_guests'] as int?,
        numBeds = json['num_beds'] as int?,
        numBedrooms = json['num_bedrooms'] as int?,
        numBathrooms = json['num_bathrooms'] as int?,
        isGuestFavourite = json['is_guest_favourite'] as int?,
        description = json['description'] as String?,
        addressLine1 = json['address_line_1'] as int?,
        addressLine2 = json['address_line_2'] as int?,
        images = (json['images'] as List?)?.map((e) => e as String).toList(),
        rating = json['rating'] as int?,
        placeName = json['place_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'place_type_id': placeTypeId,
        'property_type_id': propertyTypeId,
        'host_id': hostId,
        'nightly_price': nightlyPrice,
        'property_name': propertyName,
        'num_guests': numGuests,
        'num_beds': numBeds,
        'num_bedrooms': numBedrooms,
        'num_bathrooms': numBathrooms,
        'is_guest_favourite': isGuestFavourite,
        'description': description,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'images': images,
        'rating': rating,
        'place_name': placeName,
      };
}
