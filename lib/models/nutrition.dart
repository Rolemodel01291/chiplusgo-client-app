import 'package:json_annotation/json_annotation.dart';
part 'nutrition.g.dart';

@JsonSerializable(anyMap: true)
class Nutrition{
  @JsonKey(name: 'Calories_from_fat')
  final String caloriesFromFat;
  @JsonKey(name: 'etc')
  final String etc;
  @JsonKey(name: 'Calories')
  final String calories;

  Nutrition(
    this.caloriesFromFat,
    this.etc,
    this.calories,    
  );

factory Nutrition.fromJson(Map<String, dynamic> json) => _$NutritionFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionToJson(this);

    // Nutrition.fromJson(Map<String, dynamic> json)
    //   : caloriesFromFat = json['Calories_from_fat'] ,     
    //     etc = json['etc'],
    //     calories = json['Calories'];
    //   Map<String, dynamic> toJson() =>
    //   {
    //     'Calories_from_fat': caloriesFromFat,
    //     'etc': etc,
        
    //   };

}