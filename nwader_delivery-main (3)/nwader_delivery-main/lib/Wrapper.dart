import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nwader_devlivery/home_screen/myorders.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'Services/ApiManager.dart';
import 'auth_screen/Login.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  var _result;
  static ApiProvider _api = new ApiProvider();

  late SharedPreferences sharedPrefs;
  bool loggedInState = false;

  late Future _future;

  int i = 0;

  @override

  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<bool>(
            future: _api.checkAuth(), // a previously-obtained Future<String> or null
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data == true) {
                  @override
                  void home() {
                    scheduleMicrotask(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyOrders()),
                      );
                    });
                  }

                  home();
                } else {
                  @override
                  void login() {
                    scheduleMicrotask(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    });
                  }

                  login();
                  return Login();
                }
              } else if (snapshot.hasError) {
                // void login() {
                //   scheduleMicrotask(() {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(builder: (context) =>  Login()),
                //     );
                //   });
                // }
                //
                // login();
                return const Center(child: CircularProgressIndicator());
              }
              return Center(child: CircularProgressIndicator());
            }),
      );
}
