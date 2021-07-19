import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/business_map_bloc.dart';
import 'package:infishare_client/blocs/filter_bloc/bloc.dart';
import 'package:infishare_client/blocs/filter_bloc/filter_bloc.dart';
import 'package:infishare_client/screens/commen_widgets/bottom_loader.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/commen_widgets/placeholder_widget.dart';
import 'package:infishare_client/screens/searchscreen/search_empty_result.dart';
import 'restaurant_serachBar_section.dart';
import 'restaurants_browse_section.dart';
import 'restaurants_filter_section.dart';

class BusinessListScreen extends StatefulWidget {
  final String title;
  final List<String> restaurantCategory;

  const BusinessListScreen({
    this.title,
    this.restaurantCategory,
  });

  @override
  _BusinessListScreenState createState() => _BusinessListScreenState();
}

class _BusinessListScreenState extends State<BusinessListScreen> {
  ScrollController _controller;
  final _scrollThreshold = 200.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  _onScroll() {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<BusinessMapBloc>(context).add(FetchMoreBusiness());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BusinessMapBloc, BusinessState>(
      listener: (context, state) {},
      child: BlocBuilder<BusinessMapBloc, BusinessState>(
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            drawerDragStartBehavior: DragStartBehavior.start,
            drawerScrimColor: Colors.black54,
            endDrawer: BlocProvider<FilterBloc>(
              create: (context) {
                return FilterBloc(
                  businessListBloc: BlocProvider.of<BusinessMapBloc>(context),
                )..add(FetchBusinessCategory());
              },
              child: BusinessFilterSection(
                categorys: widget.restaurantCategory,
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
              // backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size(0, 43),
                child: Container(
                  height: 43,
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Color(0xFFACACAC),
                        ),
                      ),
                      color: Colors.white),
                  child: BusinessSearchBarSection(
                    icon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    onFilter: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                    onMap: () {},
                  ),
                ),
              ),
              // inorder to remove leading button
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 30,
                  color: Color(0xff242424),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // inorder to remove endDrawer button
              actions: <Widget>[Container()],
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BusinessState state) {
    if (state is BusinessLoading) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          BusinessPlaceholderWidget(),
          SizedBox(
            height: 16,
          ),
          BusinessPlaceholderWidget()
        ],
      );
    }

    if (state is BusinessLoadError) {
      return ErrorPlaceHolder(state.msg, onTap: () {});
    }

    if (state is BusinessLoaded) {
      if (state.businesses.isEmpty) {
        return SearchEmptyResult(
          description: 'Can not find business around you',
          imageName: 'assets/svg/empty_result.svg',
        );
      }
      return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _controller,
        itemCount: state.hasReachMax
            ? state.businesses.length
            : state.businesses.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: index >= state.businesses.length
                ? BottomLoader()
                : GestureDetector(
                    onTap: () async {
                      await _analytics.logSelectContent(
                        contentType: 'Business',
                        itemId: state.businesses[index].businessId,
                      );
                      Navigator.of(context).pushNamed(
                        '/business',
                        arguments: state.businesses[index],
                      );
                    },
                    child: ShopVerticalListViewItem(
                      business: state.businesses[index],
                    ),
                  ),
          );
        },
      );
    }

    return Container();
  }
}
