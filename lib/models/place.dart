import 'dart:io';

import 'package:uuid/uuid.dart';

// uuidを生成するインスタンスなのでconstにして問題ない。
// ランダム値は後で使用するメソッドないで生成する
const uuid = Uuid();

class PlaceLocation {
    const PlaceLocation({
      required this.latitude,
      required this.longitude,
      required this.address,
  });


  final double latitude;  
  final double longitude;
  final String address;
}

class Place {

  // このコンストラクタの書き方(:id = uuid.v4())をイニシャライザリストと呼ぶ
  // これはfinalとかconstにおいて、コンストラクタが動く前に値をセットし、それからコンストラクタを動かしてくれるというもの
  // これでわざわざuuidを外部から渡さなくても、初期化のタイミングでidも自動生成した上でセット→コンストラクタという感じで動かしてくれる。
  // superクラスで先に初期化する際も同じやり方をする
  Place({
    required this.title,
    required this.image,
    required this.location,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}