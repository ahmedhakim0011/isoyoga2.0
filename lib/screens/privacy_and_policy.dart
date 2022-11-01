import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../api_service.dart';
import '../db/shared_pref.dart';
import '../models/ContentPagesResponse.dart';


class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  late APIService _apiService;
  ContentPagesResponse _data =  ContentPagesResponse();

  @override
  void initState() {
    _apiService =  APIService();
    super.initState();
  }

  Future<ContentPagesResponse?> getContentPages() async {
    ContentPagesResponse? model =  ContentPagesResponse();

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
            child:const Center(
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
          title:const Text(
            "Privacy Policy",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: futureBuilder());
  }

  Widget _buildUI(ContentPagesResponse data) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: HtmlWidget(data.success![0].body.toString(),
            textStyle: const TextStyle(color: Colors.white),),
        ));
  }
}
