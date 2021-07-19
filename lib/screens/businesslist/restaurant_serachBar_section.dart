import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/repo.dart';
import 'package:http/http.dart' as http;
import 'package:infishare_client/screens/commen_widgets/fade_transition_route.dart';

import '../screens.dart';

class BusinessSearchBarSection extends StatelessWidget {
  final Icon icon;
  final VoidCallback onFilter;
  final VoidCallback onMap;
  const BusinessSearchBarSection({
    this.icon,
    this.onFilter,
    this.onMap,
  });
  @override
  Widget build(BuildContext context) {
    // search bar section
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // search bar
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3),
              child: GestureDetector(
                child: Hero(
                  tag: 'SearchBar',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 100,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xFFE5E5E5),
                      ),
                      // search bar icon and text
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            icon,
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              AppLocalizations.of(context).translate('SearchHint'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF797979),
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    FadeInRoute(builder: (context) {
                      return BlocProvider(
                        create: (context) => SearchBloc(
                          geolocator: Geolocator(),
                          businessRepository: BusinessRepository(
                            apiClient: InfiShareApiClient(
                              httpClient: http.Client(),
                            ),
                          ),
                        )..add(
                            FetchSearchRecommed(),
                          ),
                        child: SearchScreen(),
                      );
                    }),
                  );
                },
              ),
            ),
          ),

          SizedBox(
            width: 16,
          ),

          // filter
          Column(
            children: <Widget>[
              // icon
              GestureDetector(
                child: Icon(
                  Icons.format_list_numbered,
                  size: 24,
                  color: Color(0xFF242424),
                ),
                onTap: onFilter,
              ),

              // text
              Text(
                AppLocalizations.of(context).translate('Filter'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              )
            ],
          ),
          // SizedBox(
          //   width: 16,
          // ),
          //TODO: Add map screen function
          // map
          // Column(
          //   children: <Widget>[
          //     // icon
          //     GestureDetector(
          //       child: Icon(
          //         Icons.map,
          //         size: 24,
          //         color: Color(0xFF242424),
          //       ),
          //       onTap: onMap,
          //     ),
          //     // text
          //     Text(
          //       "Map",
          //       style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w600,
          //         color: Color(0xFF242424),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
