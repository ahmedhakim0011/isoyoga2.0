import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app_main/api_service.dart';

import '../db/shared_pref.dart';
import '../model/tutorial_model.dart';
import '../screens/tutorial_video_play_dart.dart';

class TutorialFragment extends StatefulWidget {
  const TutorialFragment({Key? key}) : super(key: key);

  @override
  State<TutorialFragment> createState() => _TutorialFragmentState();
}

class _TutorialFragmentState extends State<TutorialFragment> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<String> imgList = [
    'images/slider_1.png',
    'images/slider_2.png',
    'images/slider_3.png',
    'images/slider_4.png',
  ];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    getTutorials();
    super.initState();
  }

  List<TutorialModel>? tutorials;

  getTutorials() async {
    setState(() {
      loading = true;
    });
    String token = await SharedPrefs.getUserToken();
    tutorials = await APIService().getTutorials(token);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 30, bottom: 10),
                        child: Image.asset(
                          "images/tutorial_slider_bg.jpg",
                          width: MediaQuery.of(context).size.width - 20,
                          fit: BoxFit.fill,
                        )),
                    Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            item,
                          ),
                        )),
                  ],
                ),
              ),
            ))
        .toList();

    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                height: 230,
                autoPlay: true,
                viewportFraction: 1,
                aspectRatio: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 25,
          ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          ...List.generate(tutorials?.length ?? 0, (superIndex) {
            if (tutorials![superIndex].tutorials!.isNotEmpty) {
              return Column(
                children: [
                  Text(
                    "${tutorials?[superIndex].categoryName}",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 120,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        Tutorials tut =
                            tutorials![superIndex].tutorials![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TutorialVideoPlay(tut)),
                            );
                          },
                          child: Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      child: Image.asset(
                                        "images/img_tutorial1.jpg",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${tut.name}",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: EdgeInsets.only(bottom: 45),
                                      child: Image.asset(
                                        "images/play_btn.png",
                                        width: 20,
                                        height: 20,
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: tutorials?[superIndex].tutorials?.length ?? 0,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }
}
