import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../fragments/attendance_fragment.dart';
import '../models/ContentPagesResponse.dart';
import '../models/order_history.dart';
import '../provider/cart_provider.dart';
import '../utils.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
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
          title: Text(
            "Attendance",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: _buildUI());
  }

  Widget _buildUI() {
    return Container(child: AttendanceFragment());
  }
}
