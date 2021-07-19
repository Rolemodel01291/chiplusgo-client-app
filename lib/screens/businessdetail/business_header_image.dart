import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BusinessHeaderImage extends StatefulWidget {
  final List<String> imageUrls;

  BusinessHeaderImage({this.imageUrls}) : assert(imageUrls != null);

  @override
  State<StatefulWidget> createState() {
    return _BusinessHeaderImageState();
  }
}

class _BusinessHeaderImageState extends State<BusinessHeaderImage> {
  int _showingIndex = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            onPageChanged: _onPageChanged,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Hero(
                tag: widget.imageUrls[index],
                child: FadeInImage(
                  fit: BoxFit.cover,
                  image: ExtendedNetworkImageProvider(widget.imageUrls[index],
                      cache: true),
                  placeholder: MemoryImage(kTransparentImage),
                ),
              );
            },
          ),
          Positioned(
            right: 16.0,
            bottom: 8.0,
            child: Container(
              height: 32,
              child: RawMaterialButton(
                elevation: 0.0,
                fillColor: Color.fromRGBO(172, 172, 172, 0.6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$_showingIndex of ${widget.imageUrls.length}',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/image_page_view', arguments: {
                    'image': widget.imageUrls,
                    'index': _showingIndex - 1,
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _showingIndex = index + 1;
    });
  }
}
