import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:yoga_app_main/screens/wellness_centre_product_detail.dart';

import '../api_service.dart';
import '../constants.dart';
import '../db/shared_pref.dart';
import '../models/ClassesResponseModel.dart';
import '../models/ProductCategoryResonse.dart';
import '../provider/cart_provider.dart';
import 'cart_screen.dart';

class WellnessCentreProductsScreen extends StatefulWidget {
  const WellnessCentreProductsScreen({Key? key}) : super(key: key);

  @override
  State<WellnessCentreProductsScreen> createState() =>
      _WellnessCentreProductsScreenState();
}

class _WellnessCentreProductsScreenState
    extends State<WellnessCentreProductsScreen> {
  late APIService _apiService;
  List<ProductCategoryResonse?> _productCategoryResonse = [];

  @override
  void initState() {
    _apiService = new APIService();
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
            title: const Text(
              "Wellness Centre",
              style: TextStyle(color: Colors.yellow, fontSize: 23),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Stack(
                    children: <Widget>[
                      Icon(Icons.shopping_cart),
                      Provider.of<CartProvider>(context, listen: true)
                                  .CartItems
                                  .length ==
                              0
                          ? Text("")
                          : Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .CartItems
                                      .length
                                      .toString(),
                                  style: TextStyle(
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
            ]),
        body: futureBuilder());
  }

  Future<List<ProductCategoryResonse?>> getProducts() async {
    List<ProductCategoryResonse?> modelList = [];

    String token = await SharedPrefs.getUserToken();

    modelList = await _apiService.getProducts(token);

    return modelList;
  }

  Widget _buildUI(List<ProductCategoryResonse?> productsWithcategories) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productsWithcategories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.all(30),
                            child: Text(
                                "${productsWithcategories[index]?.categoryName}",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.red))),
                        Container(
                            margin: EdgeInsets.all(16),
                            height: 170,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: productsWithcategories[index]!
                                    .products!
                                    .length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WellnessCentreProductDetailScreen(
                                                      product:
                                                          productsWithcategories[
                                                                      index]!
                                                                  .products![
                                                              position])));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.12),
                                            ),
                                            child: Text(" "),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.05),
                                                      width:
                                                          10 // red as border color
                                                      ),
                                                ),
                                                child: Container(
                                                    color: Colors.black,
                                                    alignment: Alignment.center,
                                                    child: CachedNetworkImage(
                                                      width: 70,
                                                      height: 100,
                                                      imageUrl: baseURL +
                                                          productsWithcategories[
                                                                  index]!
                                                              .products![
                                                                  position]
                                                              .image
                                                              .toString(),
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    )),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                color: Colors.transparent,
                                                child: Text(
                                                  '${productsWithcategories[index]!.products![position].name}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                color: Colors.transparent,
                                                child: Text(
                                                  '\$${productsWithcategories[index]!.products![position].price}',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget futureBuilder({bool hideLoader = false}) {
    return FutureBuilder<List<ProductCategoryResonse?>>(
      future: getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            _productCategoryResonse = snapshot.data!;
            return _buildUI(_productCategoryResonse);
          }
          //  Only commint for using static data when dynamic data thise uncommint
          // if (snapshot.hasData && snapshot.data.length <= 0) {
          //   return MessageHelper.customMessageTextWidget(Constants.levesfound);
          // } else if (!snapshot.hasData) {
          //   return MessageHelper.customMessageTextWidget(Constants.levesfound);
          // }
        }

        if (hideLoader) {
          return _buildUI(_productCategoryResonse);
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
  void dispose() {
    super.dispose();
  }
}
