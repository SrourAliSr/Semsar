// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHouse _$GetHouseFromJson(Map<String, dynamic> json) => GetHouse(
      houseDetails: HouseDetailsModel.fromJson(
          json['houseDetails'] as Map<String, dynamic>),
      houseMedia:
          HouseMediaModel.fromJson(json['houseMedia'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetHouseToJson(GetHouse instance) => <String, dynamic>{
      'houseDetails': instance.houseDetails,
      'houseMedia': instance.houseMedia,
    };
