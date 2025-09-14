import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;                        // flutter pub addしたやつ（標準のやつじゃない）
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';


import 'package:flutter_favorite_place/models/place.dart';
import 'package:riverpod/legacy.dart';

Future<Database> _getDatabase() async {
  final dbPaths = await sql.getDatabasesPath(); //sqliteのDBPathを取得する。（われわれから指定しなくてOK）
  final db = await sql.openDatabase(
    path.join(dbPaths, 'places.db'), //DBファイルを作成するパスとDB名を指定
    // DBが見つからなかった時（主に初回）に作成される。既にあるときは上記で指定したパスのファイルが開かれる。
    onCreate:(db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNortifier extends StateNotifier<List<Place>> {
  // ここがconstでも良い理由は、river_podは結局前の変数を使って、新しいState変数を作るので、
  // 初期化のタイミングで変更できないようにして問題ないから。
  UserPlacesNortifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final palces = data.map((row) {
      return Place(
        id: row['id'] as String,
        title: row['title'] as String, 
        image: File(row['image'] as String), 
        location: PlaceLocation(
          latitude: row['lat'] as double, 
          longitude: row['lng'] as double, 
          address: row['address'] as String
        ),
      );
    }).toList();

    state = palces;
  }

  void addPlace(String title, File image, PlaceLocation location) async {

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);

    final copiedImage = await image.copy('${appDir.path}/$filename');   //わたってきたイメージファイルをスマホ内のOSがさわれない特別なディレクトリに保存する。

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location
    );

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });


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

