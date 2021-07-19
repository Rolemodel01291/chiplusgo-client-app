import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infishare_client/blocs/business_map_bloc.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/mapscreen/map_header_buttons.dart';

class MapWidget extends StatefulWidget {
  final BusinessMapBloc businessMapBloc;

  MapWidget({this.businessMapBloc});

  @override
  State<StatefulWidget> createState() {
    return _MapWidgetState();
  }
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController _controller;
  double zoomLevel = 16;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BlocListener(
          bloc: widget.businessMapBloc,
          listener: (BuildContext context, BusinessState state) {
            if (state is BusinessLoading) {
              //TODO show loading dialog
            }
          },
          child: BlocBuilder(
            bloc: widget.businessMapBloc,
            builder: (context, state) {
              if (state is BusinessLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is BusinessLoaded) {
                //TODO handle empty business
                CameraPosition cameraPosition = CameraPosition(
                    target: LatLng(state.lati, state.longti), zoom: zoomLevel);
                return GoogleMap(
                  compassEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: cameraPosition,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    _controller.setMapStyle(
                        "[{\"featureType\":\"landscape\",\"stylers\":[{\"hue\":\"#FFBB00\"},{\"saturation\":43.400000000000006},{\"lightness\":37.599999999999994},{\"gamma\":1}]},{\"featureType\":\"road.highway\",\"stylers\":[{\"hue\":\"#FFC200\"},{\"saturation\":-61.8},{\"lightness\":45.599999999999994},{\"gamma\":1}]},{\"featureType\":\"road.arterial\",\"stylers\":[{\"hue\":\"#FF0300\"},{\"saturation\":-100},{\"lightness\":51.19999999999999},{\"gamma\":1}]},{\"featureType\":\"road.local\",\"stylers\":[{\"hue\":\"#FF0300\"},{\"saturation\":-100},{\"lightness\":52},{\"gamma\":1}]},{\"featureType\":\"water\",\"stylers\":[{\"hue\":\"#0078FF\"},{\"saturation\":-13.200000000000003},{\"lightness\":2.4000000000000057},{\"gamma\":1}]},{\"featureType\":\"poi\",\"stylers\":[{\"hue\":\"#00FF6A\"},{\"saturation\":-1.0989010989011234},{\"lightness\":11.200000000000017},{\"gamma\":1}]}]");
                  },
                  onCameraMove: (cameraPosition) {
                    zoomLevel = cameraPosition.zoom;
                  },
                  markers:
                      Set<Marker>.of(state.businesses.map((Business business) {
                    return Marker(
                        infoWindow: InfoWindow(
                            title: business.businessName['English'],
                            snippet:
                                business.address.getOneLineDisplayAddress()),
                        markerId: MarkerId(business.businessId),
                        position: LatLng(
                            business.location['lat'], business.location['lng']),
                        onTap: () {
                          print('tap business ${business.businessId}');
                        });
                  }).toList()),
                );
              }

              if (state is BusinessLoadError) {
                //TODO handle laoding error
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.error),
                      Text('Loading business error ${state.msg}'),
                      SizedBox(
                        height: 16.0,
                      ),
                      RaisedButton.icon(
                        label: Text('Retry'),
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          widget.businessMapBloc.add(FetchBusiness());
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        elevation: 5.0,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        MapHeaderButtons(
          onSearchTap: _searchButtonTapped,
          onBackMeTap: _backToMeTapped,
          onBackTap: _backButtonTapped,
        ),
      ],
    );
  }

  void _searchButtonTapped() async {
    final bounds = await _controller.getVisibleRegion();
    final centerLati =
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    final centerLongti =
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
    widget.businessMapBloc
        .add(FetchBusiness(lati: centerLati, longti: centerLongti));
  }

  void _backButtonTapped() {}

  void _backToMeTapped() {}
}
