import 'package:flutter/material.dart';
import 'package:flutter_favorite_place/provider/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:flutter_favorite_place/models/place.dart';
import 'package:flutter_favorite_place/screens/add_place.dart';
import 'package:flutter_favorite_place/widgets/places_list.dart';


class PlacesScreen extends ConsumerWidget{
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
        child: PlacesList(
          places: userPlaces,
        ),
      ),
    );
  }

}