import 'dart:async';
import 'dart:convert';
import 'dart:ui';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;



final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';
class NavigatePage extends StatefulWidget {
  var json;
  NavigatePage(this.json);
  @override
  State<StatefulWidget> createState() {
    return NavigateThis(json);
  }

}
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(26.7655646, 83.3714829);
const LatLng DEST_LOCATION = LatLng(26.7374291,83.3864219);
//water park = 26.7374291,83.3864219
class NavigateThis extends State<NavigatePage> {
  var token;
  NavigateThis(this.token);

  final Completer<GoogleMapController> mapController = Completer();


  //copied part starts here
  Set<Marker> _markers = Set<Marker>();
  // for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = "AIzaSyDWmNlfcLVtsJ_lQfYbj6-5RXOfxX39u_k";
// for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;

//  LocationData myLoc;/* = LatLng(26.7655646, 83.3714829);*/

  /*= CameraPosition(
    target: LatLng(26.7655646, 83.3714829),

  );*/


  Timer timer;

  @override
  void initState () {
    super.initState();

    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event

    location.onLocationChanged.listen((LocationData cLoc) {
//      print("changed");
      _output = currentLocation.latitude.toString() + " " + currentLocation.longitude.toString();
//      print(cLoc);
//      func();


      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;


//      if(DateTime.now().minute%2 == 0&&DateTime.now().second<10)
//        print("at this minute location is $currentLocation");
      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();

//    timer = Timer.periodic(Duration(milliseconds: 50), (Timer t) => print(currentLocation));

  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
//  sendLocation() {
//
//    print('$currentLocation.');
//
//  }

  /*void func() {
//    setState(() {
      _output = currentLocation.latitude.toString() + " " + currentLocation.longitude.toString();
      print(_output);
//    });
  }*/
  var _output;
  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition = LatLng(currentLocation.latitude,
        currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(destinationLocation.latitude,
        destinationLocation.longitude);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon
    ));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon
    ));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }
  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/custompin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/addLoc.png');
  }
  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }
  void setPolylines() async {
    print("Got in function setpolylines");
    print("current location = $currentLocation");
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
//        travelMode: TravelMode.driving,

    );
    print(" asnwe = ${result.points}");
    print("going to add not added yet");
    if(result.points.isNotEmpty){
      print("Adding polyline");
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude,point.longitude)
        );
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
//            color: Colors.cyanAccent,
            points: polylineCoordinates
        ));
      });
    }
    else print("empty");
  }
  void updatePinOnMap() async {

    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: 18,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude,
          currentLocation.longitude),
    );
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
//    if(this.mounted)
    setState(() {
      // updated position
      var pinPosition = LatLng(currentLocation.latitude,
          currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
              (m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon
      ));
    });
  }
  /*
  void initfunc() async {

    *//*LocationData tempLoc = await _getCurrentLocation();
    if(tempLoc==null) {
      myLoc.latitude = 26.7655646;
      myLoc.longitude = 83.3714829;
    }
    else {
      myLoc.latitude = tempLoc.latitude;
      myLoc.longitude = tempLoc.longitude;
    }*//*

  }*/
  bool variable=true;
  @override
  Widget build(BuildContext context) {
//    const fiveSeconds = const Duration(seconds: 5);
    // _fetchData() is your function to fetch data

    if(DateTime.now().minute%2==0&&variable==true){
      print("${DateTime.now().second}at this minute location is $currentLocation");
      sendData();
      variable = false;
    }
    if(DateTime.now().minute%2==1 &&!variable) {
      variable = true;
      print("variable changed");
    }

//    _output = currentLocation.latitude.toString() + " " + currentLocation.longitude.toString();
      return Scaffold(
        appBar: GradientAppBar(
          backgroundColorStart: Colors.redAccent,
          backgroundColorEnd: Colors.blue,
          title: Container(
            padding: EdgeInsets.all(5),
            child: Center(
              child: Row(
                children: <Widget>[
                  Text('Navigate'),
                  Container(width: 10,),
                  Icon(Icons.navigation),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/image11.jpg",),
                  fit: BoxFit.fill,

                ),
              ),
              child: ClipRRect( // make sure we apply clip it properly
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: <Widget>[

                    GoogleMap(

                        initialCameraPosition: CameraPosition(
                          zoom: 18,
                          target: LatLng(26.7655646, 83.3714829),
                          tilt: CAMERA_TILT,
                          bearing: CAMERA_BEARING,
                        ),
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        markers: _markers,
                        polylines: _polylines,
                        onMapCreated: (mapController) {
                          this.mapController.complete(mapController);
                          // my map has completed being created;
                          // i'm ready to show the pins on the map
                          showPinsOnMap();
                        }
//                    onMapCreated: (mapController) {
//                      this.mapController.complete(mapController);
//                    },
                    ),
                    Align(
                      alignment: Alignment.topCenter,

                      child: Container(
                        color: Colors.red,
                        height: 20,
                        width: 200,
                        child: Text('$_output',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                      ),
                    ),
//                  Align(
//                    alignment: Alignment.lerp(Alignment.bottomRight, Alignment.topLeft, 0.03),
//
//                    child: Container(
//                      padding: EdgeInsets.all(5.0),
//                      decoration: const ShapeDecoration(
//                        color: Colors.white,
//                        shape: CircleBorder(),
//                      ),
//                      child: IconButton(
//                        icon: Icon(Icons.gps_fixed),
//                        onPressed: () async {
//                          print('Loc tapped');
//                          LocationData myLoc =
//                              await _getCurrentLocation();
//
//                          final controller = await mapController.future;
//                          await controller.animateCamera(
//                              CameraUpdate.newCameraPosition(
//                                CameraPosition(
//                                  target:
//                                  LatLng(myLoc.latitude, myLoc.longitude),
//                                  zoom: 18.0,
//                                  tilt: CAMERA_TILT,
//                                  bearing: CAMERA_BEARING,
//                                ),
//                              ));
//                        },
//                      ),
//                    ),
//                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  Future<LocationData> _getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;

    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        debugPrint('Denied 1 time');
      }
    }
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        debugPrint('Denied 2 times');
      }
    }
    bool qq = true;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        debugPrint('Denied 3 times');
        qq = false;
      }
    }

    if (qq) {
      debugPrint('Location Granted');
      _locationData = await location.getLocation();
      var lat, long;
      lat = _locationData.latitude;
      long = _locationData.longitude;
      debugPrint('Latitude = $lat');
      debugPrint('Longitude = $long');

      return _locationData;
    } else {
      debugPrint('Location Permission denied, No location found');
      return null;
    }
  }

   sendData() async {
     Map<String, String> headers = {
       "Content-Type": "application/json",
       "Accept": "application/json",
       "Authorization": "Bearer $token",
     };
     var response = await http.post(
       "$SERVER_IP/dayvisits",
       headers: headers,
       body: jsonEncode(<String,dynamic>{
         "latitude": "${currentLocation.latitude}",
         "longitude": "${currentLocation.longitude}"
       }),
     );
     print(response.body);
     print("Sent from func");
//      print(response.body);

   }
  }



