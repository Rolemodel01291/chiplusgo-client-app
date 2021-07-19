import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ImagePageView extends StatefulWidget {
  final List<String> images;
  final int index;

  ImagePageView({
    Key key,
    this.images,
    this.index,
  }) : super(key: key);

  @override
  _ImagePageViewState createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          return FullScreenImage(
            image: widget.images[index],
          );
        },
        itemCount: widget.images.length,
      ),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  final String image;

  FullScreenImage({Key key, this.image}) : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onDoubleTap: _handleScaleReset,
      child: Transform(
        transform: Matrix4.diagonal3(
          vector.Vector3(_zoom, _zoom, _zoom),
        ),
        alignment: FractionalOffset.center,
        child: Hero(
          tag: widget.image,
          child: ExtendedImage.network(
            widget.image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  double _zoom;
  double _previousZoom;

  @override
  void initState() {
    _zoom = 1.0;
    _previousZoom = null;
    super.initState();
  }

  void _handleScaleStart(ScaleStartDetails start) {
    setState(() {
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails update) {
    setState(() {
      _zoom = _previousZoom * update.scale;
    });
  }

  void _handleScaleReset() {
    setState(() {
      _zoom = 1.0;
    });
  }
}
