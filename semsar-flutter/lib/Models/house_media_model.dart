import 'package:json_annotation/json_annotation.dart';

part 'house_media_model.g.dart';

@JsonSerializable()
class HouseMediaModel {
  final int id;

  final int houseId;

  final String media;

  HouseMediaModel({
    required this.id,
    required this.houseId,
    required this.media,
  });

  factory HouseMediaModel.fromJson(Map<String, dynamic> json) =>
      _$HouseMediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$HouseMediaModelToJson(this);
}
