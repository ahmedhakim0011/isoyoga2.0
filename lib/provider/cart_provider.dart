import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api_service.dart';
import '../models/OrderCreateServerResponse.dart';
import '../models/cart_request_model.dart';
import '../models/cart_response_model.dart';
import '../models/order_model.dart';
import '../models/table_product.dart';


class CartProvider with ChangeNotifier {
  late APIService _apiService;
  List<CartItem> _cartItems = [];
  List<ProductTable> _products = [];
  int _loyality_points = 0;
  int _wheel_count = 0;
  OrderModel orderModel = new OrderModel();

  bool _isOrderCreated = false;
  bool _isNewNotification = false;

  int get LoyalityPoints => _loyality_points;
  int get WheelCount => _wheel_count;

  List<CartItem?> get CartItems => _cartItems;
  List<ProductTable?> get Products => _products;

  double get TotalRecords => _cartItems.length.toDouble();
  double get totalAmount => (_cartItems != null && _cartItems.length > 0)
      ? (_cartItems
          .map<double>((e) => e.lineSubtotal!)
          .reduce((value, element) => value + element))
      : 0;

  bool get isOrderCreated => _isOrderCreated;
  bool get isNewNotification => _isNewNotification;

  CartProvider() {
    _apiService = new APIService();
    _cartItems = [];
  }

  void ResetStreams() {
    _apiService = new APIService();
    _cartItems = [];
  }


  void RemoveItem(int productId) {
    CartItem? isProductExist;

    // if (requestModel.products.length > 0) {
    _cartItems.forEach((element) {
      if (element.productId == productId) {
        isProductExist = element;
      }
    });

    if (isProductExist != null) {
      _cartItems.remove(isProductExist);
    }

    notifyListeners();
  }

  void addToCartLocal(CartProducts CartProduct, Function onCallback) async {
    _products = [];
    if (_cartItems == null) ResetStreams();

    _cartItems.forEach((element) {
      var product = new ProductTable(
        productId: element.productId.toString(),
        qty: element.qty.toString(),
        productName: element.productName.toString(),
        price: element.productRegularPrice.toString(),
        Image: element.thumbnail.toString(),
        size: element.size.toString(),

      );

      _products.add(product);
    });

    ProductTable? isProductExist;

    // if (requestModel.products.length > 0) {
    _products.forEach((element) {
      if (int.parse(element.productId ?? "") == CartProduct.productId) {
        isProductExist = element;
      }
    });

    if (isProductExist != null) {
      _products.remove(isProductExist);
    }

    _products.add(new ProductTable(
      productId: CartProduct.productId.toString(),
      qty: CartProduct.quantity.toString(),
      productName: CartProduct.productName.toString(),
      price: CartProduct.price.toString(),
      Image: CartProduct.thumbnail.toString(),
      size: CartProduct.size.toString(),
    ));

    _cartItems.clear();



    _products.forEach((element) {

      _cartItems.add(new CartItem(
        productId: int.parse(element.productId ?? "0"),
        productName: element.productName,
        productRegularPrice: double.parse(element.price ?? "0"),
        thumbnail: element.Image,
        size: element.size!,
        qty: int.parse(element.qty ?? "0"),
        lineTotal: (int.parse(element.qty ?? "0")) *
            (double.parse(element.price ?? "")),
        lineSubtotal: (int.parse(element.qty ?? "0")) *
            (double.parse(element.price ?? "")),
      ));
    });

    onCallback(_cartItems);
    notifyListeners();
  }





  Future<OrderCreateServerResponse> createOrder(
      String token,int userId) async {
    if (orderModel == null) orderModel = new OrderModel();

    orderModel.customerId = userId;
    orderModel.shippingCharges = 0;
    orderModel.comments = "";

    OrderCreateServerResponse response = new OrderCreateServerResponse();


    if (orderModel.lineItems == null) orderModel.lineItems = [];

    orderModel.lineItems!.clear();

    CartItems.forEach((element) {
      var lineItem = new LineItems(
        productId: element?.productId,
        quantity: element?.qty,
        categoryId: element?.categoryId,
        price: element?.productRegularPrice,
        subTotal: element?.lineSubtotal,
        productName: element?.productName,
      );

      orderModel.lineItems?.add(lineItem);
    });


    response = await _apiService.createOrder(orderModel,token);

    if (response.code == 200) {
      _isOrderCreated = true;
    }

    // new ProductTable().deleteAllProducts();
    //CartItems.clear();

    return response;
  }



  fetchCartItemsLocal() async {
    if (_cartItems == null) {
      ResetStreams();
    }

    ProductTable table = new ProductTable();
    table.fetchProducts().then((value) {
      if (value.length > 0) {
        value.forEach((element) {
          _cartItems.add(new CartItem(
            productId: int.parse(element.productId ?? "0"),
            productName: element.productName,
            productRegularPrice: double.parse(element.price ?? "0"),
            thumbnail: element.Image,
            qty: int.parse(element.qty ?? "0"),

            lineTotal: (int.parse(element.qty ?? "0")) *
                (double.parse(element.price ?? "")),
            lineSubtotal: (int.parse(element.qty ?? "0")) *
                (double.parse(element.price ?? "")),
          ));
        });
      }

      notifyListeners();
    });
  }

  clearCart(){
    CartItems.clear();
    notifyListeners();
  }
}
