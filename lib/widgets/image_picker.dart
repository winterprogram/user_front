import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.url,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List url;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              builder: _buildPhoto,
              scrollPhysics: const BouncingScrollPhysics(),
              itemCount: widget.url.length,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${currentIndex + 1}/${widget.url.length}",
                style: const TextStyle(
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            ),
            SafeArea(
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 16),
                child: FlatButton(
                  shape: CircleBorder(),
                  onPressed: () {},
                  child: BackButton(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildPhoto(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(widget.url[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
    );
  }
}
