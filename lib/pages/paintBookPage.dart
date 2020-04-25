import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarim_orman_ebook/bloc/bloc.dart';
import 'package:tarim_orman_ebook/data/bookStrings.dart';
import 'package:tarim_orman_ebook/pages/paintBookWidget.dart';

class PaintBookPage extends StatefulWidget {
  @override
  _PaintBookPageState createState() => _PaintBookPageState();
}

class _PaintBookPageState extends State<PaintBookPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final _bloc = BlocProvider.of<FirestoreBloc>(context);
    return BlocBuilder(
      bloc: _bloc,
      // ignore: missing_return
      builder: (context, state) {
        if (state is InitialFirestoreState) {
          _bloc.add(FetchBookImages(bookID: "paintbookcover"));
        } else if (state is BookLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BookLoadedState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridViewBook(state.images),
          );
        } else if (state is BookErrorState) {
          return Center(
            child: Text("Hata"),
          );
        }
        return Container(
          child: Text("Hata oluştu"),
        );
      },
    );
  }

  Widget GridViewBook(List<String> images) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = size.height/2;
    final double itemWidth = size.width / 2;
    return GridView.builder(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            width: itemWidth,
            height: itemHeight,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child:
                    Container(width: itemWidth,height: itemHeight, child: Image.asset(images[index],fit: BoxFit.fill,)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider<FirestoreBloc>(
                                create: (context) => FirestoreBloc(),
                                child: PaintBookWidget(bookChoice:paintBookNameFireList[index],),

                            )),
                      );
                    },
                  ),
                ),
                Text(
                  paintBookNameList[index],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                )
              ],
            ),
          );
        });
  }
}
