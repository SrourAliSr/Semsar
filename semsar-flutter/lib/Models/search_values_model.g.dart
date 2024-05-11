// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_values_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) => SearchFilter(
      category: json['category'] as String?,
      stars: (json['stars'] as num?)?.toInt(),
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SearchFilterToJson(SearchFilter instance) =>
    <String, dynamic>{
      'category': instance.category,
      'stars': instance.stars,
      'min': instance.min,
      'max': instance.max,
    };
