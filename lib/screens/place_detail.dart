import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_favorite_place/models/place.dart';

class PlaceDetailScreen extends StatelessWidget{
  const PlaceDetailScreen({
    super.key,
    required this.place
  });

  final Place place;

  String get locationImage {
    final apiKey = dotenv.env['API_KEY'];

    final lat = place.location.latitude;
    final lng = place.location.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title,
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // 上記画像上に重ねるように配置
          Positioned(
            bottom: 0,  //上記画像の下0に接する
            left: 0,    //上記画像の左0に接する
            right: 0,   //上記画像の右0に接する（左と右で0にすると画面いっぱいにコンテンツを広げるという意味になる）
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(locationImage),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    place.location.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}