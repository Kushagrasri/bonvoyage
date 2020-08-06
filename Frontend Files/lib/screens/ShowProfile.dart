import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';

// ignore: must_be_immutable
class ShowProfile extends StatefulWidget {
  var userToShow;
  var _token;

  ShowProfile(this.userToShow, this._token);

  @override
  State<StatefulWidget> createState() {
    return DisplayUser(userToShow, _token);
  }
}

class DisplayUser extends State<ShowProfile> {
  var user;
  var _token;

  DisplayUser(this.user, this._token);

  @override
  Widget build(BuildContext context) {
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
                  child: FutureBuilder(
                    future: readUserQ(user),
                    builder:
                        (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
        )
    );
  }

  Future<dynamic> readUserQ(var _value) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };

    Response res = await http.get(
      '$SERVER_IP/users/$user',
      headers: headers,
    );

    String returnbody = res.body;

    return returnbody;
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
                Text('Loading their Feed!'),
              ],
            )));
      },
    ));
  }

  // ignore: non_constant_identifier_names
  Widget FeedPage(String data, BuildContext context) {
//    _token
  Map<String,dynamic> data1 = jsonDecode(data);


    Icon iconForFollow = Icon(Icons.person_add);
    String stateFollow = "Follow";
    double value = 76.0;
    if (data1.containsKey('error'))
      return AlertDialog(
          backgroundColor: Colors.black,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  height: 200.0,
                  child: Center(
                      child: Column(
                      children: <Widget>[
                        Container(
                          height: 50.0,
                        ),
                        Text(
                          '$user',
                          style: TextStyle(color: Colors.white),
                        ),
                        if(data1['error']=="User not found")
                          Container(height: 50.0,),
                        Text(
                          '${data1['error']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(height: 60.0,),
                        if(data1['error']!="User not found")
                        RaisedButton(
                          child: Container(
                            width: value,
                            child: Row(
                              children: <Widget>[
                                iconForFollow,
                                Container(width: 10.0,),
                                Text('$stateFollow',style: TextStyle(color: Colors.black),),
                              ],
                            ),
                          ),
                          onPressed: () async {

                            setState(() {
                              iconForFollow = Icon(Icons.done_all);
                              stateFollow = "Requested";
                              value = 102.0;
                            });
                            await followUser(user);
                          },
                        ),
                      ],
                    )
                  )
              );
            },
          )
      );

    Map<String, dynamic> res = jsonDecode(data);
    debugPrint('printing map');
    debugPrint('$res');
    var icon = res['private'] ? Icons.lock_outline : Icons.lock_open;
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black45,
          title: Row(
            children: <Widget>[
              Expanded(child: Text('${res['username']}')),
              Container(
                width: 120.0,
              ),
              Expanded(
                child: Container(
                  child: RaisedButton(
                    child: Center(child: Icon(Icons.settings)),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(minutes: 2),
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
                                  child: RaisedButton(
                                    child: Icon(Icons.keyboard_arrow_down),
                                    onPressed: () {
                                      Scaffold.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 200.0),
                            Row(
                              children: <Widget>[
                                Expanded(child: Icon(icon)),
                                Expanded(
                                    child: res['private']
                                        ? Text('Private Account')
                                        : Text('Public Account')),
                              ],
                            ),
                            Container(
                              height: 50.0,
                            ),
                            Text(
                              'Their email is - ${res['email']}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
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
                  height: 30.0,
                ),
                Container(
                  height: 70.0,
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
                    Container(width: 50.0,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Followers\n${res['followers']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Container(width: 20.0,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Following\n${res['followings']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Container(width: 50.0,),
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
    else
      s = 'followers';
    Response res = await http.get(
      '$SERVER_IP/$s',
      headers: headers,
    );
    return res.body;
  }

  getList(String data) {
    var list = jsonDecode(data);
    int n = list.length;
    debugPrint('printing my list of following');
    debugPrint('$list');

    return Container(
      width: 350.0,
      height: 200.0,
      child: ListView(
        children: <Widget>[
          for (int i = 0; i < list.length; i++)
            ListTile(
              title: Text('${list[i]}'),
              onTap: () {
                ShowProfile(list[i], _token);
              },
            )
        ],
      ),
    );
  }

  Future<void> followUser(String user) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
    Response res = await http.get(
      '$SERVER_IP/users/$user/follow',
      headers: headers,
    );
    debugPrint('$res');
    Navigator.of(context).pop();
  }
}
