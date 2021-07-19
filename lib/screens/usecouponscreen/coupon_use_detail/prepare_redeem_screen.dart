import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/utils/firebase_consts.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/commen_widgets/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'redeem_details_section.dart';
import 'package:infishare_client/screens/screens.dart';
import '../../mycoupon/expiredStampWidget.dart';
import '../../mycoupon/redeemStampWidget.dart';

class PrepareRedeemRoute extends StatefulWidget {
  final CouponTicket couponTicket;

  PrepareRedeemRoute({this.couponTicket});

  @override
  _PrepareRedeemRouteState createState() => _PrepareRedeemRouteState();
}

class _PrepareRedeemRouteState extends State<PrepareRedeemRoute> {
  TicketDetailBloc _ticketDetailBloc;

  @override
  void initState() {
    super.initState();
    _ticketDetailBloc = BlocProvider.of<TicketDetailBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _aboutTitles = [
      AppLocalizations.of(context).translate('Validation'),
      AppLocalizations.of(context).translate('Validation hours'),
      AppLocalizations.of(context).translate('Description'),
    ];
    return BlocBuilder<TicketDetailBloc, TicketDetailState>(
      builder: (context, state) {
        if (state is TicketDetailLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Color(0xff242424),
                ),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xff242424),
                ),
              ),
            ),
          );
        }
        if (state is TicketDetailLoaded) {
          return Scaffold(
            body: Material(
              child: Container(
                color: Color(0xFFF1F2F4),
                child: Stack(
                  children: <Widget>[
                    //background top image
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ImageLoader(
                        url: widget.couponTicket.images.length > 0
                            ? widget.couponTicket.images[0]
                            : '',
                        width: MediaQuery.of(context).size.width,
                        height: 300.0,
                      ),
                    ),
                    // background top mask
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0, -1),
                            end: Alignment(0, 1),
                            colors: [
                              Colors.white.withOpacity(0),
                              Color(0xF1F2F4).withOpacity(1)
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 0, bottom: 0),
                        child: ListView(
                          children: [
                            SizedBox(
                              height:
                                  32 + MediaQuery.of(context).padding.top + 32,
                            ),
                            Stack(
                              children: <Widget>[
                                RedeemDetailsSection(
                                  couponTicket: widget.couponTicket,
                                  title: AppLocalizations.of(context)
                                              .locale
                                              .languageCode ==
                                          'en'
                                      ? widget.couponTicket.name
                                      : widget.couponTicket.nameCn,
                                  businessName: AppLocalizations.of(context)
                                              .locale
                                              .languageCode ==
                                          'en'
                                      ? widget.couponTicket.businessName[0]
                                          ['English']
                                      : widget.couponTicket.businessName[0]
                                          ['Chinese'],
                                  aboutTitles: _aboutTitles,
                                  address:
                                      state.business.getTwoLineDisplayAddress(),
                                  tapMap: () {
                                    _openMap(state.business);
                                  },
                                  tapPhone: () {
                                    _openPhone(state.business);
                                  },
                                  tapBuyAgain: () {
                                    Navigator.of(context)
                                        .pushNamed('/business/id', arguments: {
                                      'businessId': state.business.businessId,
                                      'name': state.business.businessName,
                                    });
                                  },
                                ),
                                Positioned(
                                  right: 50,
                                  top: 150,
                                  child: GestureDetector(
                                      child: Container(
                                          child: widget.couponTicket.isUsed()
                                              ? RedeemStampWidget(
                                                  time: widget.couponTicket
                                                      .getUsedDate(),
                                                )
                                              : widget.couponTicket.isNew()
                                                  ? Container()
                                                  : ExpiredStampWidget(
                                                      time: widget.couponTicket
                                                          .getUsedDate(),
                                                    ))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 32 + MediaQuery.of(context).padding.top,
                      left: 16,
                      child: GestureDetector(
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: Colors.black26,
                              )
                            ],
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // bottomNavigationBar: (state.ticket.used ||
            //         state.ticket.couponType == FirestoreConstants.TICKET)
            //     ? null
            //     : BottomAppBar(
            bottomNavigationBar: state.ticket.used || state.ticket.getExpire()
                ? null
                : BottomAppBar(
                    child: Container(
                      color: Colors.white,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            side: BorderSide(
                              color: Color(0xff1463a0),
                            ),
                          ),
                          elevation: 0.0,
                          highlightElevation: 0.0,
                          highlightColor: Colors.white,
                          fillColor: Color(0xff1463a0),
                          child: Text(
                            // state.ticket.picked != null && state.ticket.picked
                            //     ? AppLocalizations.of(context)
                            //         .translate('Rebuild combo')
                            //         .toUpperCase()
                            //     : AppLocalizations.of(context)
                            //         .translate('Build My Combo')
                            //         .toUpperCase(),
                            // AppLocalizations.of(context)
                            //     .translate('Build My Combo')
                            //     .toUpperCase(),
                            AppLocalizations.of(context)
                                .translate("Redeem Now"),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // Navigator.of(context).push(

                            // MaterialPageRoute(builder: (context) {
                            //   return MultiBlocProvider(
                            //     providers: [
                            //       BlocProvider<ItemsUpdateBloc>(
                            //         create: (context) => ItemsUpdateBloc(
                            //             couponTicket: widget.couponTicket,
                            //             couponRepository:
                            //                 _ticketDetailBloc.couponRepository),
                            //       ),
                            //       BlocProvider<TicketDetailBloc>.value(
                            //         value: _ticketDetailBloc,
                            //       )
                            //     ],
                            //     // child: BuildMyComboRoute(
                            //     //   ticket: widget.couponTicket,
                            //     // ),
                            //   );
                            // }),
                            // );
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return MultiBlocProvider(
                                    providers: [
                                      BlocProvider<QrCodeBlocBloc>(
                                        create: (context) => QrCodeBlocBloc(
                                          couponRepository: _ticketDetailBloc
                                              .couponRepository,
                                          couponTicket: widget.couponTicket,
                                        )..add(
                                            WaitRedeemEvent(),
                                          ),
                                      ),
                                      BlocProvider<TicketDetailBloc>.value(
                                        value: _ticketDetailBloc,
                                      )
                                    ],
                                    child: RedeemMainRoute(),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          );
        }

        if (state is TicketDetailLoadError) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Color(0xff242424),
                ),
              ),
            ),
            body: Center(
              child: ErrorPlaceHolder(
                AppLocalizations.of(context).translate('Error') +
                    ' ${state.errorMsg}',
                imageName: 'assets/svg/error.svg',
                onTap: () {
                  _ticketDetailBloc.add(
                    // FetchCouponDetail(couponId: widget.couponTicket.ticketNum),
                    FetchCouponDetail(
                        couponId: widget.couponTicket.couponTicketId),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  void _openMap(Business business) async {
    var lat = business.location['lat'];
    var lng = business.location['lng'];
    String url = 'geo:$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      url =
          'http://maps.apple.com/?daddr=${business.getMapQueryString()}&dirflg=d&t=m';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _openPhone(Business business) async {
    // Android
    String uri = 'tel:${business.phone}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      uri = 'tel:${business.phone}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
