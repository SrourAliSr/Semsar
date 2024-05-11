import 'package:json_annotation/json_annotation.dart';

part 'house_details_model.g.dart';

@JsonSerializable()
class HouseDetailsModel {
  final int housesId;

  final String userId;

  final String category;

  final String city;

  final double rating;

  final String housesName;

  final int? phoneNumber;

  final double price;

  final String detials;

  final bool isForSale;

  final bool isForRent;

  final double rent;

  final int rooms;

  final int lavatory;

  final int area;

  final int diningRooms;

  final int sleepingRooms;

  HouseDetailsModel(
    this.isForSale,
    this.isForRent,
    this.rent,
    this.rooms,
    this.lavatory,
    this.area,
    this.diningRooms,
    this.sleepingRooms, {
    required this.housesId,
    required this.userId,
    required this.category,
    required this.city,
    required this.rating,
    required this.housesName,
    required this.phoneNumber,
    required this.price,
    required this.detials,
  });

  factory HouseDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$HouseDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$HouseDetailsModelToJson(this);
}
