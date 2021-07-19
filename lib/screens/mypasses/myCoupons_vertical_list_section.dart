import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/my_passes_bloc/bloc.dart';
import 'package:infishare_client/blocs/ticket_detail/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/utils/firebase_consts.dart';
import 'package:infishare_client/screens/commen_widgets/bottom_loader.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import '../screens.dart';
import 'myPassesWidget.dart';
import 'redeemStampWidget.dart';
import 'expiredStampWidget.dart';

class UnusedCouponsVerticalListSection extends StatefulWidget {
  final String type;

  const UnusedCouponsVerticalListSection({Key key, this.type});

  @override
  _UnusedCouponsVerticalListSectionState createState() =>
      _UnusedCouponsVerticalListSectionState();
}

class _UnusedCouponsVerticalListSectionState
    extends State<UnusedCouponsVerticalListSection> {
  final ScrollController _scrollController = ScrollController();
  final _threshold = 300.0;
  MyPassesBlocBloc _couponBlocBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _couponBlocBloc = BlocProvider.of<MyPassesBlocBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPassesBlocBloc, MyPassesBlocState>(
      builder: (context, state) {
        if (state is TicketLoaded) {
          if (state.tickets.isEmpty) {
            return Center(
              child: ErrorPlaceHolder(
                AppLocalizations.of(context).translate('EmptyPasses'),
                imageName: 'assets/svg/empty_result.svg',
              ),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            itemCount:
                state.hasMore ? state.tickets.length + 1 : state.tickets.length,
            itemBuilder: (BuildContext context, int index) {
              return index >= state.tickets.length
                  // ? BottomLoader()
                  ? Container()
                  : _buildCouponListTile(state.tickets[index]);
            },
          );
        }

        if (state is TicketLoadError) {
          return Center(
            child: ErrorPlaceHolder(
              AppLocalizations.of(context).translate('Error') +
                  ' ${state.errorMsg}',
              imageName: 'assets/svg/error.svg',
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              Color(0xff242424),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCouponListTile(CouponTicket ticket) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: MyPassesWidget(
          ticket: ticket,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return BlocProvider<TicketDetailBloc>(
              create: (BuildContext context) {
                return TicketDetailBloc(
                    couponRepository: _couponBlocBloc.couponRepository)
                  ..add(
                    FetchCouponDetail(couponId: ticket.couponTicketId),
                  );
              },
              child: PrepareRedeemRoute(
                couponTicket: ticket,
              ),
            );
          },
        ));
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // final maxScroll = _scrollController.position.maxScrollExtent;
    // final currentScroll = _scrollController.position.pixels;
    // if (maxScroll - currentScroll <= _threshold) {
    //   _couponBlocBloc
    //       .add(FetchUserCouponTicket(type: widget.type, used: false));
    // }
  }
}

class UsedCouponsVerticalListSection extends StatefulWidget {
  final String type;
  const UsedCouponsVerticalListSection({Key key, this.type});

  @override
  _UsedCouponsVerticalListSectionState createState() =>
      _UsedCouponsVerticalListSectionState();
}

class _UsedCouponsVerticalListSectionState
    extends State<UsedCouponsVerticalListSection> {
  final ScrollController _scrollController = ScrollController();
  final _threshold = 300.0;
  MyPassesBlocBloc _couponBlocBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _couponBlocBloc = BlocProvider.of<MyPassesBlocBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPassesBlocBloc, MyPassesBlocState>(
      builder: (context, state) {
        if (state is TicketLoaded) {
          if (state.tickets.isEmpty) {
            return Center(
              child: ErrorPlaceHolder(
                AppLocalizations.of(context).translate('EmptyPasses'),
                imageName: 'assets/svg/empty_result.svg',
              ),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            itemCount:
                state.hasMore ? state.tickets.length + 1 : state.tickets.length,
            itemBuilder: (BuildContext context, int index) {
              return index >= state.tickets.length
                  // ? BottomLoader()
                  ? Container()
                  : _buildCouponListTile(state.tickets[index]);
            },
          );
        }

        if (state is TicketLoadError) {
          return Center(
            child: ErrorPlaceHolder(
              AppLocalizations.of(context).translate('Error') +
                  ' ${state.errorMsg}',
              imageName: 'assets/svg/error.svg',
              onTap: () {
                _couponBlocBloc
                    .add(FetchUserPassesTicket(type: widget.type, used: true));
              },
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff242424))),
        );
      },
    );
  }

  Widget _buildCouponListTile(CouponTicket ticket) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: MyPassesWidget(
                ticket: ticket,
              ),
            ),
            // ticket.couponType == FirestoreConstants.TICKET
            //     ? Container()
            //     : Positioned(
            //         right: 50,
            //         bottom: 55,
            //         child: RedeemStampWidget(
            //           time: ticket.getUsedDate(),
            //         ),
            //       ),
            Positioned(
              right: 50,
              bottom: 55,
              child: !ticket.getExpireState()
                  ? RedeemStampWidget(
                      time: ticket.getUsedDate(),
                    )
                  : ExpiredStampWidget(
                      time: ticket.getUsedDate(),
                    ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return BlocProvider<TicketDetailBloc>(
              create: (BuildContext context) {
                return TicketDetailBloc(
                    couponRepository: _couponBlocBloc.couponRepository)
                  ..add(FetchCouponDetail(couponId: ticket.couponTicketId));
              },
              child: PrepareRedeemRoute(
                couponTicket: ticket,
              ),
            );
          },
        ));
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _threshold) {
      _couponBlocBloc.add(FetchUserPassesTicket(type: widget.type, used: true));
    }
  }
}
