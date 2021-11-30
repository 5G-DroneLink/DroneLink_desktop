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
    return Scaffold(body: _reatlTimeVLC(context));
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
          String telemetry = data.toString();
        });
      });
    });
  }
}
