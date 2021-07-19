import 'package:flutter/material.dart';
import 'package:infishare_client/models/coupon.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/businessdetail/business_coupon_listTile.dart';
import 'package:infishare_client/screens/coupondetail/coupon_details_screen.dart';

typedef void OnHeightChanged(double height);

class BusinessCouponSection extends StatefulWidget {
  final String title;
  final OnHeightChanged onHeightChanged;
  final List<Coupon> coupon;
  final Business business;

  BusinessCouponSection(
      {Key key, this.business, this.title, this.onHeightChanged, this.coupon})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BusinessCouponSectionState(
        onHeightChanged: onHeightChanged, coupon: coupon);
  }
}

class _BusinessCouponSectionState extends State<BusinessCouponSection>
    with SingleTickerProviderStateMixin {
  bool _showMore = false;
  OnHeightChanged onHeightChanged;
  List<Coupon> coupon;

  //*single coupon/voucher tile height(including padding)
  final double _couponHeight = 120.0 + 20 + 16;
  //*coupon/voucher title height(including padding)
  final double _couponTitleHeight = 53.0;
  //*coupon hasmore button height(including padding)
  final double _couponHasMoreBtnHeight = 50.5;

  _BusinessCouponSectionState({this.onHeightChanged, this.coupon});

  @override
  Widget build(BuildContext context) {
    if (coupon.length <= 3) {
      onHeightChanged(_couponHeight * coupon.length + _couponTitleHeight);
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return _buildCouponTitle();
          }

          return CouponListTile(
            coupon: coupon[index - 1],
            onTapped: () {
              _onTap(index - 1);
            },
          );
        }, childCount: coupon.length + 1),
      );
    } else {
      if (_showMore) {
        onHeightChanged(_couponHeight * coupon.length + _couponTitleHeight);
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return _buildCouponTitle();
            }

            return CouponListTile(
                coupon: coupon[index - 1],
                onTapped: () {
                  _onTap(index - 1);
                });
          }, childCount: coupon.length + 1),
        );
      } else {
        onHeightChanged(
            _couponHeight * 3 + _couponTitleHeight + _couponHasMoreBtnHeight);
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return _buildCouponTitle();
            } else if (index >= 1 && index <= 3) {
              return CouponListTile(
                  coupon: coupon[index - 1],
                  onTapped: () {
                    _onTap(index - 1);
                  });
            } else {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    height: 0.5,
                    color: Color(0xffacacac),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: FlatButton.icon(
                      label: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xffacacac),
                      ),
                      icon: Text(
                        'Show ${coupon.length - 3} More ${widget.title}',
                        style: TextStyle(
                            color: Color(0xffacacac),
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        setState(() {
                          _showMore = true;
                        });
                      },
                    ),
                  )
                ],
              );
            }
          }, childCount: 5),
        );
      }
    }
  }

  void _onTap(int selectIndex) {
    Navigator.of(context).pushNamed('/coupon_detail', arguments: {
      'business': widget.business,
      'coupon': widget.coupon,
      'index': selectIndex,
      'title': widget.title,
    });
  }

  Widget _buildCouponTitle() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Text(
        widget.title,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
