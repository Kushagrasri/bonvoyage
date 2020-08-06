
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:bon_voyage/screens/LoggedInPage.dart';
import 'package:http/http.dart' as http;

final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LogInKaro();
  }
}

class LogInKaro extends State<LogInPage> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
//    debugPrint('Inside login page');
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },

      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: GestureDetector(
          onTap: () {

            FocusScope.of(context).requestFocus(new FocusNode());
          },
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
              Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                    ),
                    Container(
                      alignment: Alignment.topCenter,
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
//                      fontWeight: FontWeight.w700,
                          fontSize: 65.0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 30.0),

                    ),
                    Container(
                      height: 30.0,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: TextFormField(
//                    keyboardType: TextInputType.number,

                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white70,
                            ),
                            controller: usernameController,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter username';
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.alternate_email),
                                labelText: 'Username/Email',
                                hintText: 'email@abc.com',
//                              fillColor: Colors.white30,
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                labelStyle: TextStyle(
                                    fontFamily: 'Raleway', color: Colors.white70),
                                errorStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.redAccent,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 15.0, top: 2.0),
                          child: TextFormField(
//                    keyboardType: TextInputType.number,
                            obscureText: _obscureText,

                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white70,
                            ),
                            controller: passwordController,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter password';
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                    ),
                                    onPressed: () {
                                      _toggle();
                                    }),
                                labelText: 'Password',
                                hintText: '* * * * * * * *',
//                              fillColor: Colors.white70,
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.white70,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.redAccent,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 100.0,
                        right: 100.0,
                        top: 15.0,
                      ),
                      child: RaisedButton(
                        splashColor: Colors.blueAccent,
                        elevation: 5.0,
                        color: Colors.black54,
                        child: Text(
                          "Enter",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
//                        debugPrint('Enter Tapped');
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              createAlbum(usernameController, passwordController);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createAlbum(
      TextEditingController user, TextEditingController pass) async {
//    debugPrint(user.text);
//    debugPrint(pass.text);
    String a = user.text;
    String b = pass.text;

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    http.Response res = await http.post(
      "$SERVER_IP/users/login",
      headers: headers,
      body: jsonEncode(<String, String>{"username": "$a", "password": "$b"}),
    );
    var x = res.statusCode;
    Map<String,dynamic> body = jsonDecode(res.body);

    if (x == 400) {
      debugPrint('Invalid credentials');
      showDialog(
          context: context,
          // ignore: missing_return
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Uh Oh :('),
                content: Text('    ${body['error']}'),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: RaisedButton(
                      child: Text('Go Back'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ]);
          });
    } else if(x==401) {
      TextEditingController code = TextEditingController();
      //verification karna hai idhar
      showDialog(
          context: context,
          // ignore: missing_return
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white70,


                content: Container(
                  width: 200.0,
                  height: 200.0,
                  child: Column(
                    children: <Widget>[
                      Text('Enter the verification code sent to your mail!',style:TextStyle(color: Colors.deepPurpleAccent)),
                      Container(height: 30.0,),
                      TextField(
                        controller: code,
                        decoration: InputDecoration(
                          fillColor: Colors.deepPurpleAccent,
                            focusColor: Colors.deepPurpleAccent,
                            hoverColor: Colors.deepPurpleAccent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),

                            ),
                        ),
                      ),
                      Container(height: 25.0,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              child: Text('Verify'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                callVerify(code.text, a , b);
                              },
                            ),
                          ),
                          Container(width: 30.0,),
                          Expanded(
                            child: RaisedButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
          });

    }
    else {
      String ass = res.body;
//      print(ass);

      Map<String, dynamic> answer = jsonDecode(res.body);

//      debugPrint('Just after login api called ');
      String required = answer['token'];
//      debugPrint(required);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoggedInPage(res.statusCode, required);
      }));
    }
  }

  Future<void> callVerify(String text,String a, String b) async {
    var _token = "avnc.vadnae.vaniae";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    int z = int.parse(text);
    debugPrint('$text');
    http.Response res = await http.post(
      "$SERVER_IP/users/verify",
      headers: headers,
      body: jsonEncode(<String, dynamic>{"username": "$a", "password": "$b", "verificationCode":z}),
    );
    var x = res.statusCode;
    if(x==400){
      showDialog(
          context: context,
          // ignore: missing_return
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Uh Oh :('),
                content: Text('Wrong Verification Code'),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: RaisedButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ]);
          });
    }
    else if(x==401){
      showDialog(
          context: context,
          // ignore: missing_return
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Uh Oh :('),
                content: Text('Previous code expired, check and enter new one :D'),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: RaisedButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ]);
          });
    } else {
      Map<String, dynamic> answer = jsonDecode(res.body);
      String required = answer['token'];
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoggedInPage(res.statusCode, required);
      }));
    }


  }
}
