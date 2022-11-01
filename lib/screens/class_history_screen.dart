import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/ClassesBookingHistoryResponse.dart';
import '../models/order_history.dart';
import '../provider/cart_provider.dart';
import '../utils.dart';

class ClassHistoryPage extends StatefulWidget {
  const ClassHistoryPage({Key? key}) : super(key: key);

  @override
  State<ClassHistoryPage> createState() => _ClassHistoryPageState();
}

class _ClassHistoryPageState extends State<ClassHistoryPage> {
  late APIService _apiService;
  List<ClassBookingHistoryResponse?> _data = [];

  @override
  void initState() {
    _apiService = new APIService();
    super.initState();
  }

  Future<List<ClassBookingHistoryResponse?>> getOrderHistory() async {
    List<ClassBookingHistoryResponse?> model = [];

    String token = await SharedPrefs.getUserToken();

    model = await _apiService.getClassBookingHistory(token);

    return model;
  }

  Widget futureBuilder({bool hideLoader = false}) {
    return FutureBuilder<List<ClassBookingHistoryResponse?>>(
      future: getOrderHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            _data = snapshot.data!;

            return _buildUI(_data);
          }
        }

        if (hideLoader) {
          return _buildUI(_data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            "Class Details",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: futureBuilder());
  }

  Widget _buildUI(List<ClassBookingHistoryResponse?> data) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Booking(s)",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView(
            children: data.map((history) {
              return Card(
                color: Colors.grey.withOpacity(0.2),
                elevation: 10,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              height: 60,
                              child: CachedNetworkImage(
                                height: 60,
                                imageUrl:
                                    baseURL + history!.classImage.toString(),
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                        backgroundColor: Colors.black,
                                        color: Colors.red),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: 50,
                                child: Text(
                                  'Date  ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                child: Text(
                                  'Timings  ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                child: const Text(
                                  'Fees  ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  '${getValue(history.fromDate.toString())} - ${getValue(history.toDate.toString())}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  '${history.fromTime} - ${history.toTime}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  '${history.classFee}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  String getValue(String date) {
    var formatter = new DateFormat('yyyy-MM-dd');

    var dateObj = formatter.parse(date);

    return '${dateObj.day}/${dateObj.month}/${dateObj.year}';
  }
}
