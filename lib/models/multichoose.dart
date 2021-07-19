import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'multichoose.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class MultiChoose extends Equatable {
  @JsonKey(name: 'Total')
  int total;
  @JsonKey(name: 'Pick')
  int pick;
  @JsonKey(name: 'Items')
  List<Item> items;
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Name_cn')
  String nameCn;

  MultiChoose(this.name, this.nameCn, this.items, this.pick, this.total);

  factory MultiChoose.fromJson(Map<String, dynamic> json) =>
      _$MultiChooseFromJson(json);

  Map<String, dynamic> toJson() => _$MultiChooseToJson(this);

  bool canPick() {
    int totCnt = 0;
    items.forEach((item) {
      if (item.count > 0) {
        totCnt = item.count + totCnt;
      }
    });

    return totCnt < pick;
  }

  bool isValid() {
    int totCnt = 0;
    items.forEach((item) {
      if (item.count > 0) {
        totCnt = item.count + totCnt;
      }
    });

    return totCnt == pick;
  }

  void addItem(int index) {
    items[index].count++;
  }

  void removeItem(int index) {
    items[index].count--;
  }

  void clearItemCoun() {
    items.forEach((item) {
      item.count = 0;
    });
  }

  @override
  List<Object> get props => [total, pick, items, name, nameCn];
}
