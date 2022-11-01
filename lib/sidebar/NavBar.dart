import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../screens/update_profile_screen.dart';

class NavBar extends StatelessWidget {
  NavBar({
    required this.onChanged,
  });

  final ValueChanged<dynamic> onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 100),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 150),
            child: SvgPicture.asset(
              "images/bottom_menu.svg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width -
                (MediaQuery.of(context).size.width * 0.40),
            child: Container(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfilePage()),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Image.network(
                            "${avatar}",
                            height: 50,
                            errorBuilder: (context, err, e) {
                              return Container();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${name}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${email}",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      onChanged(5);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfilePage()),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          "images/ic_sidebar_profile.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 30),
                        Text("My Profile")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 30.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      onChanged(6);
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          "images/ic_sidebar_class.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 30),
                        Text("Class Details")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 30.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      onChanged(7);
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          "images/ic_sidebar_history.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 30),
                        Text("Order History")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 30.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      onChanged(10);
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          "images/ic_sidebar_history.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 30),
                        Text("Packages")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 30.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      onChanged(8);
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          "images/ic_sidebar_settings.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 30),
                        Text("Settings")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 30.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      onChanged(9);
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          "images/ic_sidebar_logout.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 30),
                        Text("Signout")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 30.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
