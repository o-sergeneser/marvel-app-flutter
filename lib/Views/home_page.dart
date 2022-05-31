import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marvel_app/Components/error_widget.dart';
import 'package:marvel_app/Constants/constants.dart';
import 'package:marvel_app/Models/character_model.dart';
import 'package:marvel_app/Views/detail_page.dart';
import 'package:marvel_app/cubit/characterlist_cubit.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<CharacterListCubit>().loadCharacters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("CHARACTERS"),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: BlocBuilder<CharacterListCubit, CharacterListState>(
            builder: (context, state) {
              return state.state.contains("Error")
                  ? MyErrorWidget(
                      message: state.state,
                      height: height * 0.5,
                      width: width * 0.8)
                  : state.characterList.isEmpty
                      ? firstTimeLoadingIndicator(width)
                      : Stack(
                          children: [
                            characterCarousel(height, width, state, context),
                            if (state.state == "loading")
                              loadingMoreIndicator(height, width),
                          ],
                        );
            },
          ),
        ),
      ),
    );
  }

  Widget characterCarousel(double height, double width,
      CharacterListState state, BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: VerticalCardPager(
        titles: List<String>.from(state.characterList.map((e) => e.name)),
        images: setThumbnails(state.characterList),
        initialPage: 0,
        align: ALIGN.CENTER,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(10.0, 10.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            Shadow(
              offset: Offset(10.0, 10.0),
              blurRadius: 8.0,
              color: primaryColor,
            ),
          ],
        ),
        onPageChanged: (page) {
          if (page! == state.characterList.length - 1) {
            context.read<CharacterListCubit>().loadCharacters();
          }
        },
        onSelectedItem: (index) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(
                        info: state.characterList[index],
                        thumbnail: thumbnail(
                            "${state.characterList[index].thumbnail!.path}.${state.characterList[index].thumbnail!.extension}",
                            BoxFit.contain),
                      )));
        },
      ),
    );
  }

  Widget loadingMoreIndicator(double height, double width) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height * 0.15,
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Container(
              height: height * 0.15,
              width: width,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text("Loading",
                                style: TextStyle(color: Colors.white))),
                      )),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.01),
                        child: SpinKitCubeGrid(
                          color: Colors.white,
                          size: height * 0.05,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget firstTimeLoadingIndicator(double size) {
    return Center(
      child: SpinKitCubeGrid(
        color: Colors.white,
        size: size * 0.1,
      ),
    );
  }

  List<Widget> setThumbnails(List<Results> characterList) {
    List<Widget>? thumbnails = [];
    for (var index in characterList) {
      thumbnails.add(thumbnail(
          "${index.thumbnail!.path}.${index.thumbnail!.extension}",
          BoxFit.cover));
    }
    return thumbnails;
  }

  Widget thumbnail(String imageUrl, BoxFit fit) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          fit: fit,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
