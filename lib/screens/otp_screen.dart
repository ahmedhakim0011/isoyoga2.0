import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/LoginResponseModel.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen(this.email, {Key? key}) : super(key: key);
  final String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late APIService apiService;
  bool isLoading = false;
  TextEditingController _otpController = TextEditingController();

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
                          "OTP",
                          style: TextStyle(
                              fontSize: 24, color: Colors.deepOrangeAccent),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        PinCodeTextField(
                          length: 4,
                          obscureText: true,
                          animationType: AnimationType.fade,
                          cursorColor: Colors.white,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.transparent,
                            activeColor: Colors.transparent,
                            inactiveColor: Colors.white,
                            fieldOuterPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            inactiveFillColor: Colors.transparent,
                            selectedFillColor: Colors.transparent,
                            selectedColor: Colors.white,
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          enableActiveFill: true,
                          controller: _otpController,
                          obscuringCharacter: '*',
                          textStyle: TextStyle(color: Colors.white),
                          mainAxisAlignment: MainAxisAlignment.center,
                          onCompleted: (v) async {
                            print("Completed");
                            try {
                              var formData = FormData.fromMap({
                                'otp': v,
                                'email': widget.email,
                                'device_type': "Android",
                              });
                              print({
                                'otp': v,
                                'email': widget.email,
                                'device_type': "Android",
                              });
                              var response = await Dio().post(
                                  APIService().baseURL + 'verify-otp',
                                  data: formData);

                              LoginResponseModel model =
                                  LoginResponseModel.fromJson(response.data);
                              SharedPrefs.setUserToken(model.accessToken!);
                              SharedPrefs.setUserAvatar(
                                  baseURL + model.user!.avatar!);
                              SharedPrefs.setUserLoggedIn(true);
                              SharedPrefs.setUserId(model.user!.id!);
                              SharedPrefs.setUserFullName(model.user!.name!);
                              SharedPrefs.setUserEmail(model.user!.email!);
                              SharedPrefs.setNotificationCheck(
                                  (model.user!.notify == 0) ? false : true);

                              name = model.user!.name!;
                              email = model.user!.email!;
                              Fluttertoast.showToast(
                                msg: "Login Success", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.SNACKBAR, // location
                              );

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                  (Route<dynamic> route) => false);
                            } on DioError catch (e) {
                              showToast(e.response?.data['error']);
                            }
                          },
                          onChanged: (value) {
                            print(value);
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                          appContext: context,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //           builder: (context) => const ChangePassword()),
                        //     );
                        //   },
                        //   child: Container(
                        //     margin: const EdgeInsets.symmetric(horizontal: 60),
                        //     width: MediaQuery.of(context).size.width,
                        //     height: 40,
                        //     decoration: const BoxDecoration(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(8)),
                        //         image: DecorationImage(
                        //             image: AssetImage(
                        //               'images/bg_btn.jpeg',
                        //             ),
                        //             fit: BoxFit.fill)),
                        //     child: const Align(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           "CONTINUE",
                        //           style: TextStyle(
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         )),
                        //   ),
                        // ),
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
