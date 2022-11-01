import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/ClassesResponseModel.dart';
import 'order_confirmed.dart';

class ClassDetails extends StatefulWidget {
  ClassDetails(this.name, this.details, this.image, this.classId, this.amount,
      this.timings);

  String name, image, details, classId, amount;
  List<YogaClassTiming> timings;
  @override
  State<ClassDetails> createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  Map<String, dynamic>? paymentIntentData;
  String _fromDateDisplay = "";
  String _fromTimeDisplay = "";
  String _toDateDisplay = "";
  String _toTimeDisplay = "";
  String _trueToDateSend = "";
  String _trueFromDateSend = "";
  String userId = "";
  String token = "";

  late String paymentMethodId;
  String _errorMessage = "";
  // final _stripePayment = FlutterStripePayment();
  var _isNativePayAvailable = false;

  bool isLoading = false;
  late YogaClassTiming dropdownValue;

  late APIService apiService;

  // Future<dynamic> createPaymentIntent(
  //     String amount, String currency, String paymentId) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': amount,
  //       'currency': currency,
  //       'payment_method': paymentId,
  //       'confirm': 'true',
  //       'payment_method_types[]': 'card'
  //     };
  //     var response = await http.post(
  //         Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //         body: body,
  //         headers: {
  //           'Authorization': 'Bearer ${clientKey}',
  //           'Content-Type': 'application/x-www-form-urlencoded'
  //         });
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     print('err charging user: ${err.toString()}');
  //   }
  // }

  // Future<void> ProcessPayment(
  //     String clientKey, double amount, dynamic paymentId) async {
  //   var intentResponse =
  //       await _stripePayment.confirmPaymentIntent(clientKey, paymentId, amount);

  //   if (intentResponse.status == PaymentResponseStatus.succeeded) {
  //     print(intentResponse);
  //     // _submitOrder();
  //   } else if (intentResponse.status == PaymentResponseStatus.failed) {
  //     print(intentResponse);
  //   } else {
  //     print(intentResponse);
  //   }

  //   //
  //   //
  //   //
  //   // _stripePayment.confirmPaymentIntent(
  //   //      clientKey, paymentId,amount).then((intentResponse){
  //   //
  //   //   if (intentResponse.status == PaymentResponseStatus.succeeded) {
  //   //     print(intentResponse);
  //   //   } else if (intentResponse.status == PaymentResponseStatus.failed) {
  //   //
  //   //     print(intentResponse);
  //   //   } else {
  //   //     print(intentResponse);
  //   //   }
  //   //  });
  // }

//---------------------------------------------------------------

  Future<dynamic> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent(
        widget.amount,
        "USD",
      ); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  style: ThemeMode.dark,
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'))
          .then((val) {
        // if (value != null) {
        //   if (value) {
        //     Navigator.of(context).pushAndRemoveUntil(
        //         MaterialPageRoute(builder: (context) => OrderConfirmed()),
        //         (Route<dynamic> route) => false);
        //   }
        //   setState(() {
        //     isLoading = false;
        //   });

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => OrderConfirmed()),
        //     (Route<dynamic> route) => false);
      });

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  Future displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());

        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());

        apiService
            .classBooking(
                userId,
                widget.classId,
                paymentIntentData!['id'],
                paymentIntentData!['payment_method'],
                jsonEncode(paymentIntentData),
                widget.amount,
                _trueFromDateSend,
                _trueToDateSend,
                _fromTimeDisplay,
                _toTimeDisplay,
                "4",
                token,
                dropdownValue.id)
            .then((value) {
          if (value != null) {
            if (value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => OrderConfirmed()),
                  (Route<dynamic> route) => false);
            }
            setState(() {
              isLoading = false;
            });
          }
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => OrderConfirmed()),
            (Route<dynamic> route) => false);

        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(builder: (context) => OrderConfirmed()),
        //           (Route<dynamic> route) => false);
        //       //  _stripePayment.confirmPaymentIntent(clientSecret, stripePaymentMethodId, amount)
        //     });
        //   } else {
        //     _errorMessage = paymentResponse.errorMessage.toString();
        //     setState(() {
        //       isLoading = false;
        //     });

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => OrderConfirmed()),
        //     (Route<dynamic> route) => false);

        // setState(() {
        //   isLoading = false;
        // });

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

