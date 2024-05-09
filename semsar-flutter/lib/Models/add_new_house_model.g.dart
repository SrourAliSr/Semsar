// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_new_house_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddNewHouseModel _$AddNewHouseModelFromJson(Map<String, dynamic> json) =>
    AddNewHouseModel(
      email: json['email'] as String,
      price: (json['price'] as num).toDouble(),
      details: json['details'] as String?,
      phoneNumber: (json['phoneNumber'] as num).toInt(),
      houseName: json['houseName'] as String,
      category: json['category'] as String,
      city: json['city'] as String,
      media: (json['media'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AddNewHouseModelToJson(AddNewHouseModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'price': instance.price,
      'details': instance.details,
      'phoneNumber': instance.phoneNumber,
      'houseName': instance.houseName,
      'category': instance.category,
      'city': instance.city,
      'media': instance.media,
    };
