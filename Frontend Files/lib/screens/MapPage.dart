import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

//import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';

class MapPage extends StatefulWidget {
  var tokens;

  MapPage(this.tokens);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState(tokens);
  }
}

LatLng _center = LatLng(26.7655646, 83.3714829);

//home is at 26.7655646, 83.3714829
//iet lucknow is at 26.9143243,80.9388227
//google mountain view,ca is at 37.4219996,-122.0927908
class _MyAppState extends State<MapPage> {
  var tokenValue;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _MyAppState(this.tokenValue);

  final Completer<GoogleMapController> mapController = Completer();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  CameraPosition changeLoc = CameraPosition(
    target: LatLng(26.9143243, 80.9388227),
    zoom: 15.0,
  );

//  Position _currentPosition;
  var _formKey = GlobalKey<FormState>();
  bool visited = false;
  Set<Marker> _markers = {};
  Set<Marker> newMarkers = {};
  bool haveMarkerData = false;
  bool markerCondition = false;
  Set<Marker> fromWebsite = {};

  TextEditingController commentName = TextEditingController();

  BitmapDescriptor pinLocationIcon, toVisitIcon, usableIcon, newIcon;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  @override
  void initState() {
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
    });
    updatePinOnMap();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/custompin.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/basics.png')
        .then((onValue) {
      newIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/addLoc.png')
        .then((onValue) {
      toVisitIcon = onValue;
    });
    commentName.addListener(() {});
  }

  void onChanged(bool value) {
    setState(() {
      visited = value;
    });
  }

  LatLng newTappedPlace;
  Icon gpsIcon = Icon(Icons.location_searching);
  Icon markIcon = Icon(Icons.outlined_flag);

  @override
  Widget build(BuildContext context) {


    CameraPosition initialCameraPosition = CameraPosition(
        zoom: 12.0,
        target: _center
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude,
              currentLocation.longitude),
          zoom: 12.0,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: GradientAppBar(

          backgroundColorStart: Colors.redAccent,
          backgroundColorEnd: Colors.blue,
          title: Container(
            padding: EdgeInsets.all(5),
            child: Center(
              child: Row(
                children: <Widget>[
                  Text('Your Map'),
                  Container(width: 10,),
                  Icon(Icons.navigation),
                ],
              ),
            ),
          ),
//          automaticallyImplyLeading: false,
        ),
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(
                    "assets/image11.jpg",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: ClipRRect(
                // make sure we apply clip it properly
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(

                      child: GoogleMap(
                        buildingsEnabled: false,
                        trafficEnabled: false,
                        compassEnabled: true,
                        mapType: MapType.normal,

                        onMapCreated: (mapController) {
                          this.mapController.complete(mapController);
                        },
                        initialCameraPosition: initialCameraPosition,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        gestureRecognizers: Set()
                          ..add(Factory<EagerGestureRecognizer>(
                              () => EagerGestureRecognizer())),
                        zoomControlsEnabled: false,
                        markers: _markers,

                        onTap: (tappedPlace) async {
                          _scaffoldKey.currentState.removeCurrentSnackBar();
                          setState(() {

                            _markers.add(
                              Marker(
                                markerId: MarkerId("New Place"),
                                position: LatLng(tappedPlace.latitude,
                                    tappedPlace.longitude),
                                infoWindow: InfoWindow(
                                  title: "New Place",
                                ),
                                icon: newIcon,
                              ),
                            );
                            newTappedPlace = tappedPlace;
                            debugPrint(
                                'New tapped place found = $newTappedPlace');
                          });

                          await dataNewMarker(newTappedPlace);

                          if (correctAdd) {
                            if (visited) {
                              debugPrint('icon = visited wala');
                              usableIcon = pinLocationIcon;
                            } else {
                              usableIcon = toVisitIcon;
                              debugPrint('icon = not visited wala');
                            }
                            debugPrint('visited value: $visited');
                            debugPrint('comment is ${commentName.text}');
                            setState(() {
                              newMarkers.add(
                                Marker(
                                  markerId: MarkerId("${commentName.text}"),
                                  position: LatLng(newTappedPlace.latitude,
                                      newTappedPlace.longitude),
                                  infoWindow: InfoWindow(
                                    title: "${commentName.text}",
                                  ),
                                  icon: usableIcon,
                                ),
                              );
                              setState(() {
                                _markers = newMarkers;
                              });
                            });
                            postNewMarker(
                                commentName.text,
                                newTappedPlace.latitude,
                                newTappedPlace.longitude,
                                visited);
                          }
                          correctAdd=false;
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 480.0,
                      ),
                      Row(children: <Widget>[
                        Container(width: 20.0),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: markIcon,
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  _markers.clear();
                                  getMarkers();
                                  _markers = newMarkers;
                                }); //set state done
                                debugPrint('Marked your places');
                              },
                            ),
                          ),
                        ),
//                        Align(
//                          alignment: Alignment.bottomLeft,
//                          child: Padding(
//                            padding: EdgeInsets.all(20.0),
//                            child: RaisedButton(
//                              color: Colors.black,
//                                child: Text('My places',style: TextStyle(color: Colors.white),),

//                          ),
//                        ),

                        Container(
                          width: 205.0,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(5.0),
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: gpsIcon,
                              color: Colors.blue,
                              onPressed: () async {
                                LocationData myLoc =
                                    await _getCurrentLocation();
                                if (myLoc != null)
                                  setState(() {
                                    gpsIcon = Icon(Icons.my_location);
                                  });
                                final controller = await mapController.future;
                                await controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target:
                                        LatLng(myLoc.latitude, myLoc.longitude),
                                    zoom: 12.0,
                                  ),
                                ));
                                debugPrint('pressed icon button');
                              },
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Future<Set<Marker>> getMarkers() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $tokenValue",
    };

    http.Response res = await http.get(
      "$SERVER_IP/visits",
      headers: headers,
    );

    List<dynamic> jsonInMap = jsonDecode(res.body);

    setState(() {
      _markers.clear();
    });

    for (int i = 0; i < jsonInMap.length; i++) {
      Map<dynamic, dynamic> onePlace = jsonInMap[i];
      bool visited = onePlace['visited'];
      double latitude = onePlace['latitude'];
      double longitude = onePlace['longitude'];
      String bookmarks = onePlace['comment'];
      debugPrint('$bookmarks $latitude $longitude $visited');

      if (!visited) {
        usableIcon = toVisitIcon;
      } else
        usableIcon = pinLocationIcon;

      setState(() {
        newMarkers.add(
          Marker(
            markerId: MarkerId("$bookmarks"),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: "$bookmarks",
            ),
            icon: usableIcon,
          ),
        );
      });
    }
    return newMarkers;
  }

  void postNewMarker(
      String commentString, double latitude, double longitude, bool vis) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $tokenValue",
    };

    http.Response res = await http.post(
      "$SERVER_IP/visits",
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        "comment": "$commentString",
        "latitude": latitude,
        "longitude": longitude,
        "visited": vis
      }),
    );
  }

  bool correctAdd = false;

  dataNewMarker(LatLng newTappedPlace) async {
    commentName.clear();
//    return _scaffoldKey.currentState.showSnackBar(SnackBar(
//      duration: Duration(seconds: 15),
//      content: StatefulBuilder(
//          builder: (BuildContext context, StateSetter setState) {
//        return Container(
//
//            height: 214.0,
//            child: Column(
//              children: <Widget>[
//                Text(
//                  'Add this place',
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25.0),
//                ),
//                Container(
//                  height: 20.0,
//                ),
//                TextField(
//                  style: TextStyle(
//                    fontFamily: 'Raleway',
//                    color: Colors.black87,
//                    fontSize: 18.0,
//                  ),
//                  controller: commentName,
//                  decoration: InputDecoration(
//                    suffixIcon: Icon(Icons.add_location),
//                    border: OutlineInputBorder(
//                      borderRadius: BorderRadius.circular(5.0),
//                    ),
//                  ),
//                ),
//                CheckboxListTile(
//                    title: Text('Visited this already?'),
//                    value: visited,
//                    onChanged: (bool val) {
//                      setState(() {
//                        visited = val;
//                      });
//                    }),
//
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    IconButton(
//                      icon: Icon(Icons.add),
//                      onPressed: () {
//                        setState(() {
//                          correctAdd=true;
//                        });
//                        _scaffoldKey.currentState.removeCurrentSnackBar();
//                      },
//                    ),
//                    Container(
//                      width: 100.0,
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.transit_enterexit),
//                      onPressed: () {
//                        setState(() {
//                          correctAdd=false;
//                        });
//                        _scaffoldKey.currentState.removeCurrentSnackBar();
//                      },
//                    ),
//                  ],
//                ),
//              ],
//            ));
//      }),
//    ));

    return showDialog(
        context: context,
        // ignore: missing_return
        builder: (BuildContext context) {
          return AlertDialog(

            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(

                width: 200.0,
                height: 225.0,
                child: Column(
                  children: <Widget>[
                    Text('Name your Marker'),
                    Container(height: 20.0),
                    TextField(
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black87,
                        fontSize: 18.0,
                      ),
                      controller: commentName,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.add_location),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        title: Text('Visited this already?'),
                        value: visited,
                        onChanged: (bool val) {
                          setState(() {
                            visited = val;
                          });
                        }),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text('Add this'),
                            onPressed: () {
                              correctAdd = true;
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          width: 20.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text('Cancel this'),
                            onPressed: () {
                              correctAdd = false;
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: 12.0,
      target: LatLng(currentLocation.latitude,
          currentLocation.longitude),
    );
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    //send this location to api for tracking location data or navigation data


  }
}