//---------------------------

  // void StripePayment() async {
  //   var paymentResponse = await _stripePayment.addPaymentMethod();

  //   if (paymentResponse.status == PaymentResponseStatus.succeeded) {
  //     paymentMethodId = paymentResponse.paymentMethodId.toString();

  //     createPaymentIntent(widget.amount, "USD", paymentMethodId)
  //         .then((IntentResponse) {
  //       ProcessPayment(IntentResponse['client_secret'],
  //           double.parse(IntentResponse['amount'].toString()), paymentMethodId);

  //       apiService
  //           .classBooking(
  //               userId,
  //               widget.classId,
  //               IntentResponse['id'],
  //               IntentResponse['payment_method'],
  //               jsonEncode(IntentResponse),
  //               widget.amount,
  //               _trueFromDateSend,
  //               _trueToDateSend,
  //               _fromTimeDisplay,
  //               _toTimeDisplay,
  //               "4",
  //               token,
  //               dropdownValue.id)
  //           .then((value) {
  //         if (value != null) {
  //           if (value) {
  //             Navigator.of(context).pushAndRemoveUntil(
  //                 MaterialPageRoute(builder: (context) => OrderConfirmed()),
  //                 (Route<dynamic> route) => false);
  //           }
  //           setState(() {
  //             isLoading = false;
  //           });
  //         }
  //       });

  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => OrderConfirmed()),
  //           (Route<dynamic> route) => false);
  //       //  _stripePayment.confirmPaymentIntent(clientSecret, stripePaymentMethodId, amount)
  //     });
  //   } else {
  //     _errorMessage = paymentResponse.errorMessage.toString();
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    // _stripePayment.setStripeSettings(stripeKey);
    // _stripePayment.onCancel = () {
    //   print("the payment form was cancelled");
    // };

    dropdownValue =
        widget.timings.length > 0 ? widget.timings[0] : YogaClassTiming();
    SharedPrefs.getUserId().then((value) {
      if (value != null) userId = value.toString();
    });

    SharedPrefs.getUserToken().then((value) {
      if (value != null) {
        token = value;
      }
    });

    apiService = new APIService();
    _toDateDisplay = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().add(Duration(days: 1)))
        .toString();
    _trueToDateSend = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(Duration(days: 1)))
        .toString();

    _fromDateDisplay =
        DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();

    _trueFromDateSend =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    _fromTimeDisplay = new DateFormat.Hm().format(DateTime.now()).toString();

    _toTimeDisplay = new DateFormat.Hm()
        .format(DateTime.now().add(Duration(hours: 1)))
        .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "${widget.name}",
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.black, color: Colors.red))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: Image.network(
                              "https://yoga.voltronsol.com/storage/${widget.image}"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "Details",
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "${widget.details}",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickDateDialog(0);
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.all(10),
                        color: Colors.grey.withOpacity(0.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_fromDateDisplay}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickDateDialog(1);
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.all(10),
                        color: Colors.grey.withOpacity(0.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_toDateDisplay}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: false,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                          'images/bg_btn.jpeg',
                        ))),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "SELECT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "Time",
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(10),
                      color: Colors.grey.withOpacity(0.2),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<YogaClassTiming>(
                          dropdownColor: Colors.black,
                          value: dropdownValue,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, wordSpacing: 70),
                          onChanged: (YogaClassTiming? newValue) {
                            print(newValue);
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: widget.timings
                              .map<DropdownMenuItem<YogaClassTiming>>(
                                  (YogaClassTiming value) {
                            return DropdownMenuItem<YogaClassTiming>(
                              value: value,
                              child: Text(
                                '${value.fromTime} - ${value.toTime}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.all(10),
                          color: Colors.grey.withOpacity(0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    _pickTimePickerDialog(0);
                                  },
                                  child: Text(
                                    "${_fromTimeDisplay}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                              Text(
                                "-",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _pickTimePickerDialog(1);
                                  },
                                  child: Text(
                                    "${_toTimeDisplay}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    // CardField(
                    //   onCardChanged: (card) {
                    //     print(card);
                    //   },
                    // ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });

                        if (dropdownValue == null) {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Please choose time slot!", // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.SNACKBAR);
                          return;
                        }

                        makePayment();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Pay Now",
                            style: TextStyle(color: Colors.red, fontSize: 30),
                          )),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  void _pickTimePickerDialog(int valueMode) {
    showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.red, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.white, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    ).then((pickedTime) {
      //then usually do the future job
      if (pickedTime == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        var time = DateTime.now();
        time = new DateTime(time.year, time.month, time.day, pickedTime.hour,
            pickedTime.minute, 0, 0, 0);

        if (valueMode == 0) {
          _fromTimeDisplay = new DateFormat.Hm().format(time).toString();
        } else if (valueMode == 1) {
          _toTimeDisplay = new DateFormat.Hm().format(time).toString();
        }
      });
    });
  }

  void _pickDateDialog(int valueMode) {
    showDatePicker(
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.red, // <-- SEE HERE
                    onPrimary: Colors.white, // <-- SEE HERE
                    onSurface: Colors.black, // <-- SEE HERE
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      primary: Colors.red, // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            },
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime.now(),
            //what will be the previous supported year in picker
            lastDate: DateTime.now().add(Duration(
                days: 60))) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        if (valueMode == 0) {
          _fromDateDisplay =
              DateFormat('MM/dd/yyyy').format(pickedDate).toString();

          _trueFromDateSend =
              DateFormat('yyyy-MM-dd').format(pickedDate).toString();
        } else if (valueMode == 1) {
          _toDateDisplay =
              DateFormat('MM/dd/yyyy').format(pickedDate).toString();

          _trueToDateSend =
              DateFormat('yyyy-MM-dd').format(pickedDate).toString();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
