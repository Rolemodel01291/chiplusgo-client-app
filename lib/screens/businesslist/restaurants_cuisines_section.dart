import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/filter_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';

class BusinessCuisinesSection extends StatelessWidget {
  final List<String> cuisines;
  final int selectedIndex;

  const BusinessCuisinesSection(
      {@required this.cuisines, @required this.selectedIndex});

  // find out the number of true in List of bool

  bool _checkSelected(int index) {
    if (selectedIndex == -1) {
      return false;
    }
    return selectedIndex == index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                cuisines.length == 0
                    ? ''
                    : AppLocalizations.of(context).translate('Cuisines'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                // selectedNum find out the amount of selected cuisines,
                // return "all" when none selected, return the amount otherwise
                '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cuisines.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                    color: Colors.white,
                    height: 48,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            cuisines[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: _checkSelected(index)
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: Color(0xFF242424)),
                          ),
                          Spacer(),
                          Visibility(
                            visible: _checkSelected(index),
                            child: Icon(
                              Icons.check,
                              size: 24,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                    )),
                onTap: () {
                  BlocProvider.of<FilterBloc>(context).add(
                    ChangeCategory(index: index),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.zero,
              child: Container(
                height: 0.5,
                color: Color(0xFFACACAC),
              ),
            ),
          )
        ],
      ),
    );
  }
}
