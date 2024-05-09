// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseMediaModel _$HouseMediaModelFromJson(Map<String, dynamic> json) =>
    HouseMediaModel(
      id: (json['id'] as num).toInt(),
      houseId: (json['houseId'] as num).toInt(),
      media: json['media'] as String,
    );

Map<String, dynamic> _$HouseMediaModelToJson(HouseMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'houseId': instance.houseId,
      'media': instance.media,
    };
