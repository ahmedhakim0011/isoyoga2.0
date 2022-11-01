import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';
import '../models/ProductCategoryResonse.dart';
import '../models/cart_request_model.dart';
import '../provider/cart_provider.dart';
import 'cart_screen.dart';

class WellnessCentreProductDetailScreen extends StatefulWidget {
  WellnessCentreProductDetailScreen({this.product});

  Products? product;

  @override
  State<WellnessCentreProductDetailScreen> createState() =>
      _WellnessCentreProductDetailScreenState();
}

class _WellnessCentreProductDetailScreenState
    extends State<WellnessCentreProductDetailScreen> {
  int qty = 1;

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
          "Product Details",
          style: TextStyle(color: Colors.red, fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Stack(
                children: <Widget>[
                  new Icon(Icons.shopping_cart),
                  Provider.of<CartProvider>(context, listen: true)
                              .CartItems
                              .length ==
                          0
                      ? Text("")
                      : new Positioned(
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: new Text(
                              Provider.of<CartProvider>(context, listen: false)
                                  .CartItems
                                  .length
                                  .toString(),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 220,
                  width: 220,
                  child: CachedNetworkImage(
                    imageUrl: baseURL + widget.product!.image.toString(),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                            backgroundColor: Colors.black, color: Colors.red),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.product!.name}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.red),
                          ),
                          Text(
                            'Size : ${widget.product!.size}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        '\$${widget.product!.price}',
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (qty > 1) {
                                setState(() {
                                  qty--;
                                });
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.red,
                                      width: 1 // red as border color
                                      ),
                                ),
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('${qty}',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white))),
                          GestureDetector(
                            onTap: () {
                              if (qty <= 30) {
                                setState(() {
                                  qty++;
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.red,
                                    width: 1 // red as border color
                                    ),
                              ),
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.product!.description}",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);

                    var cartProducts = new CartProducts();

                    cartProducts.productId = widget.product!.id;
                    cartProducts.productName = widget.product!.name;
                    cartProducts.price =
                        double.parse(widget.product!.price ?? "0");
                    cartProducts.thumbnail =
                        baseURL + widget.product!.image.toString();
                    cartProducts.quantity = qty;
                    cartProducts.size = widget.product!.size;
                    cartProducts.categoryId =
                        int.parse(widget.product!.categoryId ?? "0");

                    cartProvider.addToCartLocal(cartProducts, (value) {
                      Fluttertoast.showToast(
                          msg: "Product Added to Cart Successfully",
                          textColor: Colors.red,
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 1);

                      Navigator.of(context).pop();
                      // Provider.of<LoaderProvider>(context, listen: false)
                      //     .setLoadingStatus(false);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
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
                          "ADD TO CART",
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
