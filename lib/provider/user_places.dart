import 'dart:io';

import 'package:flutter_favorite_place/models/place.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


class UserPlacesNortifier extends StateNotifier<List<Place>> {
  // ここがconstでも良い理由は、river_podは結局前の変数を使って、新しいState変数を作るので、
  // 初期化のタイミングで変更できないようにして問題ないから。
  UserPlacesNortifier() : super(const []);

  void addPlace(String title, File image, PlaceLocation location) {
    final newPlace = Place(
      title: title,
      image: image,
      location: location
    );



    // コメントアウトしとくけど、provider内からExceptionをthrowしてUI側でtry catchすることも可能。

    // 例：同じtitleならエラー
    // state.anyは「条件を満たす要素が1つでも存在するか」というやつ。(anyは単なるクロージャー)
    // containsにすると、オブジェクトを渡す必要があって、中身全部一緒かどうか判定される。テキスト以外を保持する場合はNG
    // 中身の項目のどれかで判定する場合はanyがいい
    // if (state.any((place) => place.title == title)) {
    //   throw Exception('同じタイトルのPlaceは追加できません');
    // }
    // 新規追加が先頭にくるようにしている。後で前のState変数を展開
    state = [newPlace, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNortifier, List<Place>>(
  (ref) => UserPlacesNortifier(),
);

