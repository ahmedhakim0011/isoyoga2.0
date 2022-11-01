import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:yoga_app_main/screens/privacy_and_policy.dart';
import 'package:yoga_app_main/screens/terms_and_conditions.dart';

import '../api_service.dart';
import '../db/shared_pref.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = true;
  late APIService _apiService;
  bool isLoading = false;
  String token = "";

  @override
  void initState() {
    _apiService = new APIService();

    SharedPrefs.getUserToken().then((value) {
      token = value;
    });

    SharedPrefs.getNotificationCheck().then((value) {
      setState(() {
        isNotificationOn = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: isLoading
            ? Column(
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    color: Colors.red,
                  )),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifications",
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        color: Colors.redAccent,
                        height: 25,
                        width: 40,
                        child: Switch.adaptive(
                            activeTrackColor: Colors.transparent,
                            activeColor: Colors.black,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.transparent,
                            value: isNotificationOn,
                            onChanged: (check) {
                              setState(() {
                                isLoading = true;
                                isNotificationOn = check;
                              });

                              _apiService
                                  .setNotificationCheck(check, token)
                                  .then((value) {
                                setState(() {
                                  if (value) {
                                  } else {
                                    isNotificationOn = !isNotificationOn;
                                  }

                                  isLoading = false;
                                  SharedPrefs.setNotificationCheck(
                                      isNotificationOn);
                                });
                              });
                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TermsPage()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Terms and Conditions",
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PolicyPage()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Privacy Policy",
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
