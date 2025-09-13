import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_favorite_place/models/place.dart';

class LocationInput extends StatefulWidget{
  const LocationInput({
    super.key,
    required this.onSelectLocation
  });

  final void Function(PlaceLocation location) onSelectLocation; 

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {

  final apiKey = dotenv.env['API_KEY'];

  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if(_pickedLocation == null) {
      return '';
    } 
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey";
  }


  void _getCurrentLocation() async {

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // ローディング状態にする
    setState(() {
      _isGettingLocation = true;    
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if(lat == null || lng == null) {
      return;
    }

    final endPoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    final url = Uri.parse(endPoint);

    final response = await http.get(url);
    final resData = json.decode(response.body);
    String address = '';
    if (resData['results'] != null && resData['results'].isNotEmpty) {
      address = resData['results'][0]['formatted_address'];
    } else {
      address = 'No address found';
    }

    // ローディング状態解除
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat, 
        longitude: lng, 
        address: address
      );
      _isGettingLocation = false;    
    });

    widget.onSelectLocation(_pickedLocation!);
  }


  @override
  Widget build(BuildContext context) {

    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface
      ),
    );

    if(_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity
      );
    }

    if(_isGettingLocation) {
      previewContent = CircularProgressIndicator();
    }

    return Column(
      children: [
        // プレビュー用コンテナ
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
            ),
          ),
          child: previewContent
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ユーザーの位置情報を自動で取得するボタン
            TextButton.icon(
              icon: Icon(Icons.location_on),
              onPressed: _getCurrentLocation, 
              label: const Text('Get Current Location')
            ),
            // Mapから位置を指定するボタン
            TextButton.icon(
              icon: Icon(Icons.map),
              onPressed: () {}, 
              label: const Text('Select on Map')
            ),
          ],
        ),
      ],
    );
  }
}