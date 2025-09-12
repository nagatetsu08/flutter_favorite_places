import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget{
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {

  // 型が定義すれているものはvarはいらない。dartではvarは型推論なので、勝手に型を保管してくれる。
  // selecteImageは撮影しない場合やキャンセルの場合もあるのでnull許容
  // なお、ImagePickerは公式ドキュメントではXFile?を扱うことになっているが、このアプリでは後でPreview表示が必要となっていて
  // プレビュー表示のときにFileオブジェクトを渡す必要があるので、あえてFileオブジェクトで初期化している。
  File? _selectedImage;

  void _takePicture() async {
    final ImagePicker imagePicker= ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if(pickedImage == null) {
      return;
    }
    // XFile型をFile型に変換している
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget content = TextButton.icon(
      icon: Icon(Icons.camera),
      onPressed: _takePicture, 
      label: const Text('Take picture!'),
    );

    if(_selectedImage != null) {
      // 子ウィジェットのあらゆるジェスチャーに対応できる
      content = GestureDetector(
        onTap: _takePicture,
        // ここでプレビュー表示するために、イメージがFile型である必要がある。
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover, // 画像の自動サイズ調整をいい感じにしてくれる。（エリア全体にfitするように）
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }

    // Containerウィジェットを使えばサイズとかをリサイズできて便利
    return Container(
      // 枠に関するデコレーション
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}