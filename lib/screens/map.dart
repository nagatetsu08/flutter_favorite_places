import 'package:flutter/material.dart';
import 'package:flutter_favorite_place/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    // 初回作成時に開く時は何も値を持ってないかrequiredではまずい。さらにデフォルト値がないとバグるので
    // デフォルト値を設定しておく
    this.location = const PlaceLocation(
      latitude: 35.68114, 
      longitude: 139.767061, 
      address: '',
    ),
    this.isSelecting = true //新規でこの画面を開く時は新しく場所を指定するために開くので最初はデフォルト値はtrue。
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {

  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Pick Your Location' : 'Your Location'
        ),
        actions: [
          if(widget.isSelecting)
            IconButton(
              onPressed: () {
                // この画面で最終的に選んだ位置情報をpopとともに返す
                Navigator.of(context).pop(_pickedLocation);
              }, 
              icon: const Icon(Icons.save)
            )
        ],
      ),
      body: GoogleMap(
        // ユーザーがTapした位置を選択した位置としてStateに保存する。
        // 長押しでピンを移動させられる
        onLongPress: (position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude, 
            widget.location.longitude
          ),
          zoom: 16,
        ),
        // {}はSetと呼ばれるもので固定の配列と思えばよい。重複登録はできない
        // tapしてない状態ではマーカを表示させたくないので以下のようにチェックをやってやる
        markers: (_pickedLocation == null && widget.isSelecting) ? {} : {
          Marker(
            markerId: MarkerId('m1'),
            // 上でTapした時の位置をStateに保持していて、Stateが変わったのでここが自動描画される
            position: _pickedLocation ?? LatLng(
              widget.location.latitude, 
              widget.location.longitude
            ),
          ),
        },
      ),
    );
  }
}