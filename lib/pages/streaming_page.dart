import 'dart:convert';

import 'package:dronelink_desktop/classes/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:socket_io/src/namespace.dart';

class StreamingPage extends StatefulWidget {
  StreamingPage({key, this.uri, required this.nsp}) : super(key: key);
  String? uri;
  final Namespace nsp;

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  Player player =
      Player(id: 69420, videoDimensions: const VideoDimensions(640, 480));
  MediaType mediaType = MediaType.network;
  late Telemetry telemetry = Telemetry(
      pitch: -1,
      roll: -1,
      yaw: -1,
      altitude: -1,
      longitude: -1,
      latitude: -1,
      speed: -1);
  bool isTelemetryVisible = false;
  @override
  void initState() {
    _telemetryInit();
    player.open(
      Media.network(widget.uri),
      autoStart: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _reatlTimeVLC(context),
        _telemetry(context),
        IconButton(
          icon: const Icon(Icons.wifi),
          onPressed: () {
            setState(() {
              isTelemetryVisible = !isTelemetryVisible;
            });
          },
        )
      ]),
    );
  }

  Widget _reatlTimeVLC(BuildContext context) {
    return Scaffold(
      body: Video(
        player: player,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        scale: 1.0, // default
        showControls: false, // default
      ),
    );
  }

  void _telemetryInit() {
    widget.nsp.on('connection', (client) {
      print('connection /telemetry');
      client.on('msg', (data) {
        print('data from /telemetry => $data');
        setState(() {
          String telemetry_s = data.toString();
          telemetry = Telemetry.fromJson(jsonDecode(telemetry_s));
        });
      });
    });
  }

  _telemetry(BuildContext context) {
    if (telemetry.altitude < 0) {
      return Visibility(
          visible: isTelemetryVisible,
          child: Container(
              color: const Color.fromARGB(255, 43, 41, 40),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                      child: Container(
                          child: Text("Telemetría no disponible"))))));
    } else {
      return Visibility(
        visible: isTelemetryVisible,
        child: Container(
          color: const Color.fromARGB(255, 43, 41, 40),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(
                child: Container(
              child: Column(
                children: [
                  Text("Pitch: " + telemetry.pitch.toString()),
                  Text("Roll " + telemetry.roll.toString()),
                  Text("Altitude" + telemetry.altitude.toString()),
                  Text("Speed" + telemetry.speed.toString()),
                  Text("Latitude" + telemetry.latitude.toString()),
                  Text("Longitude: " + telemetry.longitude.toString())
                ],
              ),
            )),
          ),
        ),
      );
    }
  }
}
