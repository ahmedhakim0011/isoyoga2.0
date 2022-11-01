import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static void setFirebaseToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) {
      prefs.setString('token', token);
      // prefs.setString(Constants.sharedPrefUFirstName, user.displayName);
    }
  }

  static void setNotificationCheck(bool check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (check != null) {
      prefs.setBool('send_notification', check);
      // prefs.setString(Constants.sharedPrefUFirstName, user.displayName);
    }
  }

static void setUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) {
      prefs.setString('user_token', token);
      // prefs.setString(Constants.sharedPrefUFirstName, user.displayName);
    }
  }

  static void setUserAvatar(String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (avatar != null) {
      prefs.setString('user_avatar', avatar);

    }
  }



  static Future<String> getFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')??"";
    return token;
  }


  static Future<bool> getNotificationCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = prefs.getBool('send_notification')??false;
    return check;
  }

  static Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('user_token')??"";
    return token;
  }

static Future<String> getUserAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String avatar = prefs.getString('user_avatar')??"";
    return avatar;
  }



  static void setUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isUserLoggedIn != null) {
      prefs.setBool('isUserLoggedIn', isUserLoggedIn);
      // prefs.setString(Constants.sharedPrefUFirstName, user.displayName);
    }
  }
static void setUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      prefs.setInt('userId', userId);
    }
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserLoggedIn = prefs.getBool('isUserLoggedIn')??false;
    return isUserLoggedIn;
  }
  static void setUDID(String UDID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (UDID != null) {
      prefs.setString('UDID', UDID);
      // prefs.setString(Constants.sharedPrefUFirstName, user.displayName);
    }
  }

  static Future<String> getUDID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UDID = prefs.getString('UDID')??"";
    return UDID;
  }

   static Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId')??0;
    return userId;
  }



  static void setUserPhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (phoneNumber != null) {
      prefs.setString('phoneNumber', phoneNumber);
      // prefs.setString(Constants.sharedPrefUFirstName, user.displayName);
    }
  }

  static Future<String> getUserPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber = prefs.getString('phoneNumber')??"";
    return phoneNumber;
  }

  static Future<String> getUserFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString('fullName')??"";
    return fullName;
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email')??"";
    return email;
  }

  static void setUserFullName(String fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (fullName != null) {
      prefs.setString('fullName', fullName);
    }
  }


  static void setUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email != null) {
      prefs.setString('email', email);
    }
  }






}
