import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WacGoogleMap extends StatefulWidget {
  @override
  _WacGoogleMapState createState() => _WacGoogleMapState();
}

class _WacGoogleMapState extends State<WacGoogleMap> {
  GoogleMapController googleMapController;
  setMapController(GoogleMapController controller) {
    googleMapController = controller;
  }

  LatLng originLocation = LatLng(31.509722187411608, 34.44695994257927);
  LatLng destinationLocation = LatLng(31.547093171886107, 34.47578966617584);
  getCurrentLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition();
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation, zoom: 14)));
    } catch (error) {
      print(error);
    }
  }

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  setPolyLines() async {
    try {
      polylinePoints = PolylinePoints();
      PolylineResult polylineResult =
          await polylinePoints.getRouteBetweenCoordinates(
              'your key',
              PointLatLng(originLocation.latitude, originLocation.longitude),
              PointLatLng(
                  destinationLocation.latitude, destinationLocation.longitude));

      markers.add(Marker(
          markerId: MarkerId('origin'),
          position: LatLng(originLocation.latitude, originLocation.longitude)));

      markers.add(Marker(
          markerId: MarkerId('dest'),
          position: LatLng(
              destinationLocation.latitude, destinationLocation.longitude)));
      List<PointLatLng> points = polylineResult.points;
      List<LatLng> polyLineCordianates =
          points.map((e) => LatLng(e.latitude, e.longitude)).toList();
      Polyline polyline = Polyline(
          points: polyLineCordianates, polylineId: PolylineId('shady'));
      polylines.add(polyline);
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('LOCATION'),
      ),
      body: GoogleMap(
          polylines: polylines,
          onTap: (argument) {
            print(argument.latitude);
            print(argument.longitude);
          },
          markers: markers,
          onMapCreated: (controller) {
            setMapController(controller);
            getCurrentLocation();
          },
          initialCameraPosition:
              CameraPosition(target: LatLng(45.55, 35.22), zoom: 10)),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setPolyLines();
      }),
    );
  }
}
