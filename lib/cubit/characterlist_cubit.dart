import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:marvel_app/Constants/constants.dart';
import 'package:marvel_app/Models/character_model.dart';
import 'package:marvel_app/Services/web_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'characterlist_state.dart';

class CharacterListCubit extends Cubit<CharacterListState> {
  CharacterListCubit()
      : super(CharacterListState(characterList: [], state: "idle"));

  int offset = 0;

  void loadCharacters() async {
    emit(CharacterListState(
        characterList: state.characterList, state: "loading"));
    await WebServices.fetchData(Client(),"characters",
            extraParams: "&limit=$heroLimit&offset=$offset")
        .then((value) {
      if (value != null) {
        if (value is String) {
          String errMsg = value;
          emit(CharacterListState(
              characterList: state.characterList, state: "Error: $errMsg"));
        } else {
          List<Results> characters = List<Results>.from(
              value["data"]["results"].map((e) => Results.fromJson(e)));

          for (var index in characters) {
            state.characterList.add(index);
          }
          offset += heroLimit;
          emit(CharacterListState(
              characterList: state.characterList, state: "success"));
        }
      }
    });
  }
}
