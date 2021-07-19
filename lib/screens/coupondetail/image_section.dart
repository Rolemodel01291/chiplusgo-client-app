import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class CouponImageSection extends StatefulWidget {
  final String title;
  final String businessName;
  final String description;
  final List<String> images;
  final int soldCnt;

  CouponImageSection(
      {this.title,
      this.businessName,
      this.images,
      this.soldCnt,
      this.description});

  @override
  _CouponImageSectionState createState() => _CouponImageSectionState();
}

class _CouponImageSectionState extends State<CouponImageSection> {
  Widget adsGallery(List<String> images, BuildContext context) {
    //* only have one image
    if (images.length == 1) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: 193.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image(
            image: ExtendedNetworkImageProvider(images[0], cache: true),
            width: MediaQuery.of(context).size.width - 32,
            height: 193.0,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    //* normal situation
    return Container(
      height: 100,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 8, right: 16),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/image_page_view', arguments: {
                'image': images,
                'index': index,
              });
            },
            child: Hero(
              tag: images[index],
              child: Container(
                width: 108,
                height: 98,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(5.0),
                      child: Image(
                        image: ExtendedNetworkImageProvider(images[index],
                            cache: true),
                        width: 100.0,
                        height: 98.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              widget.title,
              textAlign: TextAlign.left,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 16),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: <Widget>[
          //       Icon(
          //         Icons.store,
          //         size: 20,
          //       ),
          //       SizedBox(
          //         width: 4,
          //       ),
          //       Text(
          //         widget.businessName,
          //         textAlign: TextAlign.left,
          //         overflow: TextOverflow.ellipsis,
          //         style: TextStyle(
          //           fontSize: 14,
          //           color: Color(0xFFACACAC),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 16,
          ),
          adsGallery(widget.images, context),
          SizedBox(
            height: 8,
          ),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF242424),
                      ),
                    ),
                  ),
                  // Text(
                  //   AppLocalizations.of(context).translate('Sold') +
                  //       " ${widget.soldCnt}",
                  //   textAlign: TextAlign.right,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Color(0xFFACACAC),
                  //   ),
                  // )
                ],
              ))
        ],
      ),
    );
  }
}
