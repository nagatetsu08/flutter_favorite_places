import 'package:flutter/material.dart';
import 'package:flutter_favorite_place/models/place.dart';
import 'package:flutter_favorite_place/screens/place_detail.dart';

class PlacesList extends StatelessWidget{
  const PlacesList({
    super.key,
    required this.places
  });

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if(places.isEmpty) {
      return Center(
        child: Text(
          'No places added yed',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface
          ),
        ),
      );
    }

    // リストが動的で将来的に長くなる可能性がある場合、listView()の簡易的なものではなく、
    // ListView.builderで作った方がパフォーマンスがよくなるらしい。（現在表示されるべき項目のみがレンダリングされる。）
    // つまり画面に写ってない部分は下にスクロールした時に初めてレンダリングされるようなLazyLoadの仕組み（全部レンダリングしてから表示よりも早くなる）
    return ListView.builder(
      itemCount: places.length,
      // アロー演算子で1行の場合はreturnを省略できる。{}の場合はreturn Listtile()にしないとだめ
      itemBuilder: (ctx, index) =>
        ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(places[index].image),
          ),
          title: Text(
            places[index].title,
            // Flutterが裏側でもっているテーマに沿ったスタイルをまとめててきようできる。
            // 一部変更した場合はcopyWithで変えたい部分だけを変更する
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),
          subtitle: Text(
            places[index].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetailScreen(place: places[index])
              ),
            );
          },
      ),
    );
  }
}