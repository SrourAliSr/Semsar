import 'package:json_annotation/json_annotation.dart';

part 'add_new_house_model.g.dart';

@JsonSerializable()
class AddNewHouseModel {
  final String email;

  final double price;

  final String? details;

  final int phoneNumber;

  final String houseName;

  final String category;

  final String city;

  final List<String> media;

  AddNewHouseModel({
    required this.email,
    required this.price,
    required this.details,
    required this.phoneNumber,
    required this.houseName,
    required this.category,
    required this.city,
    required this.media,
  });

  factory AddNewHouseModel.fromJson(Map<String, dynamic> json) =>
      _$AddNewHouseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddNewHouseModelToJson(this);
}
