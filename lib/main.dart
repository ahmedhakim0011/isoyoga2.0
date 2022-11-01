import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yoga_app_main/provider/cart_provider.dart';
import 'package:yoga_app_main/screens/cart_screen.dart';
import 'package:yoga_app_main/screens/home_screen.dart';
import 'package:yoga_app_main/screens/splash_screen.dart';
import 'package:yoga_app_main/screens/wellness_centre_product_detail.dart';
import 'package:yoga_app_main/screens/wellness_centre_products.dart';

import 'constants.dart';
import 'db/DbProvider.dart';

late DbProvider dbProvider;
late Database db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  //factory db initlialize
  dbProvider = DbProvider();

  await dbProvider.init();
  db = dbProvider.getDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //CountryPicker countryPicker = CountryPicker();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    register();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: WellnessCentreProductsScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: WellnessCentreProductDetailScreen(
            product: null,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: CartPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: HomeScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: SplashScreen(),
        ),
      ],
      child: MaterialApp(
        title: 'Yoga App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: SplashScreen(),
      ),
    );
  }
}
