import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yoga_app_main/api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String UDID = '';
  String token = '';
  bool isUserLoggedIn = false;
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    // if (UDID != '' && UDID != null) {
    if (isUserLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    APIService service = new APIService();
    SharedPrefs.getUDID().then((value) {
      UDID = value;
    });

    SharedPrefs.getUserFullName().then((value) {
      name = value;
    });

    SharedPrefs.getUserEmail().then((value) {
      email = value;
    });

    SharedPrefs.getUserToken().then((value) {
      token = value;

      service.getUserProfile(token).then((response) {
        SharedPrefs.setUserAvatar(baseURL + response!.user.avatar);
        SharedPrefs.setUserFullName(response.user.name);
      });
    });

    SharedPrefs.isUserLoggedIn().then((value) {
      isUserLoggedIn = value;
    });

    startTime();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'images/girl_splash_back.png',
                    width: MediaQuery.of(context).size.width,
                  )),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'images/girl_splash.png',
                  width: 300,
                )),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset(
                      'images/logo.png',
                      width: 100,
                    )))
          ],
        ));
  }
}
