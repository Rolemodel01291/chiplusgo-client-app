import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/multichoose.dart';

class SelectableDishCell extends StatelessWidget {
  final String title;
  // if isSelected true, then change cell text's style
  final bool isSelected;
  final Widget indicator;
  final VoidCallback onTap;
  const SelectableDishCell(
      {Key key,
      @required this.onTap,
      @required this.title,
      @required this.isSelected,
      @required this.indicator});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        color: Colors.white,
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: Color(0xFF242424)),
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            indicator
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

class PickSection extends StatefulWidget {
  final MultiChoose group;
  final int groupIndex;

  PickSection({
    Key key,
    this.groupIndex,
    this.group,
  });

  @override
  _PickSectionState createState() => _PickSectionState();
}

class _PickSectionState extends State<PickSection> {
  ItemsUpdateBloc _itemsUpdateBloc;

  Widget myIndicator(int picks, int nums, VoidCallback onTap) {
    if (nums == 0) {
      return Container();
    } else {
      return (picks > 1)
          ? PickButton(nums: nums, onTap: onTap)
          : Icon(Icons.check, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    _itemsUpdateBloc = BlocProvider.of<ItemsUpdateBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context).locale.languageCode == 'en'
                  ? widget.group.name
                  : widget.group.nameCn,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.group.items.length,
            itemBuilder: (BuildContext context, int index) {
              return SelectableDishCell(
                title: AppLocalizations.of(context).locale.languageCode == 'en'
                    ? widget.group.items[index].item
                    : widget.group.items[index].itemCn,
                isSelected: widget.group.items[index].count != 0,
                indicator: myIndicator(
                    widget.group.pick, widget.group.items[index].count, () {
                  _itemsUpdateBloc.add(RemoveItemEvent(
                      groupIndex: widget.groupIndex, itemIndex: index));
                }),
                onTap: () {
                  _itemsUpdateBloc.add(AddItemEvent(
                      groupIndex: widget.groupIndex, itemIndex: index));
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(left: 16),
              child: Divider(
                height: 0,
                thickness: 0.5,
                color: Color(0xFFACACAC),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PickButton extends StatelessWidget {
  final VoidCallback onTap;
  final int nums;
  PickButton({Key key, @required this.nums, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        width: 64,
        height: 28,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(width: 1, color: Color(0xFF242424))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "$nums",
              style: TextStyle(fontSize: 14, color: Color(0xFF242424)),
            ),
            Spacer(),
            nums > 1
                ? Icon(
                    Icons.remove,
                    color: Colors.black,
                    size: 14,
                  )
                : Icon(Icons.close, color: Colors.black, size: 14),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

class BuildBottomButton extends StatelessWidget {
  final bool validate;
  final Widget centerWidget;
  ItemsUpdateBloc _bloc;
  BuildBottomButton({Key key, @required this.validate, this.centerWidget});
  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ItemsUpdateBloc>(context);
    return Container(
      padding: EdgeInsets.only(
          top: 0.5, bottom: MediaQuery.of(context).padding.bottom),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        height: 60,
        color: Colors.white,
        child: FlatButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
            color: Color(0xFFFCD300),
            disabledColor: Color(0xFFACACAC),
            textColor: Color(0xFF242424),
            disabledTextColor: Colors.white,
            child: Center(
              child: centerWidget,
            ),
            onPressed: validate
                ? () {
                    _bloc.add(
                      ChangeCouponItems(),
                    );
                  }
                : null),
      ),
    );
  }
}
