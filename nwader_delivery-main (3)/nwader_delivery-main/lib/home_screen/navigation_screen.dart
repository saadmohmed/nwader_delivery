import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:nwader_devlivery/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;


class NavigationScreen extends StatefulWidget {
  final double lat;
  final double lng;
  final LatLng currentLocation;
  NavigationScreen(this.lat, this.lng ,this.currentLocation);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  loc.LocationData? _currentPosition;
  LatLng curLocation = LatLng(29.911742, 31.070345);
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curLocation = widget.currentLocation;
    getPolyPoints();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourcePosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target:widget.currentLocation ,zoom: 13.5),
            polylines: {
              Polyline(polylineId: PolylineId("route"),
                  points: polylineCoordinates,
                  color: AppTheme.green,
                  width: 6

              )},
            markers: {

              Marker(
                  markerId: MarkerId("source"),
                  position: LatLng(widget.lat! , widget.lng!),
                  infoWindow: InfoWindow(
                      title: 'مندوب التوصيل',
                      snippet: ' مندوب التوصيل'
                  ),
                  // icon:sourceIcon

              ),

              Marker(
                  markerId: MarkerId("destination"),
                  position: widget.currentLocation,
                  infoWindow: InfoWindow(
                      title: 'مكان العميل',
                      snippet: 'مكان العميل'
                  )
              )
            },
            onMapCreated: (mapController){
              _controller.complete(mapController);
            },
          ),

          Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.navigation_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await launchUrl(Uri.parse(
                          'google.navigation:q=${widget.lat}, ${widget.lng}&key=AIzaSyCWNY4Dvhl7BNyihg4BvQK6pkILcQe91zw'));
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }
  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates('AIzaSyCWNY4Dvhl7BNyihg4BvQK6pkILcQe91zw',
        PointLatLng(widget.currentLocation.latitude, widget.currentLocation.longitude), PointLatLng(widget.lat, widget.lng));
    if(result.points.isNotEmpty){
      result.points.forEach(
              (PointLatLng point) => polylineCoordinates.add(
              LatLng(point.latitude, point.longitude)
          ));
      setState(() {

      });

    }
  }

  getNavigation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
            controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 16,
            )));
            if (mounted) {
              controller
                  ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
              setState(() {
                curLocation =
                    LatLng(currentLocation.latitude!, currentLocation.longitude!);
                sourcePosition = Marker(
                  markerId: MarkerId(currentLocation.toString()),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
                  infoWindow: InfoWindow(
                      title: '${double.parse(
                          (getDistance(LatLng(widget.lat, widget.lng))
                              .toStringAsFixed(2)))} km'
                  ),
                  onTap: () {
                    print('market tapped');
                  },
                );
              });
              getDirections(LatLng(widget.lat, widget.lng));
            }
          });
    }
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCWNY4Dvhl7BNyihg4BvQK6pkILcQe91zw',
        PointLatLng(widget.currentLocation.latitude, widget.currentLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng>polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }
  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(widget.lat, widget.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }
}