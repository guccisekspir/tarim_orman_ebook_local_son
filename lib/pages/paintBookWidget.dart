import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarim_orman_ebook/bloc/bloc.dart';
import 'package:tarim_orman_ebook/pages/paintingPage.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'dart:math' as math;

class PaintBookWidget extends StatefulWidget {
  final String bookChoice;

  const PaintBookWidget({Key key, this.bookChoice}) : super(key: key);

  @override
  _PaintBookWidgetState createState() => _PaintBookWidgetState(bookChoice);
}

class _PaintBookWidgetState extends State<PaintBookWidget> {
  final String bookChoicee;

  @override
  void initState() {
    super.initState();
  }

  _PaintBookWidgetState(this.bookChoicee);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final _bloc = BlocProvider.of<FirestoreBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder(
        bloc: _bloc,
        // ignore: missing_return
        builder: (context, FirestoreState state) {
          if (state is InitialFirestoreState) {
            _bloc.add(FetchBookImages(bookID: bookChoicee));
          } else if (state is BookLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BookLoadedState) {

            return TransformerPageView(
              loop: false,
              transformer: new ZoomOutPageTransformer(),
              itemCount: state.images.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[

                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(state.images[index]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipOval(
                          child: Material(
                            elevation: 10,
                            color: Colors.blueGrey, // button color
                            child: InkWell(

                              splashColor: Colors.deepPurpleAccent,
                              // inkwell color
                              child: SizedBox(
                                  width: 46,
                                  height: 46,
                                  child: Center(
                                      child: Icon(Icons.close,color: Colors.black,size: 40,))),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipOval(
                          child: Material(
                            color: Colors.tealAccent, // button color
                            child: InkWell(
                              splashColor: Colors.deepPurpleAccent,
                              // inkwell color
                              child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Center(
                                      child: Icon(Icons.brush,size: 29,color: Colors.black,))),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaintingPage(
                                              imageURI: state.images[index],
                                            )));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is BookErrorState) {
            return Center(
              child: Text("Hata oluştu"),
            );
          }
          return Center(
            child: Text("Hata Oluştu"),
          );
        },
      ),
    );
  }
}

class ZoomOutPageTransformer extends PageTransformer {
  static const double MIN_SCALE = 0.85;
  static const double MIN_ALPHA = 0.5;

  @override
  Widget transform(Widget child, TransformInfo info) {
    double position = info.position;
    double pageWidth = info.width;
    double pageHeight = info.height;

    if (position < -1) {
      // [-Infinity,-1)
      // This page is way off-screen to the left.
      //view.setAlpha(0);
    } else if (position <= 1) {
      // [-1,1]
      // Modify the default slide transition to
      // shrink the page as well
      double scaleFactor = math.max(MIN_SCALE, 1 - position.abs());
      double vertMargin = pageHeight * (1 - scaleFactor) / 2;
      double horzMargin = pageWidth * (1 - scaleFactor) / 2;
      double dx;
      if (position < 0) {
        dx = (horzMargin - vertMargin / 2);
      } else {
        dx = (-horzMargin + vertMargin / 2);
      }
      // Scale the page down (between MIN_SCALE and 1)
      double opacity = MIN_ALPHA +
          (scaleFactor - MIN_SCALE) / (1 - MIN_SCALE) * (1 - MIN_ALPHA);

      return new Opacity(
        opacity: opacity,
        child: new Transform.translate(
          offset: new Offset(dx, 0.0),
          child: new Transform.scale(
            scale: scaleFactor,
            child: child,
          ),
        ),
      );
    } else {
      // (1,+Infinity]
      // This page is way off-screen to the right.
      // view.setAlpha(0);
    }

    return child;
  }
}
