import 'package:flutter/material.dart';
import 'package:flutter_favorite_place/provider/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:flutter_favorite_place/models/place.dart';
import 'package:flutter_favorite_place/screens/add_place.dart';
import 'package:flutter_favorite_place/widgets/places_list.dart';


class PlacesScreen extends ConsumerStatefulWidget{
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {

  // lateキーワードをつけることで、定義のタイミングで初期値が決まってなくていい（null）でもいいことをDartに伝えている。
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {

    // placesのState変数が変わるたびに通知してリビルドしてくれるリスナー(watchのこと)
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Places',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen()
                ),
              );
            },
            icon: const Icon(Icons.add)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: PlacesList(
        //   places: userPlaces,
        // ),

        // Futureが解決したら自動でレンダリングしてくれる仕組み
        child: FutureBuilder(
          future: _placesFuture, 
          builder:(context, snapshot) =>
            // Futureが完了したかどうかのチェック.
            // ローディング中であれば、ローディングのインジケータをみせて
            // ローディングが完了していれば、PlacesListを展開したものをみせる。

            // 3項演算子を使うと、1行で書ける（見やすさのために段落にしてるけど）ので、アロー関数でreturnを省略できる。
            snapshot.connectionState == ConnectionState.waiting 
            ? const Center(
              child: CircularProgressIndicator(),
            ) 
            : PlacesList(
              places: userPlaces,
            ),

            // 以下の書き方はアロー関数使わずに書いた時のやつ
            // 注意点としては、複数行にわたって書くので'return'を省略できないこと。
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //     return const Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else {
            //     return PlacesList(
            //       places: userPlaces,
            //     );
            //   }

        ),
      ),
    );
  }

}