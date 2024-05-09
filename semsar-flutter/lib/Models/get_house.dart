import 'package:json_annotation/json_annotation.dart';
import 'package:semsar/Models/house_details_model.dart';
import 'package:semsar/Models/house_media_model.dart';

part 'get_house.g.dart';

@JsonSerializable()
class GetHouse {
  final HouseDetailsModel houseDetails;

  final HouseMediaModel houseMedia;

  GetHouse({
    required this.houseDetails,
    required this.houseMedia,
  });

  factory GetHouse.fromJson(Map<String, dynamic> json) =>
      _$GetHouseFromJson(json);

  Map<String, dynamic> toJson() => _$GetHouseToJson(this);
}
