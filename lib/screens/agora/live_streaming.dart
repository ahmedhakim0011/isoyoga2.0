import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:yoga_app_main/constants.dart';

const String appId = "bc95efaa65f848ecb6f6ead1967ee310";

class LiveStreming extends StatefulWidget {
  const LiveStreming({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LiveStreming> {
  String channelName = "c-id-2";
  String token =
      '006bc95efaa65f848ecb6f6ead1967ee310IAAEwCjpxiZHHx7B+FTPLZVuyjq8MS8FuzuLMFQ3p26PPvjn/ufl4DHFEAB3fpOyos1dYwEAAQAyilxj';
  int? uid; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool _isHost =
      false; // Indicates whether the user has joined as a host or audience
  bool? _isButtonDisabled;
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  @override
  void initState() {
    super.initState();
    getToken();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
  }

  getToken() async {
    //  final uri = Uri.parse('${apiGlobal}/relative/getSingleUser/1234');
    final uri = Uri.parse(
        'http://isoyoga.jumppace.com:3002/rtc/c-id-2/audience/uid/${userId}');
    print(uri);
    var request = http.MultipartRequest('GET', uri);
    var response = await request.send();
    final res = await http.Response.fromStream(response);
    var res_data = json.decode(res.body.toString());

    print("RESPONSE DATA " + res_data['rtcToken'].toString());
    token = res_data['rtcToken'].toString();
  }

  void buttonEnable() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    await agoraEngine.enableAudioVolumeIndication(
        interval: 250, smooth: 3, reportVad: true);

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;

    // Set channel profile and client role
    if (_isHost) {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        audienceLatencyLevel:
            AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      );
    }

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: userId,
    );
    // setState(() {
    //   _isJoined = true;
    // });
  }

  Future<void> leave() async {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    await agoraEngine.leaveChannel().then((value) {
      Navigator.pop(context);
    });
  }

// Clean up the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    await agoraEngine.release();
    super.dispose();
  }

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        key: scaffoldMessengerKey,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // Container for the local video
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              child: Center(child: _videoPanel()),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            )
            // Radio Buttons
            // Row(children: <Widget>[
            //   Radio<bool>(
            //     value: true,
            //     groupValue: _isHost,
            //     onChanged: (value) => _handleRadioValueChange(value),
            //   ),
            //   const Text('Host'),
            //   Radio<bool>(
            //     value: false,
            //     groupValue: _isHost,
            //     onChanged: (value) => _handleRadioValueChange(value),
            //   ),
            //   const Text('Audience'),
            // ]),

            ,
            // // Button Row
            Row(
              children: <Widget>[
                Expanded(
                    child: _isJoined
                        ? ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                            child: const Text("Join"),
                            onPressed: null,
                          )
                        : ElevatedButton(
                            child: const Text("join"),
                            onPressed: () => {join()},
                          )),
                const SizedBox(width: 10),
                Expanded(
                    child: !_isJoined
                        ? ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                            child: const Text("Leave"),
                            onPressed: null,
                          )
                        : ElevatedButton(
                            child: const Text("Leave"),
                            onPressed: () => {leave()},
                          )),
              ],
            ),
            // Button Row ends
          ],
        ));
  }

  Widget _videoPanel() {
    if (!_isJoined) {
      return const Text(
        'Join a channel',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );
    } else if (_isHost) {
      // Local user joined as a host
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      // Local user joined as audience
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channelName),
          ),
        );
      } else {
        return const Text(
          'Waiting for a host to join',
          textAlign: TextAlign.center,
        );
      }
    }
  }

// Set the client role when a radio button is selected
  void _handleRadioValueChange(bool? value) async {
    setState(() {
      _isHost = (value == true);
    });
    if (_isJoined) leave();
  }
}
