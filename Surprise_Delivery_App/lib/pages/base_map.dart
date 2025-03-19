import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BaseMap extends StatefulWidget {
  const BaseMap({super.key});

  @override
  _BaseMapState createState() => _BaseMapState();
}

class _BaseMapState extends State<BaseMap> {
  late GoogleMapController mapController;

  final LatLng _startPos = const LatLng(44.475883, -73.212074);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Base Map"),
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _startPos,
            zoom: 11.0
          ),
        ),
      ),
    );
  }
}