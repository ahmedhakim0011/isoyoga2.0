import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/cart_request_model.dart';
import '../models/cart_response_model.dart';
import '../provider/cart_provider.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;

import 'order_confirmed.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem?> items = [];
  bool isLoading = false;
  // final _stripePayment = FlutterStripePayment();
  late String paymentMethodId;

  Future<dynamic> createPaymentIntent(
      String amount, String currency, String paymentId) async {
    try {
      Map<String, dynamic> body = {
        'amount': int.parse(amount.toString()).toString(),
        'currency': currency,
        'payment_method': paymentId,
        'confirm': 'true',
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${clientKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

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

  // void StripePayment() async {
  //   var paymentResponse = await _stripePayment.addPaymentMethod();

  //   if (paymentResponse.status == PaymentResponseStatus.succeeded) {
  //     paymentMethodId = paymentResponse.paymentMethodId.toString();

  //     createPaymentIntent(
  //             Provider.of<CartProvider>(context, listen: false)
  //                 .totalAmount.toInt().toString(),
  //             "USD",
  //             paymentMethodId)
  //         .then((IntentResponse) {
  //           print(IntentResponse.toString());
  //       ProcessPayment(IntentResponse['client_secret'],
  //           double.parse(IntentResponse['amount'].toString()), paymentMethodId);

  //       SharedPrefs.getUserToken().then((token) {
  //         SharedPrefs.getUserId().then((userId) {
  //           var orderProvider =
  //               Provider.of<CartProvider>(context, listen: false);

  //           orderProvider.createOrder(token, userId).then((response) {
  //             setState(() {
  //               isLoading = false;
  //             });
  //             Provider.of<CartProvider>(context, listen: false).clearCart();

  //             if (response.code == 200 || response.code == 201) {
  //               Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => OrderConfirmed()));
  //             } else {
  //               Fluttertoast.showToast(
  //                   msg: response.message,
  //                   toastLength: Toast.LENGTH_LONG,
  //                   textColor: Colors.red,
  //                   timeInSecForIosWeb: 1);

  //               setState(() {
  //                 isLoading = false;
  //               });
  //             }
  //           });
  //         });
  //       });
  //     });
  //   } else {
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
    //   setState(() {
    //     isLoading = false;
    //   });
    // };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items = Provider.of<CartProvider>(context, listen: true).CartItems;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            "Cart",
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ),
        body: isLoading
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
                children: [
                  Container(
                      height: 430,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        width: 70,
                                        height: 100,
                                        imageUrl:
                                            items[index]!.thumbnail!.toString(),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                                backgroundColor: Colors.black,
                                                color: Colors.red),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${items[index]!.productName}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            'Size : ${items[index]!.size}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            '\$${items[index]!.lineTotal.toString().replaceAll(RegexToRemoveZero, '')}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                        margin:
                                            EdgeInsets.only(top: 36, right: 16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Utils.showMessage(
                                                    context,
                                                    "Warning",
                                                    "Do you want to delete this item",
                                                    "Yes",
                                                    () {
                                                      Provider.of<CartProvider>(
                                                              context,
                                                              listen: false)
                                                          .RemoveItem(
                                                              items[index]!
                                                                  .productId!);

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    buttonText2: "No",
                                                    isConfirmationDialog: true,
                                                    onPressed2: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                              },
                                              child: Image.asset(
                                                "images/ic_close.png",
                                                width: 10,
                                                height: 10,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 80,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (items[index]!.qty >
                                                          1) {
                                                        setState(() {
                                                          items[index]!.qty--;
                                                          UpdateProduct(
                                                              items[index]!,
                                                              items[index]!
                                                                  .qty);
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 18,
                                                        height: 18,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.red,
                                                              width:
                                                                  1 // red as border color
                                                              ),
                                                        ),
                                                        child: Text(
                                                          '-',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ),
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Text(
                                                          '${items[index]!.qty}',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white))),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (items[index]!.qty <=
                                                          30) {
                                                        setState(() {
                                                          items[index]!.qty++;
                                                          UpdateProduct(
                                                              items[index]!,
                                                              items[index]!
                                                                  .qty);
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 18,
                                                      height: 18,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.red,
                                                            width:
                                                                1 // red as border color
                                                            ),
                                                      ),
                                                      child: Text(
                                                        '+',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )))
                              ],
                            );
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          "\$ ${Provider.of<CartProvider>(context, listen: false).totalAmount.toString().replaceAll(RegexToRemoveZero, '')}",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (items.length == 0 || items == null) {
                        Fluttertoast.showToast(
                            msg:
                                'Please add items in cart then pay your bill. Thanks',
                            toastLength: Toast.LENGTH_LONG,
                            textColor: Colors.red,
                            timeInSecForIosWeb: 1);

                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });
                      // StripePayment();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                              image: AssetImage(
                                'images/bg_btn.jpeg',
                              ),
                              fit: BoxFit.fill)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "PAY NOW",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  )
                ],
              ));
  }

  void UpdateProduct(CartItem product, int qty) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);

    var cartProducts = new CartProducts();

    cartProducts.productId = product.productId;
    cartProducts.productName = product.productName;
    cartProducts.price = (product.productRegularPrice);
    cartProducts.thumbnail = product.thumbnail.toString();
    cartProducts.quantity = qty;
    cartProducts.size = product.size;
    cartProducts.categoryId = (product.categoryId ?? 0);

    cartProvider.addToCartLocal(cartProducts, (value) {});
  }
}
