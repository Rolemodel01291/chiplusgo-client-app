import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/recharge_bloc/recharge_inficash_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/charge_option.dart';
import 'package:intl/intl.dart';

class InficashPaymentSection extends StatefulWidget {
  final ChargeOption chargeOption;
  final double customizeNum;
  final int selectIndex;

  InficashPaymentSection({
    this.chargeOption,
    this.selectIndex,
    this.customizeNum,
  });
  PaymentSectionState createState() => PaymentSectionState();
}

class PaymentSectionState extends State<InficashPaymentSection> {
  @override
  void initState() {
    // default select first charge option
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    ;
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Amount'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 3,
            childAspectRatio:
                (MediaQuery.of(context).size.width - 32 - 16) / 3 / 70,
            children: <Widget>[
              RechargeItem(
                amount: widget.chargeOption.options[0].baseAmount,
                bonus: widget.chargeOption.options[0].bouns,
                number: 0,
                index: widget.selectIndex,
              ),
              RechargeItem(
                amount: widget.chargeOption.options[1].baseAmount,
                bonus: widget.chargeOption.options[1].bouns,
                number: 1,
                index: widget.selectIndex,
              ),
              RechargeItem(
                amount: widget.chargeOption.options[2].baseAmount,
                bonus: widget.chargeOption.options[2].bouns,
                number: 2,
                index: widget.selectIndex,
              ),
              RechargeItem(
                amount: widget.chargeOption.options[3].baseAmount,
                bonus: widget.chargeOption.options[3].bouns,
                number: 3,
                index: widget.selectIndex,
              ),
              RechargeItem(
                amount: widget.chargeOption.options[4].baseAmount,
                bonus: widget.chargeOption.options[4].bouns,
                number: 4,
                index: widget.selectIndex,
              ),
              widget.chargeOption.options[5].baseAmount != -1
                  ? RechargeItem(
                      amount: widget.chargeOption.options[5].baseAmount,
                      bonus: widget.chargeOption.options[5].bouns,
                      number: 5,
                      index: widget.selectIndex,
                    )
                  : OtherItem(
                      title: widget.customizeNum == 0.0
                          ? AppLocalizations.of(context).translate('Other')
                          : '\$${f.format(widget.customizeNum)}',
                      number: 5,
                      index: widget.selectIndex,
                    )
            ],
          ),
        ],
      ),
    );
  }
}

// if item's number == index, then item is selected and change its boarder and color.
// once taped, it updates selectedIndex and rebuild all items. Also update bottom bar amount.
class RechargeItem extends StatelessWidget {
  RechargeInficashBloc _rechargeInficashBloc;
  final double amount;
  final double bonus;
  final int number;
  final int index;
  RechargeItem(
      {Key key,
      @required this.amount,
      @required this.bonus,
      @required this.number,
      @required this.index});

  @override
  Widget build(BuildContext context) {
    Color color = number != index ? Color(0xFF242424) : Colors.white;
    Color fillColor = number != index
        ? Color(0xff1463a0).withOpacity(0.1)
        : Color(0xff1463a0);
    _rechargeInficashBloc = BlocProvider.of<RechargeInficashBloc>(context);
    return GestureDetector(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: fillColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "\$${amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Visibility(
              child: Text(
                AppLocalizations.of(context).translate('Bonus') +
                    " \$${bonus.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 14, color: color),
              ),
              visible: bonus != 0,
            )
          ],
        ),
      ),
      onTap: () {
        _rechargeInficashBloc.add(
          ChangeRechargeOptions(index: number),
        );
      },
    );
  }
}

// if item's number == index, then item is selected and change its boarder and color.
// once taped, it updates selectedIndex and rebuild all items; It also call a alertdialog immediatelly.
// alertdialog only accept number from 5 to 100 to be submitted, and max digits is 5(includs comma).
// once submitted, update bottom bar amount.
// once dismissed, reset
class OtherItem extends StatefulWidget {
  final String title;
  final int number;
  final int index;
  const OtherItem({
    Key key,
    @required this.title,
    @required this.number,
    @required this.index,
  });

  @override
  OtherItemState createState() => OtherItemState();
}

class OtherItemState extends State<OtherItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        widget.number != widget.index ? Color(0xFF242424) : Colors.white;
    Color fillColor = widget.number != widget.index
        ? Color(0xff1463a0).withOpacity(0.1)
        : Color(0xff1463a0);
    return GestureDetector(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: fillColor),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
      onTap: () {
        BlocProvider.of<RechargeInficashBloc>(context).add(
          ChangeRechargeOptions(index: 5),
        );
      },
    );
  }
}
