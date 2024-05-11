// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseDetailsModel _$HouseDetailsModelFromJson(Map<String, dynamic> json) =>
    HouseDetailsModel(
      json['isForSale'] as bool,
      json['isForRent'] as bool,
      (json['rent'] as num).toDouble(),
      (json['rooms'] as num).toInt(),
      (json['lavatory'] as num).toInt(),
      (json['area'] as num).toInt(),
      (json['diningRooms'] as num).toInt(),
      (json['sleepingRooms'] as num).toInt(),
      housesId: (json['housesId'] as num).toInt(),
      userId: json['userId'] as String,
      category: json['category'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
      housesName: json['housesName'] as String,
      phoneNumber: (json['phoneNumber'] as num?)?.toInt(),
      price: (json['price'] as num).toDouble(),
      detials: json['detials'] as String,
    );

Map<String, dynamic> _$HouseDetailsModelToJson(HouseDetailsModel instance) =>
    <String, dynamic>{
      'housesId': instance.housesId,
      'userId': instance.userId,
      'category': instance.category,
      'city': instance.city,
      'rating': instance.rating,
      'housesName': instance.housesName,
      'phoneNumber': instance.phoneNumber,
      'price': instance.price,
      'detials': instance.detials,
      'isForSale': instance.isForSale,
      'isForRent': instance.isForRent,
      'rent': instance.rent,
      'rooms': instance.rooms,
      'lavatory': instance.lavatory,
      'area': instance.area,
      'diningRooms': instance.diningRooms,
      'sleepingRooms': instance.sleepingRooms,
    };
