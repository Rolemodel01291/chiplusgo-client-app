import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(anyMap: true)
class BusinessCategory {
  @JsonKey(name: 'Name_en')
  final String name;
  @JsonKey(name: 'Name_orig')
  final String nameEn;

  BusinessCategory({this.name, this.nameEn});

  factory BusinessCategory.fromJson(Map<String, dynamic> json) =>
      _$BusinessCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessCategoryToJson(this);
}

@JsonSerializable(anyMap: true)
class RestaurantCategory {
  @JsonKey(name: 'All_styles')
  final List<BusinessCategory> cates;

  RestaurantCategory({this.cates});

  factory RestaurantCategory.fromJson(Map<String, dynamic> json) =>
      _$RestaurantCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantCategoryToJson(this);


  List<String> getCateList(String langCode) {
    if (langCode == 'en') {
      return cates.map((cate){
        return cate.name;
      }).toList();
    } else {
      return cates.map((cate){
        return cate.nameEn;
      }).toList();
    }
  }
}
