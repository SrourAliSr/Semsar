// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseDetailsModel _$HouseDetailsModelFromJson(Map<String, dynamic> json) =>
    HouseDetailsModel(
      housesId: (json['housesId'] as num).toInt(),
      userId: json['userId'] as String,
      category: json['category'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
      username: json['username'] as String,
      housesName: json['housesName'] as String,
      phoneNumber: (json['phoneNumber'] as num?)?.toInt(),
      price: (json['price'] as num).toDouble(),
      detials: json['detials'] as String,
    );

Map<String, dynamic> _$HouseDetailsModelToJson(HouseDetailsModel instance) =>
    <String, dynamic>{
      'housesId': instance.housesId,
      'userId': instance.userId,
      'username': instance.username,
      'category': instance.category,
      'city': instance.city,
      'rating': instance.rating,
      'housesName': instance.housesName,
      'phoneNumber': instance.phoneNumber,
      'price': instance.price,
      'detials': instance.detials,
    };
