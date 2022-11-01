import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api_service.dart';
import '../db/shared_pref.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isAgreeToTerms = false;
  late APIService apiService;
  bool isLoading = false;
  String fcmToken = "";
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmpasswordController =
      new TextEditingController();

  @override
  void initState() {
    apiService = new APIService();
    SharedPrefs.getFirebaseToken().then((value) {
      fcmToken = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                margin: EdgeInsets.only(top: 40),
                                child: Image.asset(
                                  'images/logo.png',
                                  width: 80,
                                ))),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Signup",
                          style: TextStyle(
                              fontSize: 24, color: Colors.deepOrangeAccent),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: TextField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Name',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: TextField(
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: TextField(
                            controller: _passwordController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: TextField(
                            controller: _confirmpasswordController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Repeat Password',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        isLoading
                            ? CircularProgressIndicator(
                                color: Colors.red,
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (!_isAgreeToTerms) {
                                    showToast(
                                        "Please accept terms of Services and Privacy Policy!");

                                    return;
                                  }

                                  if (_nameController.text.length == 0) {
                                    showToast("Please enter your name");
                                    setState(() {
                                      isLoading = false;
                                    });

                                    return;
                                  }

                                  if (_emailController.text.length == 0) {
                                    showToast(
                                        "Please enter your email address");
                                    setState(() {
                                      isLoading = false;
                                    });

                                    return;
                                  }

                                  if (_passwordController.text.trim().length ==
                                          0 ||
                                      _confirmpasswordController.text
                                              .trim()
                                              .length ==
                                          0) {
                                    showToast(
                                        "Password and Confirm Password should not be empty!");
                                    setState(() {
                                      isLoading = false;
                                    });

                                    return;
                                  }

                                  if (_passwordController.text.trim() !=
                                      _confirmpasswordController.text.trim()) {
                                    showToast(
                                        "Password and Confirm Password should be same!");
                                    setState(() {
                                      isLoading = false;
                                    });

                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  apiService
                                      .createCustomer(
                                          _nameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                          _confirmpasswordController.text,
                                          fcmToken)
                                      .then((response) {
                                    if (response!.error.isNotEmpty) {
                                      showToast(response.error);
                                      setState(() {
                                        isLoading = false;
                                      });

                                      return;
                                    } else {
                                      showToast("Registration Success");
                                      setState(() {
                                        isLoading = false;
                                      });

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OTPScreen(
                                                  _emailController.text)));
                                    }
                                  });

                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 60),
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
                                        "SIGNUP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                              ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 20,
                                child: Checkbox(
                                  splashRadius: 10,
                                  value: _isAgreeToTerms,
                                  onChanged: (status) {
                                    setState(() {
                                      _isAgreeToTerms = status!;
                                    });
                                  },
                                  checkColor: Colors.white,
                                  focusColor: Colors.black,
                                  hoverColor: Colors.black,
                                  activeColor: Colors.black,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "I agree to the Terms of Services \n and privacy Policy",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text(
                                "Login",
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

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message, // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.SNACKBAR); // location
  }
}
