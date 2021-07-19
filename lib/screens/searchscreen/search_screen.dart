import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/businessdetail/business_detail_screen.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/searchscreen/search_empty_result.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  TabController _tabController;
  SearchBloc _searchBloc;
  FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  void initState() {
    _textEditingController = TextEditingController();

    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate('Cancel'),
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  //*close search page
                  Navigator.of(context).pop();
                },
              )
            ],
            title: _buildSearchBar(),
            backgroundColor: Colors.white,
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(SearchState state) {
    if (state is ShowSearchRecommed) {
      return _buildWhatsHot(state);
    }
    if (state is ShowSearchSuggestion) {
      return _buildSuggestion(state.suggestions);
    }
    if (state is ShowSearchResult) {
      //FocusScope.of(context).unfocus();
      return _buildSearchResult(state.business, state.coupons);
    }

    if (state is LocationPermissionError) {
      return ErrorPlaceHolder(
        AppLocalizations.of(context).translate('LocationError'),
        imageName: 'assets/svg/location_denid.svg',
        onTap: () {},
      );
    }

    if (state is SearchError) {
      return ErrorPlaceHolder(
        AppLocalizations.of(context).translate('SearchError'),
        imageName: 'assets/svg/search_error.svg',
        onTap: () {
          _searchBloc.add(
            SearchKeyWord(query: _textEditingController.text),
          );
        },
      );
    }

    if (state is Searching) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[200]),
        ),
      );
    }
    return Container();
  }

  Widget _buildSearchResult(
      List<Business> businesses, List<CouponThumbnail> coupons) {
    return Column(
      children: <Widget>[
        TabBar(
          labelColor: Colors.black,
          tabs: <Widget>[
            new Tab(
              text: AppLocalizations.of(context).translate('Business') +
                  '(${businesses.length})',
            ),
            new Tab(
              text: AppLocalizations.of(context).translate('Coupon') +
                  '(${coupons.length})',
            )
          ],
          controller: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              businesses.length != 0
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return _buildBusinessListTile(businesses[index]);
                      },
                      itemCount: businesses.length,
                    )
                  : SearchEmptyResult(
                      description: AppLocalizations.of(context)
                          .translate('EmptySearchResult'),
                      imageName: 'assets/svg/empty_result.svg',
                    ),
              coupons.length != 0
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: _buildCouponListTile(coupons[index]),
                          onTap: () async {
                            await _analytics.logSelectContent(
                              contentType: 'Coupon',
                              itemId: coupons[index].couponId,
                            );
                            Navigator.of(context)
                                .pushNamed('/single_coupon', arguments: {
                              'businessId': coupons[index].businessId,
                              'couponId': coupons[index].couponId,
                            });
                          },
                        );
                      },
                      itemCount: coupons.length,
                    )
                  : SearchEmptyResult(
                      description: AppLocalizations.of(context)
                          .translate('EmptySearchResult'),
                      imageName: 'assets/svg/empty_result.svg',
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCouponListTile(CouponThumbnail couponThumbnail) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          child: BusinessThumbnailListItem(
            subtitle: AppLocalizations.of(context).locale.languageCode == "en"
                ? couponThumbnail.businessName['English']
                : couponThumbnail.businessName['Chinese'],
            thumbnail: Icon(
              Icons.local_activity,
              size: 24,
              color: Color(0xffacacac),
            ),
            title: AppLocalizations.of(context).locale.languageCode == "en"
                ? couponThumbnail.title
                : couponThumbnail.titleCn,
            distance: AppLocalizations.of(context).translate('Sold') +
                ' ${couponThumbnail.soldCnts}',
          ),
        ),
        Divider(
          indent: 16,
          endIndent: 16,
          color: Color(0xffacacac),
          height: 0.5,
        )
      ],
    );
  }

  Widget _buildBusinessListTile(Business business) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await _analytics.logSelectContent(
          contentType: 'Business',
          itemId: business.businessId,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider<BusinessDetailBloc>(
                  create: (context) => BusinessDetailBloc(
                      businessRepository: _searchBloc.businessRepository)
                    ..add(
                      FetchCouponAndNearby(businessId: business.businessId),
                    ),
                ),
                BlocProvider<WifiBloc>(
                  create: (context) => WifiBloc()
                    ..add(
                      FetchWifiStatus(ssid: business.wifiInfo.ssid),
                    ),
                )
              ],
              child: BusinessDetailScreen(),
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            child: BusinessThumbnailListItem(
              // subtitle: business.priceLabel + ' • ' + business.categories[0],
              subtitle: ' • ' + business.categories[0],
              thumbnail: Icon(
                Icons.store,
                size: 24,
                color: Color(0xffacacac),
              ),
              title: AppLocalizations.of(context).locale.languageCode == "en"
                  ? business.businessName['English']
                  : business.businessName['Chinese'],
              // distance: business.distance == null ? '' : business.distance,
              distance: '',
            ),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
            color: Color(0xffacacac),
            height: 0.5,
          )
        ],
      ),
    );
  }

  Widget _buildSuggestion(List<String> suggestion) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestion[index]),
          onTap: () {
            FocusScope.of(context).unfocus();
            _textEditingController.text = suggestion[index];
            _searchBloc.add(SearchKeyWord(query: suggestion[index]));
          },
        );
      },
      itemCount: suggestion.length,
    );
  }

  Widget _buildWhatsHot(ShowSearchRecommed state) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Whats Hot'),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 12,
            children: AppLocalizations.of(context).locale.languageCode == 'en'
                ? state.whatsNew.suggest.map((news) {
                    return ActionChip(
                      label: Text(news),
                      onPressed: () {
                        _textEditingController.text = news;
                        FocusScope.of(context).unfocus();
                        _searchBloc.add(SearchKeyWord(query: news));
                      },
                    );
                  }).toList()
                : state.whatsNew.suggestCn.map((news) {
                    return ActionChip(
                      label: Text(news),
                      onPressed: () {
                        _textEditingController.text = news;
                        FocusScope.of(context).unfocus();
                        _searchBloc.add(SearchKeyWord(query: news));
                      },
                    );
                  }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Hero(
      tag: 'SearchBar',
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          height: 32,
          padding: EdgeInsets.only(left: 16.0),
          child: TextField(
            textInputAction: TextInputAction.search,
            autofocus: true,
            onChanged: (text) {
              _searchBloc.add(
                SearchTextChanged(query: text),
              );
            },
            onSubmitted: (text) {
              if (text.isNotEmpty) {
                _searchBloc.add(
                  SearchKeyWord(query: text),
                );
              }
            },
            onTap: () {
              _searchBloc
                  .add(SearchTextChanged(query: _textEditingController.text));
            },
            controller: _textEditingController,
            cursorColor: Color(0xff797979),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).translate('SearchHint'),
              contentPadding: EdgeInsets.fromLTRB(0, 0, 4, 0),
              suffixIcon: GestureDetector(
                child: Icon(
                  Icons.cancel,
                  size: 20,
                  color: Color(0xff797979),
                ),
                onTap: _onClearTap,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: Color(0xff797979),
              ),
              hintStyle: TextStyle(
                fontSize: 17,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  void _onClearTap() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textEditingController.clear();
      _searchBloc.add(SearchTextChanged(query: ''));
    });
  }
}

class BusinessThumbnailListItem extends StatelessWidget {
  const BusinessThumbnailListItem({
    this.thumbnail,
    this.title,
    this.subtitle,
    this.distance,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: thumbnail,
          ),
          Expanded(
            flex: 8,
            child: _ThumbnailDescription(
              title: title,
              subtitle: subtitle,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              distance,
              style: TextStyle(color: Color(0xffacacac)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThumbnailDescription extends StatelessWidget {
  const _ThumbnailDescription({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
