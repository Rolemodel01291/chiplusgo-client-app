import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/bottom_loader.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/commen_widgets/transaction_item.dart';
import 'package:infishare_client/screens/mywalletscreen/transaction_item_detail_route.dart';

class TransactionHistorySection extends StatefulWidget {
  const TransactionHistorySection({Key key});

  @override
  _TransactionHistorySectionState createState() =>
      _TransactionHistorySectionState();
}

class _TransactionHistorySectionState extends State<TransactionHistorySection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
      if (state is TransactionHistoryUninit) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xff1463a0),
            ),
          ),
        );
      }

      if (state is TransactionHistoryError) {
        return ErrorPlaceHolder(
          state.errorMsg,
          onTap: () {
            BlocProvider.of(context).add(FetchTransactionHistory());
          },
        );
      }

      if (state is TransactionHistoryLoaded) {
        if (state.historys.isEmpty) {
          return ErrorPlaceHolder(
            AppLocalizations.of(context)
                .translate('No transaction history found'),
            imageName: 'assets/images/emptybox.png',
          );
        }

        return ListView.builder(
          itemCount: state.hasReachedMax
              ? state.historys.length
              : state.historys.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return index >= state.historys.length
                // ? BottomLoader()
                ? Container()
                : TransactionItem(
                    transactionHistory: state.historys[index],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionItemDetailRoute(
                                    transactionHistory: state.historys[index],
                                  )));
                    },
                  );
          },
        );
      }
    });
  }
}
