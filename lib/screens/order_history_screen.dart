import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/order_history.dart';
import '../provider/cart_provider.dart';
import '../utils.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late APIService _apiService;
  OrderHistoryResponse _data = new OrderHistoryResponse();

  @override
  void initState() {
    _apiService = new APIService();
    super.initState();
  }

  Future<OrderHistoryResponse?> getOrderHistory() async {
    OrderHistoryResponse? model = new OrderHistoryResponse();

    String token = await SharedPrefs.getUserToken();

    model = await _apiService.getOrderHistory(token);

    return model;
  }

  Widget futureBuilder({bool hideLoader = false}) {
    return FutureBuilder<OrderHistoryResponse?>(
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
            "Order History",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: futureBuilder());
  }

  Widget _buildUI(OrderHistoryResponse data) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Past orders",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView(
            children: data.success!.map((order) {
              return Card(
                color: Colors.grey.withOpacity(0.2),
                elevation: 10,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 60,
                              width: 60,
                              child:
                                  Image.asset("images/img_wellness_main.png")),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            alignment: Alignment.bottomCenter,
                            width: 120,
                            child: Text(
                              getValue(order.orderProduct!),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Visibility(
                                visible: true,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Order # 00${order.id}",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  child: Text(
                                "Bill : \$${order.totalOrderAmount}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13),
                              )),
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

  String getValue(List<OrderProduct> products) {
    String productName = "";

    products.forEach((e) {
      productName += '${e.name},';
    });

    return productName;
  }
}
