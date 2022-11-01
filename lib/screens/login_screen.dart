import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yoga_app_main/screens/signup_screen.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../provider/social_login.dart';
import 'forgot_password.dart';
import 'home_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String UDID = '';
  bool isUserLoggedIn = false;
  late APIService apiService;
  bool isLoading = false;
  String fcm_token = "";
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    SharedPrefs.getFirebaseToken().then((value) {
      fcm_token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage(
                            'images/bg_login.jpeg',
                          ),
                          fit: BoxFit.cover))),
              isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Image.asset(
                                  'images/logo.png',
                                  width: 80,
                                ))),
                        SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 24, color: Colors.deepOrangeAccent),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 45),
                          child: TextField(
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Enter Email',
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 45),
                          child: TextField(
                            controller: _passwordController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });

                            if (_emailController.text.length < 3 ||
                                _passwordController.text.length < 3) {
                              Fluttertoast.showToast(
                                msg:
                                    "Username or Password is incorrect!", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.CENTER, // location
                                // duration
                              );

                              setState(() {
                                isLoading = false;
                              });

                              return;
                            }

                            apiService
                                .loginCustomer(context, _emailController.text,
                                    _passwordController.text, fcm_token)
                                .then((response) {
                              if (response == null) {
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                SharedPrefs.setUserToken(response.accessToken!);
                                SharedPrefs.setUserAvatar(
                                    baseURL + response.user!.avatar!);
                                SharedPrefs.setUserLoggedIn(true);
                                SharedPrefs.setUserId(response.user!.id!);
                                SharedPrefs.setUserFullName(
                                    response.user!.name!);
                                SharedPrefs.setUserEmail(response.user!.email!);
                                SharedPrefs.setNotificationCheck(
                                    (response.user!.notify == 0)
                                        ? false
                                        : true);

                                name = response.user!.name!;
                                email = response.user!.email!;

                                Fluttertoast.showToast(
                                  msg: "Login Success", // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.SNACKBAR, // location
                                  // duration
                                );

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (Route<dynamic> route) => false);
                              }

                              setState(() {
                                isLoading = false;
                              });
                            });

                            // Navigator.pushReplacement(
                            //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 45),
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    image: AssetImage(
                                      'images/bg_btn.jpeg',
                                    ),
                                    fit: BoxFit.fill)),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()),
                            );
                          },
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 40.0),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        const Text(
                          "Login With",
                          style:
                              TextStyle(color: Color(0xFFE5Ed6B), fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Image.asset(
                                'images/fb.png',
                                width: 40,
                                height: 40,
                              ),
                              onTap: () {
                                SocialLogin().facebookLogin(context);
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                SocialLogin().googleLogin(context);
                              },
                              child: Image.asset(
                                'images/google.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            if (Platform.isIOS) ...[
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  SocialLogin().appleLogin();
                                },
                                child: Image.asset(
                                  'images/apple.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have and account? ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text(
                                "Signup",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
            ],
          ),
        ));
  }
}
