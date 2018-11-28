// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllTerms _$AllTermsFromJson(Map<String, dynamic> json) {
  return AllTerms()
    ..terms = (json['terms'] as List)
        ?.map((e) =>
            e == null ? null : AcademicTerm.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..subjects = (json['subjects'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$AllTermsToJson(AllTerms instance) =>
    <String, dynamic>{'terms': instance.terms, 'subjects': instance.subjects};
