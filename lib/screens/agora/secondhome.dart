import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class SecondHome extends StatefulWidget {
  const SecondHome({Key? key}) : super(key: key);

  @override
  State<SecondHome> createState() => _HomeState();
}

class _HomeState extends State<SecondHome> {
  static const platform = const MethodChannel('flutter.rortega.com.channel');

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin() async {
    if (_username.text.isEmpty || _channelName.text.isEmpty) {
      setState(() {
        check = 'Username and Channel Name are required fields';
      });
    } else {
      setState(() {
        check = '';
      });
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => Broadcast(
      //       userName: _username.text,
      //       channelName: _channelName.text,
      //       isBroadcaster: _isBroadcaster,
      //       uiddd: _uid.text,
      //     ),
      //   ),
      // );
    }
  }

  final _username = TextEditingController();
  final _channelName = TextEditingController();
  final _uid = TextEditingController();
  bool _isBroadcaster = false;
  String check = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'LIVE STREAMING',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  // height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.only(top: 20, right: 10, left: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.grey,
                          child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextFormField(
                              controller: _username,
                              decoration: const InputDecoration(
                                hintText: "Enter Name...",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 20,),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 20, right: 10, left: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.grey,
                          child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextFormField(
                              controller: _channelName,
                              decoration: const InputDecoration(
                                hintText: "Enter Channel Name...",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 20,),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 20, right: 10, left: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.grey,
                          child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextFormField(
                              controller: _uid,
                              decoration: const InputDecoration(
                                hintText: "Enter ID...",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SwitchListTile(
                      title: _isBroadcaster
                          ? const Text(
                              'Broadcaster',
                              style: TextStyle(color: Colors.white),
                            )
                          : const Text('Audience',
                              style: TextStyle(color: Colors.white)),
                      value: _isBroadcaster,
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.white,
                      inactiveThumbColor: Colors.white,
                      secondary: _isBroadcaster
                          ? const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                      onChanged: (value) {
                        setState(() {
                          _isBroadcaster = value;
                          print(_isBroadcaster);
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MaterialButton(
                      onPressed: onJoin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Join ',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  check,
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
