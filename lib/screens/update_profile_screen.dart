import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/ProfileResponseModel.dart';
import '../models/order_history.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late APIService _apiService;
  late ProfileResponseModel? _data;
  bool isLoading = true;
  String avatarUrl = "";
  late XFile file;
  File? postServerFile;
  bool isImageReady = false;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  String token = "";
  String fcmToken = "";

  @override
  void initState() {
    super.initState();
    _apiService = new APIService();
    getProfile();
    SharedPrefs.getUserToken().then((value) {
      token = value;
    });

    SharedPrefs.getFirebaseToken().then((value) {
      fcmToken = value;
    });
  }

  void _choose() async {
    _picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        setState(() {
          file = value;
          isImageReady = true;
          postServerFile = File(file.path);
        });
      }
    });
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _upload() {
    if (file == null) return;

    // http.post(phpEndPoint, body: {
    //   "image": base64Image,
    //   "name": fileName,
    // }).then((res) {
    //   print(res.statusCode);
    // }).catchError((err) {
    //   print(err);
    // });
  }

  Future<ProfileResponseModel?> getProfile() async {
    String token = await SharedPrefs.getUserToken();

    _data = await _apiService.getUserProfile(token);

    setState(() {
      _nameController.value =
          new TextEditingValue(text: _data!.user.name.toString());
      _emailController.value =
          new TextEditingValue(text: _data!.user.email.toString());
      SharedPrefs.setUserAvatar(baseURL + _data!.user.avatar);

      avatarUrl = baseURL + _data!.user.avatar.replaceAll('//', '/');
      avatar = baseURL + _data!.user.avatar.replaceAll('//', '/');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: _buildUI(context));
  }

  Widget _buildUI(context) {
    return SingleChildScrollView(
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
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(children: [
                        isImageReady
                            ? Material(
                                shape: CircleBorder(),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.file(
                                  postServerFile!,
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                ))
                            : Material(
                                shape: CircleBorder(),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  avatar,
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                        Positioned.fill(
                            child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _choose();
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                      )),
                                )))
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
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
                        enabled: false,
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            disabledBorder: const UnderlineInputBorder(
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
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_nameController.text.length == 0) {
                          showToast("Please enter your name");
                          setState(() {
                            isLoading = false;
                          });

                          return;
                        }

                        if (_emailController.text.length == 0) {
                          showToast("Please enter your email address");
                          setState(() {
                            isLoading = false;
                          });

                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        _apiService
                            .updateProfile(
                                _nameController.text,
                                _emailController.text,
                                postServerFile,
                                token,
                                fcmToken)
                            .then((response) {
                          if (response != null) {
                            print(response.toJson().toString());
                            showToast("Profile Update Successfully");
                            SharedPrefs.setUserAvatar(
                                baseURL + response.user!.avatar!);
                            SharedPrefs.setUserLoggedIn(true);
                            SharedPrefs.setUserId(response.user!.id!);
                            SharedPrefs.setUserFullName(response.user!.name!);
                            SharedPrefs.setUserEmail(response.user!.email!);
                            SharedPrefs.setNotificationCheck(
                                (response.user!.notify == 0 ||
                                        response.user!.notify == null)
                                    ? false
                                    : true);
                            avatar = baseURL +
                                    response.user!.avatar!
                                        .replaceAll('//', '/') ??
                                '';
                            avatarUrl = baseURL +
                                    response.user!.avatar!
                                        .replaceAll('//', '/') ??
                                '';
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            showToast("Profile Update Failed!!!");
                            setState(() {
                              isLoading = false;
                            });
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
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(
                                image: AssetImage(
                                  'images/bg_btn.jpeg',
                                ),
                                fit: BoxFit.fill)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Update",
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
    );
  }

  String getValue(List<OrderProduct> products) {
    String productName = "";

    products.forEach((e) {
      productName += '${e.name},';
    });

    return productName;
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message, // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.SNACKBAR); // location
  }
}
