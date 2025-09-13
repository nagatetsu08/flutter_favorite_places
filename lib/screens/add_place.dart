import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_place/models/place.dart';
import 'package:flutter_favorite_place/widgets/image_input.dart';
import 'package:flutter_favorite_place/widgets/location_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_favorite_place/provider/user_places.dart';


// ユーザーの入力を管理してそれに応じて描画に変更を苦悪のでStatefulWidget
class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }

}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {

  // テキストの値を管理するコントローラ。
  // 何らかのイベントが発生した時に、その都度コントローラ経由で値を取得できる。
  // バリデーションを加えたり、クリアとかセットができる。
  // onChangedのように値が変わる瞬間を検知したい場合は別途onChangedを仕掛けないとだめらしい。（変更検知→トリガーの仕組みはないらしい）
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;

    // Controllerは値がnullでも必ずブランクのテキストを生成するのでnullチェックが必要ない。
    if(enteredTitle.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    }

    // onPressで定義されるので、watchではなくreadを使う
    ref
      .read(userPlacesProvider.notifier)
      .addPlace(enteredTitle, _selectedImage!, _selectedLocation!);

    //保存に成功したら画面を離れる。
    Navigator.of(context).pop();
  }

  // コントローラを破棄する（これがないとメモリリークを起こす可能性があるらしい）
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Place',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text(
                  'Title'
                ),
              ),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            // Image Input
            const SizedBox(height: 10),
            // 子ウィジェットからイメージ情報を取得するやり方。
            // イメージ以外でも活用可能
            // 子から親へ情報を渡すやり方はこのコールバック方式が一般的。
            // 1.子ウィジェットに受け取るコールバック関数を定義し、コンストラクタにも追加
            // 2.子ウィジェットの中でwidget.コールバック関数（渡したい値やオブジェクト）を定義
            // 3.親ウィジェットにて、子ウィジェットを呼び出す箇所で1と同名の関数を渡す定義を書いてやる。
            //.  コールバック関数なので引数には渡された値。それを親で定義した変数にいれてやれば値の引き渡し完了
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 10),
            LocationInput(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 16),
            // icon付きElevatedButtonff
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: _savePlace, 
              label: const Text(
                'Add Place'
              ),
            )
          ],
        ),
      ),
    );
  }
}