import 'dart:ui';
import 'ShowProfile.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  var _token;
  SearchPage(this._token);
  @override
  State<StatefulWidget> createState() {
    return MakeSearch(_token);
  }

}

class MakeSearch extends State<SearchPage> {
  var _token;
  MakeSearch(this._token);
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 170.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.alternate_email),
                          labelText: 'Enter username',
                          hintText: 'eg. varun',
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
                  Container(height: 90.0,),
                  RaisedButton(
                    child: Text('Go to their page'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ShowProfile(searchController.text, _token);
                          }));
                    },
                  ),
//                  Container(height: 20.0,child: Text('made till here'),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}