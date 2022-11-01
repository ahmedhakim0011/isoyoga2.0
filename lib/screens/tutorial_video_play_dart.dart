import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:video_player/video_player.dart';

import '../model/tutorial_model.dart';

class TutorialVideoPlay extends StatefulWidget {
  const TutorialVideoPlay(this.tutorial, {Key? key}) : super(key: key);
  final Tutorials tutorial;

  @override
  State<TutorialVideoPlay> createState() => _TutorialVideoPlayState();
}

class _TutorialVideoPlayState extends State<TutorialVideoPlay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.tutorial.videoLink ?? '')
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Tutorial Details",
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _controller.value.isInitialized
                ? Container(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.tutorial.name}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Text(
              "Description",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Html(
              data: '${widget.tutorial.description}',
              style: {
                "body": Style(color: Colors.white),
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
