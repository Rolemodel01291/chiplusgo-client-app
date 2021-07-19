import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'selectable_cell_widgets.dart';
import '../screens.dart';

class BuildMyComboRoute extends StatefulWidget {
  final CouponTicket ticket;

  BuildMyComboRoute({this.ticket});

  @override
  BuildMyComboRouteState createState() => BuildMyComboRouteState();
}

class BuildMyComboRouteState extends State<BuildMyComboRoute> {
  TicketDetailBloc _ticketDetailBloc;

  @override
  void initState() {
    super.initState();
    _ticketDetailBloc = BlocProvider.of<TicketDetailBloc>(context);
  }

  void _showErrorSnackBar(String error, BuildContext context) {
    Flushbar(
      message: error,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      icon: Icon(Icons.error, color: Colors.white),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeInOut,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ItemsUpdateBloc, ItemsUpdateState>(
        listener: (context, state) {
          if (state is ItemsUpdateError) {
            //* show snack bar
            _showErrorSnackBar(state.errorMsg, context);
          } else if (state is ItemsUpdateSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<QrCodeBlocBloc>(
                        create: (context) => QrCodeBlocBloc(
                          couponRepository: _ticketDetailBloc.couponRepository,
                          couponTicket: widget.ticket,
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
          }
        },
        child: BlocBuilder<ItemsUpdateBloc, ItemsUpdateState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  iconSize: 30,
                  color: Color(0xff242424),
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    _ticketDetailBloc.add(
                      FetchCouponDetail(couponId: widget.ticket.couponTicketId),
                    );
                    Navigator.of(context).pop();
                  },
                ),
                elevation: 1.0,
                title: Text(
                  AppLocalizations.of(context).translate("Build My Combo"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              body: Container(
                color: Color(0xFFF1F2F4),
                // child: ListView.builder(
                //   itemBuilder: (context, index) {
                //     return PickSection(
                //       group: (state as ItemsData).ticket.groups[index],
                //       groupIndex: index,
                //     );
                //   },
                //   itemCount: (state as ItemsData).ticket.detail.groups.length,
                // ),
              ),
              bottomNavigationBar: BuildBottomButton(
                // validate: _checkVaildate(state),
                centerWidget: (state is ItemsUpdating)
                    ? CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xff242424)),
                      )
                    : Text(
                        AppLocalizations.of(context)
                            .translate('Confirm')
                            .toUpperCase(),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  // bool _checkVaildate(ItemsData state) {
  //   for (int i = 0; i < state.ticket.detail.groups.length; i++) {
  //     if (!state.ticket.detail.groups[i].isValid()) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }
}
