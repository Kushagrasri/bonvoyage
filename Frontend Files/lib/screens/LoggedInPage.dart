import 'dart:ui';

import 'package:bon_voyage/screens/readUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

import '../main.dart';
import 'MapPage.dart';
import 'NavigatePage.dart';
final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';

// ignore: must_be_immutable
class LoggedInPage extends StatefulWidget {
  var value;
  var json;

  LoggedInPage(this.value, this.json);

  @override
  State<StatefulWidget> createState() {
    return NewLoginPage(value, json);
  }
}

class NewLoginPage extends State<LoggedInPage> {
  var val;
  var jsonn;

  NewLoginPage(this.val, this.jsonn);

  @override
  Widget build(BuildContext context) {
//    debugPrint('inside logged in page');
//    debugPrint(jsonn);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
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
              Column(
                children: <Widget>[
                  Container(height: 80.0,),
                  Container(
                    child: Text(
                      'Welcome to Bon-Voyage',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Amatic',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),


                  Container(
                    height: 150.0,
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                        child: Text('Social'),
                        onPressed: () {
                          debugPrint('Social tapped  $jsonn');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return readUser(jsonn);
                              }));

                        }),
                  ),
                  Container(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                        child: Text('Journey'),
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return MapPage(jsonn);
                              }));
                        }),
                  ),
                  Container(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                        child: Text('Travel'),
                        onPressed: () {
                          debugPrint('Travel tapped  $jsonn');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return NavigatePage(jsonn);
                              }));

                        }),
                  ),
                  Container(
                    height: 20.0,
                  ),
                  Container(height: 80.0),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(

                      children: <Widget>[
                        Container(width: 20.0),
                        Expanded(

                          child: Center(
                            child: RaisedButton(
                                child: Text('Log Out'),
                                onPressed: () {

                                  showDialog(
                                      context: context,
                                      // ignore: missing_return
                                      builder: (BuildContext context) {
                                      return logoutHere('$jsonn');
                                      }
                                  );
                                  // add alert dialog for removing this device or all
                                }
                            ),
                          ),
                        ),
                        Container(width: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }



  Widget logoutHere(String _token) {
    bool visited = false;
    return AlertDialog(content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
            height: 200.0,
            child: Center(
                child: Column(
                  children: <Widget>[
                    Container(height:20.0),
                    Text('Come back soon!'),
                    Container(height: 35.0),
                    CheckboxListTile(
                        title: Text('Logout from all devices?'),
                        value: visited,
                        onChanged: (bool val) {
                          setState(() {
                            visited = val;
                          });
                        }),
                    Container(height:22.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                              child: Text('Quit'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                logoutAllDev(_token,visited);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()
                                    ),
                                    ModalRoute.withName("../main")
                                );
                              },
                            )
                        ),
                        Container(width: 30.0),
                        Expanded(
                          child: RaisedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ),
                      ],
                    ),

                  ],
                )));
      },
    ));
  }

  Future logoutAllDev(String _token,bool visited) async {
    String where;
    if(visited==true)
      where="logoutAll";
    else
      where="logout";

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $_token"
    };


    http.Response res = await http.post(
      "$SERVER_IP/users/$where",
      headers: headers,
    );


  }


}

