// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
      title: json['title'] as String,
      weightInPercentage: (json['weightInPercentage'] as num)?.toDouble())
    ..pointsEarned = (json['pointsEarned'] as num)?.toDouble()
    ..pointsPossible = (json['pointsPossible'] as num)?.toDouble();
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'title': instance.title,
      'weightInPercentage': instance.weightInPercentage,
      'pointsEarned': instance.pointsEarned,
      'pointsPossible': instance.pointsPossible
    };
