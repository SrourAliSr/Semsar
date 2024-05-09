import 'package:json_annotation/json_annotation.dart';

part 'search_values_model.g.dart';

@JsonSerializable()
class SearchFilter {
  final String? category;
  final int? stars;
  final double? min;
  final double? max;

  SearchFilter(
      {required this.category,
      required this.stars,
      required this.min,
      required this.max});

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchValuesModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchValuesModelToJson(this);
}
