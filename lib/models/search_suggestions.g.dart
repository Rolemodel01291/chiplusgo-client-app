// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSuggestions _$SearchSuggestionsFromJson(Map json) {
  return SearchSuggestions(
    suggest: (json['Recommends'] as List)?.map((e) => e as String)?.toList(),
    suggestCn:
        (json['Recommends_cn'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$SearchSuggestionsToJson(SearchSuggestions instance) =>
    <String, dynamic>{
      'Recommends': instance.suggest,
      'Recommends_cn': instance.suggestCn,
    };
