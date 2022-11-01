import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class LiveSessionFragment extends StatefulWidget {
  const LiveSessionFragment({Key? key}) : super(key: key);

  @override
  State<LiveSessionFragment> createState() => _LiveSessionFragmentState();
}

class _LiveSessionFragmentState extends State<LiveSessionFragment> {
  MobileScannerController cameraController = MobileScannerController();
  String result = "Result";
  bool isScanStart = false;
  String btnScanTitle = "Scan";

  @override
  void initState() {
    //''''''''
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/live_session.jpg"), fit: BoxFit.cover)),
    );
  }
}
