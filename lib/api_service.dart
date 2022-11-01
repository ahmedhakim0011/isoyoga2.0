import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

import 'package:yoga_app_main/screens/otp_screen.dart';
import 'constants.dart';
import 'model/tutorial_model.dart';
import 'models/ClassBookingResponse.dart';
import 'models/ClassesBookingHistoryResponse.dart';
import 'models/ClassesResponseModel.dart';
import 'models/ContentPagesResponse.dart';
import 'models/LoginResponseModel.dart';
import 'models/OrderCreateServerResponse.dart';
import 'models/ProductCategoryResonse.dart';
import 'models/ProfileResponseModel.dart';
import 'models/SignupResponseModel.dart';
import 'models/YogaPackagesResponse.dart';
import 'models/order_history.dart';
import 'models/order_model.dart';

const APP_ID = ""; // Enter the App ID in between the double quotes

class APIService {
  String baseURL = "https://yoga.voltronsol.com/api/";
  // String baseURL = "https://isoyoga.jumppace.com/api/";

  Future<List<ClassesResponseModel?>> getClasses(String token) async {
    List<ClassesResponseModel?> data = [];

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'yoga-class/list');

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map((e) => ClassesResponseModel.fromJson(e))
            .toList();
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return data;
  }

  Future<YogaPackagesResponse?> getPackages(String token) async {
    YogaPackagesResponse? data = new YogaPackagesResponse(list: []);

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'package/list');

      if (response.statusCode == 200) {
        data = YogaPackagesResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return data;
  }

  Future<List<TutorialModel>?> getTutorials(String token) async {
    List<TutorialModel> tutorials = [];
    print(token);
    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'tutorial/list');

      if (response.statusCode == 200) {
        log(response.data.toString());
        if (response.data != null) {
          response.data.forEach((v) {
            tutorials.add(TutorialModel.fromJson(v));
          });
        }
        return tutorials;
      }
    } on DioError catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<ContentPagesResponse?> getContentPages(String token) async {
    ContentPagesResponse? model = new ContentPagesResponse();

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'page/list');

      if (response.statusCode == 200) {
        model = ContentPagesResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return model;
  }

  Future<ProfileResponseModel?> getUserProfile(String token) async {
    ProfileResponseModel? model = new ProfileResponseModel();

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'profile');

      if (response.statusCode == 200) {
        model = ProfileResponseModel.fromJson(response.data);
        print(model);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return model;
  }

  Future<OrderHistoryResponse?> getOrderHistory(String token) async {
    OrderHistoryResponse? model = new OrderHistoryResponse();

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'order/history');

      if (response.statusCode == 200) {
        model = OrderHistoryResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return model;
  }

  Future<List<ClassBookingHistoryResponse?>> getClassBookingHistory(
      String token) async {
    List<ClassBookingHistoryResponse?> data = [];

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'yoga-class/booking-details');

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map((e) => ClassBookingHistoryResponse.fromJson(e))
            .toList();
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return data;
  }

  Future<List<ProductCategoryResonse?>> getProducts(String token) async {
    List<ProductCategoryResonse?> data = [];

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(baseURL + 'product/list');

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map((e) => ProductCategoryResonse.fromJson(e))
            .toList();
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return data;
  }

  Future<LoginResponseModel?> loginCustomer(
      context, String username, String password, String fcmToken) async {
    LoginResponseModel? model;

    try {
      var formData = FormData.fromMap(
          {'email': username, 'password': password, 'fcm_token': fcmToken});
      var response = await Dio().post(baseURL + 'login', data: formData);
      print(response);
      print(response.data['user']['id']);
      print(baseURL + 'login');
      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
        userId = response.data['user']['id'];
        print('user id =' + userId.toString());
      }
      return model;
    } on DioError catch (e) {
      if (e.response?.data['email'][0].contains("verified")) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OTPScreen(username)));
      } else {
        Fluttertoast.showToast(
          msg: "Username or Password is incorrect!", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.SNACKBAR, // location
          // duration
        );
      }
      return model;
    }
  }

  Future<bool?> classBooking(
      user_id,
      class_id,
      transaction_id,
      ref_id,
      payment_details,
      transaction_amount,
      from_date,
      to_date,
      from_time,
      to_time,
      status,
      token,
      class_timing_id) async {
    ClassBookingResponse? model;

    try {
      var formData = FormData.fromMap({
        'user_id': user_id,
        'class_id': class_id,
        'transaction_id': transaction_id,
        'ref_id': ref_id,
        'payment_details': payment_details,
        'transaction_amount': transaction_amount,
        'from_date': from_date,
        'to_date': to_date,
        'from_time': from_time,
        'to_time': to_time,
        'status': status,
        'class_timing_id': class_timing_id
      });

      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response =
          await dio.post(baseURL + 'yoga-class/booking', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return true;
  }

  Future<LoginResponseModel?> updateProfile(
      name, email, File? file, token, fcmToken) async {
    LoginResponseModel? model;
    print(token);

    try {
      FormData formData = FormData.fromMap(
          {'name': name, 'email': email, 'fcm_token': fcmToken});

      if (file != null) {
        String fileName = file.path.split('/').last;

        formData = FormData.fromMap({
          'name': name,
          'email': email,
          'fcm_token': fcmToken,
          'file': await MultipartFile.fromFile(file.path,
              filename: fileName, contentType: MediaType("image", "jpeg"))
        });
        print('file name' + fileName);
      }
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.post(baseURL + 'update-profile', data: formData);

      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return model;
  }

  Future<bool> enrollPackage(
    user_id,
    package_id,
    frequency,
    ref_id,
    payment_details,
    transaction_amount,
    from_date,
    to_date,
    status,
    token,
  ) async {
    try {
      var formData = FormData.fromMap({
        'user_id': user_id,
        'frequency': frequency,
        'ref_id': ref_id,
        'payment_details': payment_details,
        'transaction_amount': transaction_amount,
        'from_date': from_date,
        'to_date': to_date,
        'package_id': package_id,
        'status': status,
      });

      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response =
          await dio.post(baseURL + 'package/booking', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return true;
  }

  Future<bool> setNotificationCheck(bool check, String token) async {
    try {
      var formData = FormData.fromMap({
        'notify': check ? 1 : 0,
      });

      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.post(baseURL + 'is-user-notify', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return true;
  }

  Future<bool> markAttendance(String classId, String token) async {
    try {
      var formData = FormData.fromMap({
        'class_id': classId,
      });

      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response =
          await dio.post(baseURL + 'yoga-class/attendance', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return true;
  }

  Future<SignupResponseModel?> createCustomer(String name, String email,
      String password, String confirmPassword, String fcmToken) async {
    SignupResponseModel? model = new SignupResponseModel();

    try {
      var formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'fcm_token': fcmToken,
      });
      var response = await Dio().post(baseURL + 'register', data: formData);

      model = SignupResponseModel.fromJson(response.data);

      if (response.statusCode == 200) {
        model = SignupResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      Map<dynamic, dynamic> ErrorResponse = e.response?.data['error'];

      ErrorResponse.forEach((key, value) {
        model?.error = value[0];
      });

      print(e.message);
    }

    return model;
  }

  createOrder(OrderModel model, token) async {
    OrderCreateServerResponse createOrderResponse =
        new OrderCreateServerResponse();
    createOrderResponse.code = 500;
    createOrderResponse.message = "Failed";

    try {
      var dio = new Dio();
      dio.options.headers["Authorization"] = "Bearer ${token}";

      var response =
          await dio.post(baseURL + 'order/create', data: model.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        createOrderResponse.code = 200;
        createOrderResponse.message = "Order has been placed !";
        return createOrderResponse;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        // isOrderCreated = false;
      } else {
        //isOrderCreated = false;
      }

      return createOrderResponse;
    }
  }
}
