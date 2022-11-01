import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../api_service.dart';
import '../db/shared_pref.dart';

class AttendanceFragment extends StatefulWidget {
  const AttendanceFragment({Key? key}) : super(key: key);

  @override
  State<AttendanceFragment> createState() => _AttendanceFragmentState();
}

class _AttendanceFragmentState extends State<AttendanceFragment> {
  String result = "Result";
  bool isScanStart = false;
  String btnScanTitle = "Scan";
  late APIService _apiService;
  MobileScanner? _scanner;
  bool isLoading = false;
  String token = "";

  @override
  void initState() {
    _apiService = new APIService();

    SharedPrefs.getUserToken().then((value) {
      token = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg_login.jpeg"), fit: BoxFit.fill)),
      child: isLoading
          ? Column(
              children: [
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Scan the QR Code, to mark your attendance",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: getView(isScanStart)),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "${result}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 14,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isScanStart = !isScanStart;
                      btnScanTitle = isScanStart ? "Stop Scan" : "Scan";
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    alignment: Alignment.center,
                    height: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/bg_btn.jpeg"))),
                    child: Text(
                      "${btnScanTitle}",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget getView(bool value) {
    if (value) {
      MobileScannerController cameraController = MobileScannerController();

      _scanner = MobileScanner(
          allowDuplicates: false,
          controller: cameraController,
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;

              if (code.toString().contains('class_id=')) {
                setState(() {
                  isLoading = true;
                  isScanStart = false;
                });
                _apiService
                    .markAttendance(code.replaceAll('class_id=', ''), token)
                    .then((value) {
                  if (value) {
                    setState(() {
                      isLoading = false;
                      isScanStart = false;
                      btnScanTitle = "Stop Scan";
                    });

                    Fluttertoast.showToast(
                        msg: 'Attendance marked successfully!',
                        toastLength: Toast.LENGTH_LONG,
                        textColor: Colors.red,
                        timeInSecForIosWeb: 1);
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            'Unable to mark attendance. Please make sure you have class today!',
                        toastLength: Toast.LENGTH_LONG,
                        textColor: Colors.red,
                        timeInSecForIosWeb: 1);

                    setState(() {
                      isLoading = false;
                    });
                  }
                });
              } else {
                result = 'not found';
              }

              debugPrint('Barcode found! $code');
            }
          });

      return _scanner!;
    } else {
      return Image.asset("images/attendance.png");
    }
  }
}
