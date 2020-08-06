import 'dart:ui';

import 'package:bon_voyage/main.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:bon_voyage/screens/LoggedInPage.dart';
import 'package:http/http.dart' as http;

final SERVER_IP = 'https://d9a3a8cc6d49.ngrok.io';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpKaro();
  }
}

class SignUpKaro extends State<SignUpPage> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      height: 30.0,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15.0,right: 15.0),
                          child: TextFormField(
//                    keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white70,
                            ),
                            controller: nameController,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Enter your name';
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.text_format),
                                labelText: 'Name',
                                hintText: 'eg. Kushagra',
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
                          padding: EdgeInsets.only(left: 15.0,right:15.0,top:15.0),
                          child: TextFormField(
//                    keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white70,
                            ),
                            controller: ageController,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Enter your age';
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.looks_one),
                                labelText: 'Age',
                                hintText: 'eg. 69',
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
                                return 'Enter your username';
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.android),
                                labelText: 'Username',
                                hintText: 'eg. kush',
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
                          padding: EdgeInsets.only(left: 15.0,right: 15.0),
                          child: TextFormField(
//                    keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white70,
                            ),
                            controller: emailController,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter email';
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.alternate_email),
                                labelText: 'Email',
                                hintText: 'eg. kush@abc.com',
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
                          padding: EdgeInsets.all(15.0),
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
                                hintText: 'eg. gabbieCarter69',
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
                          "Register",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          debugPrint('Register Tapped');
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              createAlbum(nameController, ageController, usernameController,emailController,
                                  passwordController);
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

  Future createAlbum(TextEditingController name,TextEditingController age, TextEditingController username, TextEditingController email,
      TextEditingController pass) async {
    debugPrint(username.text);
    debugPrint(email.text);
    debugPrint(pass.text);
    String ss=name.text;
    String n = username.text;
    int age1 = int.parse(age.text);
    String a = email.text;
    String b = pass.text;

    String json =
        '{"name":"nlikasvniva","email":"aafshbjk@icna.com","password":"iknegcas23"}';
    int n1 = json.length;
//    debugPrint('$n1');

    var _token = 'dwfquwkvcadb829.auvnvfqwfie2.r3cwfqs';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };

    http.Response res = await http.post(
      "$SERVER_IP/users",
      headers: headers,
      body: jsonEncode(
          <String, dynamic>{"name": "$ss","age": age1, "username": "$n", "email": "$a", "password": "$b"}),
    );

    if (res.statusCode == 400) {
      debugPrint('User exists already');
      debugPrint('$res');
      showDialog(
          context: context,
          // ignore: missing_return
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('ERROR'),
                content: Text('Invalid Email or Password'),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: RaisedButton(
                        child: Text('Go To Home Page'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                              ModalRoute.withName("../main"));
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: RaisedButton(
                        child: Text('Close Dialog'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                  Container(width: 1.5,),
                ]);
          });
    } else {
      String ass = res.body;
      print(ass);

//      Map<String, dynamic> answer = jsonDecode(res.body);
//
//      debugPrint('Just after login api called ');
//      String required = answer['token'];
//      debugPrint(required);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
              content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 200.0,
                  height: 200.0,


                  child: Column(
                    children: <Widget>[
                      Container(height: 50.0,),
                      Text(
                        'Verification email sent.\nCheck your mail!',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.deepPurpleAccent
                        ),
                      ),
                      Container(height: 40.0,),
                      Container(

                        alignment: Alignment.center,

                        child: RaisedButton(
                          child: Text('Back to Landing Page',style: TextStyle(fontSize: 12.0),),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()
                                ),
                                ModalRoute.withName("../main")
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                );
              }
            )
          );
        }
      );
    }
  }
}
