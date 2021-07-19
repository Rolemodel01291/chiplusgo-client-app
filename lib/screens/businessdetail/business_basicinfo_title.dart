import 'package:flutter/material.dart';
import 'package:infishare_client/models/business.dart';
import 'package:infishare_client/screens/businessdetail/rating_bar.dart';

class BusinessDetailTitle extends StatelessWidget {
  final Business business;

  BusinessDetailTitle({this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 165,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            business.businessName['English'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                business.businessName['Chinese'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.near_me,
                    size: 16,
                    color: Color.fromRGBO(172, 172, 172, 0.6),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  // Text(
                  //   business.distance == null ? '-' : business.distance,
                  //   style: TextStyle(
                  //       fontSize: 14,
                  //       color: Color.fromRGBO(172, 172, 172, 0.6)),
                  // )
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                (business.rating * 5).toStringAsFixed(1),
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(255, 163, 72, 1)),
              ),
              Container(
                margin: EdgeInsets.only(left: 4, right: 4),
                height: 14,
                child: StaticRatingBar(
                  size: 14,
                  rate: business.rating * 5,
                ),
              ),
              Text('(${business.reviewCount})'),
            ],
          ),
          Row(
            children: <Widget>[
              // Text(business.priceLabel),
              Text('•'),
              Text(
                business.getCategory(),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.local_offer,
                size: 20,
                color: (business.labels.groupBuy != null &&
                        business.labels.groupBuy)
                    ? Colors.red
                    : Color(0xffacacac),
              ),
              Icon(
                Icons.wifi,
                size: 20,
                color: (business.labels.wifi != null && business.labels.wifi)
                    ? Colors.green
                    : Color(0xffacacac),
              ),
              Icon(
                Icons.local_parking,
                size: 20,
                color:
                    (business.labels.parking != null && business.labels.parking)
                        ? Colors.blue
                        : Color(0xffacacac),
              ),
              // Icon(
              //   Icons.local_activity,
              //   size: 20,
              //   color: (business.labels['voucher'] != null &&
              //           business.labels['voucher'])
              //       ? Colors.yellow
              //       : Color(0xffacacac),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
