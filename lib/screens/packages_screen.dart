import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api_service.dart';
import '../db/shared_pref.dart';
import '../models/YogaPackagesResponse.dart';
import '../utils.dart';
import 'order_confirmed.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  YogaPackagesResponse? yogaPackages;
  late APIService _apiService;
  int selectedindex = 0;
  late List<Widget> indicators;
  bool isLoading = false;
  String userId = "";
  String token = "";

  @override
  void initState() {
    SharedPrefs.getUserId().then((value) {
      if (value != null) userId = value.toString();
    });

    SharedPrefs.getUserToken().then((value) {
      if (value != null) {
        token = value;
      }
    });

    _apiService = new APIService();
    super.initState();
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
            "Packages",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    color: Colors.red,
                  )),
                ],
              )
            : futureBuilder());
  }

  Widget futureBuilder({bool hideLoader = false}) {
    return FutureBuilder<YogaPackagesResponse?>(
      future: getPackages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            yogaPackages = snapshot.data!;
            indicators = _buildPageIndicator(yogaPackages!.list.length);

            return Column(
              children: [
                Container(height: 500, child: _buildUI(yogaPackages)),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Swipe for more options",
                  style: TextStyle(color: Colors.white),
                )
              ],
            );
          }
        }

        if (hideLoader) {
          indicators = _buildPageIndicator(yogaPackages!.list.length);

          return Column(
            children: [
              _buildUI(yogaPackages),
              Row(
                  children: indicators.map((item) {
                return item;
              }).toList()),
              SizedBox(
                height: 20,
              ),
              Text(
                "Swipe for more options",
                style: TextStyle(color: Colors.white),
              )
            ],
          );
        } else {
          return Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.black, color: Colors.red)),
          );
        }
      },
    );
  }

  Future<YogaPackagesResponse?> getPackages() async {
    YogaPackagesResponse? model = new YogaPackagesResponse(list: []);

    String token = await SharedPrefs.getUserToken();

    model = await _apiService.getPackages(token);

    return model;
  }

  Widget _buildUI(YogaPackagesResponse? packages) {
    return Container(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PageView(
          children: [
            PageView.builder(
                pageSnapping: true,
                itemCount: packages!.list.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://yoga.voltronsol.com/storage/${packages.list[index].image}",
                            height: 300,
                            width: 300,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                    color: Colors.red),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "${packages.list[index].name}",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        Text(
                          "\$ ${packages.list[index].price}/${packages.list[index].frequency}",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   isLoading = true;
                            // });

                            _apiService
                                .enrollPackage(
                                    userId,
                                    packages.list[index].id,
                                    packages.list[index].frequency,
                                    "payment ref id",
                                    "payment details",
                                    packages.list[index].price,
                                    "",
                                    "",
                                    4,
                                    token)
                                .then((value) {
                              if (value) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => OrderConfirmed()),
                                    (Route<dynamic> route) => false);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please choose time slot!", // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.SNACKBAR);
                                // setState(() {
                                //   isLoading = false;
                                // });
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    image: AssetImage(
                                      'images/bg_btn.jpeg',
                                    ),
                                    fit: BoxFit.cover)),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ENROLL NOW",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ));
  }

  List<Widget> _buildPageIndicator(int length) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(i == selectedindex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: const Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.rectangle,
          color: isActive ? const Color(0XFF6BC4C9) : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}
