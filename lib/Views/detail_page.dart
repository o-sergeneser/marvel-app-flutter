import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:marvel_app/Constants/constants.dart';
import 'package:marvel_app/Models/character_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.info, required this.thumbnail})
      : super(key: key);
  final Results info;
  final Widget thumbnail;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? description;
  List<String>? comicList = [];

  @override
  void initState() {
    setDescription();
    setComics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.info.name!),
        centerTitle: true,
      ),
      body: Container(
          color: backgroundColor,
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: characterPicture(width),
                ),
                Expanded(
                  flex: 1,
                  child: characterDescription(width),
                ),
                Expanded(
                  flex: 3,
                  child: characterComics(width, height),
                ),
              ],
            ),
          )),
    );
  }

  Widget characterComics(double width, double height) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Column(
          children: [
            Expanded(
              child: headlineOfComicList(height, width),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(
                    top: height * 0.010,
                    left: width * 0.03,
                    right: width * 0.03),
                decoration: BoxDecoration(
                    color: primaryColor,
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45))),
                child: comicList!.isEmpty
                    ? comicError(height, width)
                    : comicListView(width, height),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget comicListView(double width, double height) {
    return RawScrollbar(
      thumbColor: Colors.grey[300],
      thickness: width * 0.01,
      radius: const Radius.circular(20),
      isAlwaysShown: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: comicList!.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.001),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.015),
                          child: Text(
                            " ${index + 1}. " + comicList![index] + " ",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget comicError(double height, double width) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: height * 0.1),
        child: SizedBox(
          height: height,
          width: width * 0.45,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Comics not found since 2006",
                style: TextStyle(color: Colors.grey[300]),
              )),
        ),
      ),
    );
  }

  Widget headlineOfComicList(double height, double width) {
    return Padding(
      padding: EdgeInsets.only(
          top: height * 0.0175,
          bottom: height * 0.0125,
          left: width * 0.2,
          right: width * 0.2),
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: primaryColor, width: 4)),
          child: const FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "COMICS",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4),
              ))),
    );
  }

  Widget characterDescription(double width) {
    return Padding(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
      child: Material(
        color: Colors.transparent,
        elevation: 15,
        shadowColor: primaryColor,
        child: Container(
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: AutoSizeText(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ))),
      ),
    );
  }

  Widget characterPicture(double width) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Center(
          child: Material(
              color: Colors.transparent,
              elevation: 15,
              child: widget.thumbnail)),
    );
  }

  void setDescription() {
    description = widget.info.description!.isEmpty
        ? "There is no description found for ${widget.info.name}"
        : widget.info.description!;
  }

  void setComics() async {
    List<ComicsItem>? comics = widget.info.comics!.items;
    if (comics != null) {
      for (ComicsItem comic in comics) {
        int startIndex = comic.name!.indexOf("(");
        int finalIndex = comic.name!.indexOf(")");
        String comicYearString =
            comic.name!.substring(startIndex + 1, finalIndex);
        if (isNumeric(comicYearString)) {
          int year = int.parse(comicYearString);
          if (year > 2005) comicList!.add(comic.name!);
        }
      }
      comicList!.sort((a, b) =>
          (int.parse(b.substring(b.indexOf("(") + 1, b.indexOf(")"))))
              .compareTo(
                  int.parse(a.substring(a.indexOf("(") + 1, a.indexOf(")")))));
      if (comicList!.length > 10) {
        comicList!.removeRange(9, comicList!.length - 1);
      }
    }
  }

  bool isNumeric(String s) {
    return int.tryParse(s) != null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
