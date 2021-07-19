import 'package:json_annotation/json_annotation.dart';

part 'search_suggestions.g.dart';

@JsonSerializable(anyMap: true)
class SearchSuggestions {
  @JsonKey(name: 'Recommends')
  final List<String> suggest;
  @JsonKey(name: 'Recommends_cn')
  final List<String> suggestCn;

  SearchSuggestions({
    this.suggest,
    this.suggestCn,
  });

  factory SearchSuggestions.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionsFromJson(json);

  Map<String, dynamic> toJson(SearchSuggestions searchSuggestions) =>
      _$SearchSuggestionsToJson(this);
}
