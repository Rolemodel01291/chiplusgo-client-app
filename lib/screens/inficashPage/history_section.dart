import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/commen_widgets/bottom_loader.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:intl/intl.dart';

class _InfiCashTransactionItem extends StatelessWidget {
  final ChargeHistory chargeHistory;

  const _InfiCashTransactionItem({this.chargeHistory});

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    ;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('Recharge account'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF242424),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    chargeHistory.getTimeString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFACACAC),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: chargeHistory.amount < 0
                    ? Color(0xFFEFD5D5)
                    : Color(0xFFE3EFD5),
              ),
              child: Center(
                child: Text(
                  " \$" + f.format((chargeHistory.amount / 100).abs()),
                  style: TextStyle(
                      fontSize: 16,
                      color: chargeHistory.amount < 0
                          ? Color(0xFFC60404)
                          : Color(0xFF73B12D)),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Divider(
          height: 0.5,
          color: Color(0xffacacac),
        )
      ]),
    );
  }
}

class HistorySection extends StatefulWidget {
  const HistorySection({Key key});

  @override
  _HistorySectionState createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargeHistoryBloc, ChargeHistoryState>(
      builder: (context, state) {
        if (state is ChargeHistoryUninit) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xff242424),
              ),
            ),
          );
        }

        if (state is ChargeHistoryError) {
          return ErrorPlaceHolder(
            state.errorMsg,
            onTap: () {
              BlocProvider.of(context).add(FetchChargeHistory());
            },
          );
        }

        if (state is ChargeHistoryLoaded) {
          if (state.historys.isEmpty) {
            return ErrorPlaceHolder(
              AppLocalizations.of(context)
                  .translate('No transaction history found'),
              imageName: 'assets/images/emptybox.png',
            );
          }
          return ListView.builder(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: state.hasReachedMax
                ? state.historys.length
                : state.historys.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index >= state.historys.length
                  ? BottomLoader()
                  : _InfiCashTransactionItem(
                      chargeHistory: state.historys[index],
                    );
            },
          );
        }
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<ChargeHistoryBloc>(context).add(FetchChargeHistory());
    }
  }
}
