import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/filter_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'restaurants_segment_section.dart';
import 'restaurants_coupon_switchs.dart';
import 'restaurants_cuisines_section.dart';

class BusinessFilterSection extends StatefulWidget {
  final List<String> categorys;

  const BusinessFilterSection({@required this.categorys});

  @override
  _BusinessFilterSectionState createState() => _BusinessFilterSectionState();
}

class _BusinessFilterSectionState extends State<BusinessFilterSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        if (state is BaseFilterState) {
          return Drawer(
              child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              children: <Widget>[
                // reset/apply buttons row
                Container(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: MediaQuery.of(context).padding.top,
                      bottom: 16),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          AppLocalizations.of(context).translate('Reset'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          BlocProvider.of<FilterBloc>(context).add(
                            ResetFilter(),
                          );
                        },
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Text(
                          AppLocalizations.of(context).translate('Apply'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          BlocProvider.of<FilterBloc>(context).add(
                            FilterConfirmEvent(),
                          );
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),

                // line container
                Container(
                  height: 0.5,
                  color: Color(0xFFACACAC),
                ),

                // sort by/distance section
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          AppLocalizations.of(context).translate('Sortby'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF242424),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      BusinessSegmentSection(
                        onValueChange: (val) {
                          BlocProvider.of<FilterBloc>(context).add(
                            ChangeSearchIndex(index: val),
                          );
                        },
                        logoWidgets: {
                          0: Text(
                            AppLocalizations.of(context).translate('Featured'),
                            style: TextStyle(fontSize: 14),
                          ),
                          1: Text(
                            AppLocalizations.of(context).translate('Distance'),
                            style: TextStyle(fontSize: 14),
                          ),
                          2: Text(
                            AppLocalizations.of(context).translate('Rating'),
                            style: TextStyle(fontSize: 14),
                          ),
                        },
                        seletedIndex: state.sortByIndex,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          AppLocalizations.of(context).translate('Distance') +
                              " (km)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF242424),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      BusinessSegmentSection(
                        logoWidgets: {
                          0: Text(
                            AppLocalizations.of(context).translate('Auto'),
                            style: TextStyle(fontSize: 14),
                          ),
                          1: Text(
                            '0.3',
                            style: TextStyle(fontSize: 14),
                          ),
                          2: Text(
                            '1',
                            style: TextStyle(fontSize: 14),
                          ),
                          3: Text(
                            '2',
                            style: TextStyle(fontSize: 14),
                          ),
                          4: Text(
                            '5',
                            style: TextStyle(fontSize: 14),
                          ),
                        },
                        onValueChange: (val) {
                          BlocProvider.of<FilterBloc>(context).add(
                            ChangeRadius(index: val),
                          );
                        },
                        seletedIndex: state.selectedDis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                // switch buttons section
                BusinessSwitchColumn(
                  initValues: state.filters,
                ),
                SizedBox(
                  height: 16,
                ),
                //cuisines section
                BusinessCuisinesSection(
                  cuisines: widget.categorys,
                  selectedIndex: state.selectedCate,
                ),
              ],
            ),
          ));
        }
      },
    );
  }
}
