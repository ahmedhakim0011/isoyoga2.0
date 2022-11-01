import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'agora/live_streaming.dart';
import 'agora/newPayemnt.dart';

class LiveSessionPage extends StatefulWidget {
  const LiveSessionPage({Key? key}) : super(key: key);

  @override
  State<LiveSessionPage> createState() => _LiveSessionPageState();
}

class _LiveSessionPageState extends State<LiveSessionPage> {
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
            "Live Sessions ",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: _buildUI());
  }

  Widget _buildUI() {
    return LiveStreming();

    // const BroadcastPage(
    //   channelName: 'Testing',
    //   userName: 'James',
    //   isBroadcaster: true,
    //   uid: 0,
    // );
  }
}
