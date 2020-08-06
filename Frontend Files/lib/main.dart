
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bon_voyage/screens/LogInPage.dart';
import 'package:bon_voyage/screens/SignUpPage.dart';
final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bon Voyage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Bon Voyage Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.blueGrey,
          body: Container(

            child: Stack(
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
                  child: Transform(
                    transform: Matrix4.skewX(0.0),
//            angle: -0.1,
                    child: Text(
                      "Bon Voyage",
                      style: TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.redAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 7.0,
                            color: Colors.blueAccent,
                            offset: Offset(5.0, 5.0),
                          ),
                          Shadow(
                            color: Colors.deepOrangeAccent,
                            blurRadius: 30.0,
                            offset: Offset(-5.0, 5.0),
                          ),
                        ],
                        fontFamily: 'Sacramento',
//                  fontWeight: FontWeight.w700,
                        fontSize: 65.0,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 7.0),
                            child: RaisedButton(
                              splashColor: Colors.blueAccent,
                              elevation: 5.0,
                              color: Colors.black54,
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                debugPrint('Log In tapped');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return LogInPage();
                                    }));
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 7.0),
                            child: RaisedButton(
                              splashColor: Colors.blueAccent,
                              elevation: 5.0,
                              color: Colors.black54,
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                debugPrint('Sign Up tapped');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignUpPage();
                                    }));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
