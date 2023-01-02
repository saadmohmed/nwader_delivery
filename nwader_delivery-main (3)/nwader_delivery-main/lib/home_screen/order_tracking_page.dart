import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:nwader_devlivery/Services/ApiManager.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app_theme.dart';
class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key , required this.latlng , required this.order_id , required this.myLocation}) : super(key: key);
  final LatLng latlng ;
  final String order_id ;
  final LatLng myLocation;
  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static  LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
 ApiProvider _api = new ApiProvider();
  void getCurrentLocation()async{
    Location location = Location();
    location.getLocation().then((location){
      currentLocation = location;
    });
    GoogleMapController googleaMapController = await _controller.future;

    location.onLocationChanged.listen((event)async {
      currentLocation = event;
     // dynamic data = await _api.update_driver_location(event.latitude!.toString(), event.latitude!.toString() , widget.order_id);
     // print("ddddddddddd"+data.toString());
      googleaMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom:13.5,
          target: LatLng(event.latitude!,event.longitude!))));
      sourceLocation = LatLng(event.latitude!,event.longitude!);
      polylineCoordinates.clear();
      getPolyPoints();
      setState(() {

      });

    });
  }
void getPolyPoints() async {
  PolylinePoints polyLinePoints = PolylinePoints();
  PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates('AIzaSyCWNY4Dvhl7BNyihg4BvQK6pkILcQe91zw',
      PointLatLng(widget.myLocation.latitude, widget.myLocation.longitude), PointLatLng(widget.latlng.latitude, widget.latlng.longitude));
if(result.points.isNotEmpty){
  result.points.forEach(
          (PointLatLng point) => polylineCoordinates.add(
    LatLng(point.latitude, point.longitude)
  ));
  setState(() {

  });

}
}
@override
  void initState() {
  getPolyPoints();
  setCustomMarkerIcon();
    super.initState();
  }

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  void setCustomMarkerIcon(){
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/icons/logo.png").then((icon){
      sourceIcon = icon;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(

        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text(
            'توصيل  الطلب',
            style: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppTheme.darkText,
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () async {
              _key.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset('assets/icons/menu-icon.png'),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                Navigator.pop(context,true);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_sharp,
                  color: AppTheme.green,
                ),
              ),
            ),

          ],
        ),

        body:GoogleMap(
          initialCameraPosition: CameraPosition(target:widget.latlng ,zoom: 13.5),
          polylines: {
          Polyline(polylineId: PolylineId("route"),
          points: polylineCoordinates,
            color: AppTheme.green,
            width: 6

          )},
          markers: {

            Marker(
              markerId: MarkerId("source"),
              position: LatLng(widget.myLocation!.latitude! , widget.myLocation!.longitude!),
                infoWindow: InfoWindow(
                    title: 'مندوب التوصيل',
                    snippet: ' مندوب التوصيل'
                ),
              icon:sourceIcon

            ),

            Marker(
                markerId: MarkerId("destination"),
                position: widget.latlng,
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
        floatingActionButton:           Container(
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
                    'google.navigation:q=${widget.latlng.latitude}, ${widget.latlng.longitude}&key=AIzaSyCWNY4Dvhl7BNyihg4BvQK6pkILcQe91zw'));
              },
            ),
          ),
        )
        ,
      ),
    );
  }
}
