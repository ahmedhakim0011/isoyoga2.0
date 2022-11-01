import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api_service.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late APIService apiService;
  bool isLoading = false;
  TextEditingController _pController = TextEditingController();
  TextEditingController _cpController = TextEditingController();

  @override
  void initState() {
    apiService = APIService();
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
                  decoration: const BoxDecoration(
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
                      children: const [
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
                                  width: 120,
                                ))),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Create new Password",
                          style: TextStyle(
                              fontSize: 24, color: Colors.deepOrangeAccent),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextField(
                            controller: _pController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Enter new password',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextField(
                            controller: _cpController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Repeat new password',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    image: AssetImage(
                                      'images/bg_btn.jpeg',
                                    ),
                                    fit: BoxFit.fill)),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "CONTINUE",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ),
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
