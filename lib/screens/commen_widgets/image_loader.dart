import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:extended_image/extended_image.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageLoader extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  ImageLoader({this.url, this.height = 50, this.width = 50});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: Text(
                AppLocalizations.of(context).translate('Loading...'),
                style: TextStyle(color: Colors.grey),
              ),
            );
            break;
          case LoadState.completed:
            return FadeInImage(
              width: width,
              height: height,
              fit: BoxFit.cover,
              image: ExtendedNetworkImageProvider(
                url,
              ),
              placeholder: MemoryImage(kTransparentImage),
            );
            break;
          case LoadState.failed:
            return GestureDetector(
              child: Center(
                child: Text(
                  "Tap to reload",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
            break;
        }
      },
    );
  }
}
