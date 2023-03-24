import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var mapMarkers = <Marker>[
    Marker(
      markerId: MarkerId('marker_1'),
      position: const LatLng(47.6, 8.8796),
      consumeTapEvents: true,
      infoWindow: const InfoWindow(
        title: 'PlatformMarker',
        snippet: "Hi I'm a Platform Marker",
      ),
      onTap: () {
        print("Marker tapped");
      },
    ),
  ];
  Position? _currentPosition;
  late PlatformMapController mapController;

  getAddress() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      await GeolocatorPlatform.instance.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              // bearing: 270.0,
              target: LatLng(position.latitude, position.longitude),
              // tilt: 30.0,
              zoom: 10,
            ),
          ),
        );
        mapMarkers.clear();
        mapMarkers.add(
          Marker(
              markerId: MarkerId('User Location'),
              consumeTapEvents: true,
              infoWindow: InfoWindow(
                title: '${position.latitude} ${position.latitude}',
                snippet: "Hi I'm a Platform Marker",
              ),
              onTap: () {
                print("Marker tapped");
              },
              position: LatLng(position.latitude, position.longitude)),
        );
      });
    });
  }

  void _incrementCounter() {
    getAddress();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          PlatformMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(47.6, 8.8796),
              zoom: 16.0,
            ),
            markers: Set<Marker>.of(mapMarkers),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (location) => print('onTap: $location'),
            // onCameraMove: (cameraUpdate) =>
            //     print('onCameraMove: ${cameraUpdate.googleMapsCameraPosition}'),
            compassEnabled: true,
            onMapCreated: (controller) {
              mapController = controller;
              Future.delayed(const Duration(seconds: 2)).then(
                (_) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        bearing: 270.0,
                        target: LatLng(51.5160895, -0.1294527),
                        tilt: 30.0,
                        zoom: 18,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (_currentPosition != null)
            Container(
              height: 140,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.grey),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LATITUDE",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    _currentPosition!.latitude.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "LONGITUDE",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    _currentPosition!.longitude.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
