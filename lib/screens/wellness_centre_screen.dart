import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:yoga_app_main/screens/wellness_centre_products.dart';

class WellnessCentreScreen extends StatefulWidget {
  const WellnessCentreScreen({Key? key}) : super(key: key);

  @override
  State<WellnessCentreScreen> createState() => _WellnessCentreScreenState();
}

class _WellnessCentreScreenState extends State<WellnessCentreScreen> {
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
        title: const Text(
          "Wellness Centre",
          style: TextStyle(color: Colors.red, fontSize: 23),
        ),
      ),
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(30),
                child: const Text("Explore Juices \n     You Love!",
                    style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset(
                "images/img_wellness_main.png",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const WellnessCentreProductsScreen()));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                        image: AssetImage(
                          'images/bg_btn.jpeg',
                        ),
                        fit: BoxFit.fill)),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "images/right_arrow_black.png",
                      height: 20,
                      width: 30,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
