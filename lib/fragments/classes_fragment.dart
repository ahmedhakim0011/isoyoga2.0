import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../api_service.dart';
import '../db/shared_pref.dart';
import '../models/ClassesResponseModel.dart';
import '../screens/class_details.dart';

class ClasesFragment extends StatefulWidget {
  const ClasesFragment({Key? key}) : super(key: key);

  @override
  State<ClasesFragment> createState() => _ClasesFragmentState();
}

class _ClasesFragmentState extends State<ClasesFragment> {
  List<ClassesResponseModel?> yogaClasses = [];
  late APIService _apiService;

  @override
  void initState() {
    _apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }

  Widget futureBuilder({bool hideLoader = false}) {
    return FutureBuilder<List<ClassesResponseModel?>>(
      future: getClasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            yogaClasses = snapshot.data!;

            return _buildUI(yogaClasses);
          }
          //  Only commint for using static data when dynamic data thise uncommint
          // if (snapshot.hasData && snapshot.data.length <= 0) {
          //   return MessageHelper.customMessageTextWidget(Constants.levesfound);
          // } else if (!snapshot.hasData) {
          //   return MessageHelper.customMessageTextWidget(Constants.levesfound);
          // }
        }

        if (hideLoader) {
          return _buildUI(yogaClasses);
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

  Future<List<ClassesResponseModel?>> getClasses() async {
    List<ClassesResponseModel?> model = [];

    String token = await SharedPrefs.getUserToken();

    model = await _apiService.getClasses(token);

    return model;
  }

  Widget _buildUI(List<ClassesResponseModel?> yogaClasses) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 20, left: 20),
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
          children: yogaClasses
              .map((item) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClassDetails(
                                item!.name!,
                                item.details!,
                                item.image!,
                                item.id.toString(),
                                item.fee!,
                                item.yogaClassTiming!)),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  height: 160,
                                  width: double.infinity,
                                  imageUrl:
                                      "https://yoga.voltronsol.com/storage/${item!.image}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        backgroundColor: Colors.black,
                                        color: Colors.red),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )),
                          ],
                        ),
                        Text(
                          "${item.name}",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  ))
              .toList()),
    );
  }
}
