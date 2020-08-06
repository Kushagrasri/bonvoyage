import 'dart:convert';
import 'dart:ui';

import 'package:bon_voyage/screens/SearchPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'package:http/http.dart';

import 'ShowProfile.dart';

final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';

class readUser extends StatefulWidget {
  var _token;

  readUser(this._token);

  @override
  State<StatefulWidget> createState() {
    return readIt(_token);
  }
}

class readIt extends State<readUser> {
  var _token;

  readIt(value) {
    _token = value;
  }

  @override
  Widget build(BuildContext context) {
//    Future jsonData = readUserQ(_token);
//    debugPrint('While reading user');
//    debugPrint(_token);
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.pop(context, true);
        },
        child: Scaffold(
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
              Center(
                child: Container(
                  child: FutureBuilder(
                    future: readUserQ(_token),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return LoadingState(context);
                        default:
                          if (snapshot.hasError)
                            return new Text(
                                'Error in snapshot: \n${snapshot.error}');
                          else {
                            return FeedPage(snapshot.data, context);
                          }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<String> readUserQ(var _value) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $_value",
    };

    Response res = await http.get(
      '$SERVER_IP/users/me',
      headers: headers,
    );

    String returnBody = res.body;

    return returnBody;
  }

  // ignore: non_constant_identifier_names
  Widget LoadingState(BuildContext context) {
    return AlertDialog(content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
            height: 200.0,
            child: Center(
                child: Column(
              children: <Widget>[
                Container(
                  height: 50.0,
                ),
                CircularProgressIndicator(
                  strokeWidth: 5.0,
                  backgroundColor: Colors.grey,
//              valueColor: Animation<color>,
                ),
                Container(
                  height: 60.0,
                ),
                Text('Bringing up your Feed!'),
              ],
            )));
      },
    ));
  }

  // ignore: non_constant_identifier_names
  Widget FeedPage(var data, BuildContext context) {
    Map<String, dynamic> res = jsonDecode(data);
    debugPrint('printing map');
    debugPrint('$res');

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(

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
            ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //row
                    Container(height: 50.0),
                    Row(
                      children: <Widget>[
                        Container(width: 50.0,),
                        Expanded(child: Text('${res['username']}',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white))),
                        Container(
                          width: 60.0,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 20.0),
                            child: RaisedButton(
                              child: Stack(
                                children: <Widget>[
                                  Center(child: Icon(Icons.settings)),
                                  if (res['requests'] != 0)
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          '${res['requests']}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700),
                                        )),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return goToUserSettings(res);
                                    }));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Text(
                        'Name : ${res['name']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      height: 70.0,
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Text(
                        'Age : ${res['age']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      height: 30.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 30.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              'Followers\n${res['followers']}',
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(minutes: 1),
                                content: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 20.0,
                                    ),
                                    Flex(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        Container(
                                          child: Icon(Icons.keyboard_arrow_down),
                                        ),
                                      ],
                                    ),
                                    Container(height: 100.0),
                                    Container(
                                        height: 150.0,
                                        child: Text('Followers snackbar')),
                                    Container(
                                      child: FutureBuilder(
                                        future: returnFollowing(1),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return CircularProgressIndicator();
                                            default:
                                              if (snapshot.hasError)
                                                return new Text(
                                                    'Error in snapshot: \n${snapshot.error}');
                                              else {
                                                return getList(snapshot.data, 0);
                                              }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                            },
                          ),
                        ),
                        Container(
                          width: 50.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              'Following\n${res['followings']}',
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(minutes: 1),
                                content: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 20.0,
                                    ),
                                    Flex(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        Container(
                                          child: Icon(Icons.keyboard_arrow_down),
                                        ),
                                      ],
                                    ),
                                    Container(height: 100.0),
                                    Container(
                                        height: 150.0,
                                        child: Text('Following snackbar')),
                                    Container(
                                      child: FutureBuilder(
                                        future: returnFollowing(2),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return CircularProgressIndicator();
                                            default:
                                              if (snapshot.hasError)
                                                return new Text(
                                                    'Error in snapshot: \n${snapshot.error}');
                                              else {
                                                return getList(snapshot.data, 0);
                                              }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                            },
                            hoverElevation: 100.0,
                          ),
                        ),
                        Container(
                          width: 30.0,
                        ),
                      ],
                    ),
                    Container(height: 200.0,),
                    RaisedButton(
                      child: Text('Search for a User'),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return SearchPage( _token);
                            }));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  returnFollowing(int k) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
    String s;
    if (k == 2)
      s = 'followings';
    else if (k == 3)
      s = 'requests';
    else
      s = 'followers';
    Response res = await http.get(
      '$SERVER_IP/$s',
      headers: headers,
    );
    return res.body;
  }

  getList(String data, int z) {
//     Map<String, String> _headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//       "Authorization": "Bearer $_token",
//     };

    var list = jsonDecode(data);
    int n = list.length;
    debugPrint('printing my list');
    debugPrint('$list');
    if (n == 0)
      return Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Center(
          child: Text('Nothing to display!'),
        ),
      );
    return Container(
      width: 350.0,
      height: 200.0,
      child: ListView(
        children: <Widget>[
          for (int i = 0; i < list.length; i++)
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                      child: Text(
                        '${list[i]}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ShowProfile(list[i], _token);
                        }));
                      }),
                ),
                if (z == 1)
                  Expanded(
                      child: Container(
                    width: 80.0,
                  )),
                if (z == 1)
                  Expanded(
                    child: RaisedButton(
                      child: Center(
                          child: Icon(
                        Icons.check,
                      )),
                      onPressed: () async {
                        setState(() {
//                          res['requests']--;
                          respondReq(true, list[i], context);
                        });
                      },
                    ),
                  ),
                if (z == 1)
                  Container(
                    width: 10.0,
                  ),
                if (z == 1)
                  Expanded(
                    child: RaisedButton(
                      child: Center(
                          child: Icon(
                        Icons.close,
                      )),
                      onPressed: () async {
                        setState(() {
                          respondReq(false, list[i], context);
                        });
                      },
                    ),
                  ),
              ],
            )
        ],
      ),
    );
  }

  Future<void> respondReq(
      bool resp, String username, BuildContext context1) async {
    debugPrint('respond with $resp');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };

    Response res = await http.post(
      '$SERVER_IP/requests/$username',
      headers: headers,
      body: jsonEncode(<String, dynamic>{"follow": resp}),
    );

    Navigator.of(context).pop();

    debugPrint('${res.body}');
  }

  goToUserSettings(Map<String, dynamic> res) {
    var icon = res['private'] ? Icons.lock_outline : Icons.lock_open;
    return Scaffold(
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
        Column(
          children: <Widget>[
            Container(
              height: 20.0,
            ),
            Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 40.0),
                  child: RaisedButton(
                    child: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Container(height: 100.0),
            Row(
              children: <Widget>[
                Expanded(child: Icon(icon)),
                Expanded(
                    child: res['private']
                        ? Text(
                            'Private Account',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w700),
                          )
                        : Text(
                            'Public Account',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w700),
                          )),
              ],
            ),
            Container(
              height: 50.0,
            ),
            Container(
                child: Text(
              'Your email is - ${res['email']}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
            )),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 50.0, bottom: 40.0),
              child: Text(
                'Requests - ',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              child: FutureBuilder(
                future: returnFollowing(3),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if (snapshot.hasError)
                        return new Text(
                            'Error in snapshot: \n${snapshot.error}');
                      else {
                        return getList(snapshot.data, 1);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
