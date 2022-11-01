import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoga_app_main/screens/packages_screen.dart';
import 'package:yoga_app_main/screens/settings_screen.dart';
import 'package:yoga_app_main/screens/update_profile_screen.dart';

import '../constants.dart';
import '../db/shared_pref.dart';
import '../fragments/attendance_fragment.dart';
import '../fragments/classes_fragment.dart';
import '../fragments/home_fragment.dart';
import '../fragments/live_session_fragment.dart';
import '../fragments/tutorial_fragment.dart';
import '../provider/social_login.dart';
import '../sidebar/NavBar.dart';
import 'class_history_screen.dart';
import 'login_screen.dart';
import 'order_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = -1;
  String Appbar_Title = "Home";
  String avatarDp = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SharedPrefs.getUserAvatar().then((value) {
      setState(() {
        avatarDp = value;
        avatar = avatarDp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavBar(
        onChanged: (value) {
          _scaffoldKey.currentState?.openEndDrawer();
          openFragment(value);
        },
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'images/ic_sidebar.png',
              width: 10,
              height: 10,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                );
              },
              child: Container(
                child: Image.network(
                  avatar,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.black,
        title: Text(
          "${setTitle(_currentIndex)}",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = -1;
            Appbar_Title = "Home";
          });
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage(
                    'images/bg_btn.jpeg',
                  ),
                  fit: BoxFit.fill)),
          width: 50,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Image.asset(
              "images/ic_home.png",
              width: 40,
              height: 40,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          SvgPicture.asset(
            "images/bottom_menu.svg",
            height: 60,
            fit: BoxFit.fill,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            child: BottomNavigationBar(
              onTap: (item_index) {
                setState(() {
                  _currentIndex = item_index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
              selectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 10),
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                    icon: new Image.asset(
                      "images/ic_bookin.png",
                      width: 20,
                      height: 20,
                    ),
                    label: "Booking"),
                BottomNavigationBarItem(
                    icon: new Image.asset(
                      "images/ic_attendance.png",
                      width: 20,
                      height: 20,
                    ),
                    label: "Attendance"),
                BottomNavigationBarItem(label: "", icon: Container()),
                BottomNavigationBarItem(
                    icon: new Image.asset(
                      "images/ic_tutorial.png",
                      width: 20,
                      height: 20,
                    ),
                    label: "Tutorial"),
                BottomNavigationBarItem(
                    icon: new Image.asset(
                      "images/ic_streaming.png",
                      width: 20,
                      height: 20,
                    ),
                    label: "Sessions"),
              ],
            ),
          ),
        ],
      ),
      body: openFragment(_currentIndex),
    );
  }

  setTitle(index) {
    if (index == -1) {
      Appbar_Title = "Home";
    } else if (index == 0) {
      Appbar_Title = "Classes";
    } else if (index == 1) {
      Appbar_Title = "Attendance";
    } else if (index == 3) {
      Appbar_Title = "Tutorial Videos";
    } else if (index == 4) {
      Appbar_Title = "Live Sessions";
    } else {
      Appbar_Title = "Home";
    }

    return Appbar_Title;
  }

  Widget openFragment(index) {
    setTitle(index);

    if (index == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PackagesScreen()),
      );
    } else if (index == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClassHistoryPage()),
      );
    } else if (index == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderHistoryPage()),
      );
    } else if (index == 8) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    } else if (index == 9) {
      SocialLogin().facebookSignout();
      SocialLogin().googleSignOut(context: context);
      SharedPrefs.setUserToken("");
      SharedPrefs.setUserLoggedIn(false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }

    if (index == -1) {
      return HomeFragment(
        onChanged: (value) {},
      );
    } else if (index == 0) {
      return ClasesFragment();
    } else if (index == 1) {
      return AttendanceFragment();
    } else if (index == 4) {
      return LiveSessionFragment();
    } else if (index == 3) {
      return TutorialFragment();
    } else
      return Container(
        child: Text("No Menu Option"),
      );
  }
}
