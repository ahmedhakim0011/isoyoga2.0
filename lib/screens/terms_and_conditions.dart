import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/ContentPagesResponse.dart';
import '../models/order_history.dart';
import '../provider/cart_provider.dart';
import '../utils.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  late APIService _apiService;
  ContentPagesResponse _data = new ContentPagesResponse();

  @override
  void initState() {
    _apiService = new APIService();
    super.initState();
  }

  Future<ContentPagesResponse?> getContentPages() async {
    ContentPagesResponse? model = new ContentPagesResponse();

    String token = await SharedPrefs.getUserToken();

    model = await _apiService.getContentPages(token);

    return model;
  }

  Widget futureBuilder({bool hideLoader = false}) {
    return FutureBuilder<ContentPagesResponse?>(
      future: getContentPages(),
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
            "Terms and Conditions",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: futureBuilder());
  }

  Widget _buildUI(ContentPagesResponse data) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: HtmlWidget(
        data.success![1].body.toString(),
        textStyle: TextStyle(color: Colors.white),
      ),
    ));
  }
}
