import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/LoginResponseModel.dart';
import '../screens/home_screen.dart';

class SocialLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.email != null) {
        log(credential.email.toString());
        log(credential.userIdentifier.toString());
        // SocialLoginRepository().login("apple",
        //     token: credential.userIdentifier.toString(),
        //     email: credential.email,
        //     name: credential.givenName);
      } else {
        Fluttertoast.showToast(
            msg: "The login was unsuccessful, please try again",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red,
            timeInSecForIosWeb: 1);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.red,
          timeInSecForIosWeb: 1);
    }
  }

  googleLogin(context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser != null) {
      log(googleUser.id);
      log(googleUser.email);
      log(googleUser.displayName!);

      try {
        var dio = new Dio();
        String fcm_token = '';
        String token = await SharedPrefs.getUserToken();
        SharedPrefs.getFirebaseToken().then((value) {
          fcm_token = value;
        });
        dio.options.headers["Authorization"] = "Bearer ${token}";
        var formData = FormData.fromMap({
          'email': googleUser.email,
          'name': googleUser.displayName,
          'token': googleUser.id,
          'fcm_token': fcm_token,
          'type': 'google',
        });

        var model = await dio.post(APIService().baseURL + 'social-login',
            data: formData);
        LoginResponseModel response = LoginResponseModel.fromJson(model.data);
        print(model.data);
        if (model.statusCode == 200) {
          SharedPrefs.setUserToken(response.accessToken!);
          SharedPrefs.setUserAvatar(baseURL + response.user!.avatar!);
          SharedPrefs.setUserLoggedIn(true);
          SharedPrefs.setUserId(response.user!.id!);
          SharedPrefs.setUserFullName(response.user!.name!);
          SharedPrefs.setUserEmail(response.user!.email!);
          SharedPrefs.setNotificationCheck(
              (response.user!.notify == 0) ? false : true);

          name = response.user!.name!;
          email = response.user!.email!;

          Fluttertoast.showToast(
            msg: "Login Success", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.SNACKBAR, // location
          );

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        } else {
          Fluttertoast.showToast(
              msg: "Something is wrong",
              toastLength: Toast.LENGTH_LONG,
              textColor: Colors.red,
              timeInSecForIosWeb: 1);
        }
      } on DioError catch (e) {
        print(e.message);
      }
    }
  }

  Future<void> googleSignOut({BuildContext? context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Utils.showToast(message: 'Error signing out. Try again.');
    }
  }

  facebookSignout() async {
    await FacebookAuth.instance.logOut();
  }

  facebookLogin(context) async {
    // try {
    final LoginResult r = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );
    AccessToken result = r.accessToken!;
    if (result.isExpired == false) {
      log(result.userId);
      final userData = await FacebookAuth.instance.getUserData();
      log(userData['email']);
      try {
        var dio = new Dio();
        String fcm_token = '';
        String token = await SharedPrefs.getUserToken();
        SharedPrefs.getFirebaseToken().then((value) {
          fcm_token = value;
        });
        dio.options.headers["Authorization"] = "Bearer ${token}";
        print({
          'email': userData["email"],
          'name': userData["name"],
          'token': userData["id"],
          'fcm_token': fcm_token,
          'type': 'facebook',
        });
        var formData = FormData.fromMap({
          'email': userData["email"],
          'name': userData["name"],
          'token': userData["id"],
          'fcm_token': fcm_token,
          'type': 'facebook',
        });

        var model = await dio.post(APIService().baseURL + 'social-login',
            data: formData);
        LoginResponseModel response = LoginResponseModel.fromJson(model.data);
        print(model.data);
        if (model.statusCode == 200) {
          SharedPrefs.setUserToken(response.accessToken!);
          SharedPrefs.setUserAvatar(baseURL + response.user!.avatar!);
          SharedPrefs.setUserLoggedIn(true);
          SharedPrefs.setUserId(response.user!.id!);
          SharedPrefs.setUserFullName(response.user!.name!);
          SharedPrefs.setUserEmail(response.user!.email!);
          SharedPrefs.setNotificationCheck(
              (response.user!.notify == 0) ? false : true);

          name = response.user!.name!;
          email = response.user!.email!;

          Fluttertoast.showToast(
            msg: "Login Success", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.SNACKBAR, // location
          );

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        } else {
          Fluttertoast.showToast(
              msg: "Something is wrong",
              toastLength: Toast.LENGTH_LONG,
              textColor: Colors.red,
              timeInSecForIosWeb: 1);
        }
      } on DioError catch (e) {
        print(e.message);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Error connecting to facebook",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.red,
          timeInSecForIosWeb: 1);
    }
    // } catch (error) {
    //   Fluttertoast.showToast(
    //       msg: 'There was problem connecting to you facebook',
    //       toastLength: Toast.LENGTH_LONG,
    //       textColor: Colors.red,
    //       timeInSecForIosWeb: 1);
    //   log(error.toString());
    // }
  }
}
