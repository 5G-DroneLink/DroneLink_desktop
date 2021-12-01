import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dronelink_desktop/classes/address.dart';
import 'package:dronelink_desktop/pages/streaming_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:socket_io/socket_io.dart';

class PairingPage extends StatefulWidget {
  const PairingPage({key}) : super(key: key);

  @override
  _PairingPageState createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  int port = 9003;
  InternetAddress? ip;
  bool isPaired = false;
  static const _charlist =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  late String token = getRandomString(8);
  var serverSocket = Server();

  @override
  void initState() {
    _initSocket();
    _initServer();
    _initServer().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Address websocket = Address(
        host: Platform.localHostname,
        ip: ip!.address,
        port: port,
        token: token);

    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Host: " + Platform.localHostname),
            Text("IP: " + ip!.address),
            Text("Puerto: " + port.toString()),
            Text("Token: " + token)
          ],
        ),
        SizedBox(
            width: 200,
            height: 200,
            child: QrImage(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                data: jsonEncode(websocket.toJson()))),
      ],
    ));
  }

  Future<void> _initServer() async {
    for (var interface in await NetworkInterface.list()) {
      if (interface.name == "wlxf07d68f5b67b") {
        print('== Interface: ${interface.name} ==');
        for (var addr in interface.addresses) {
          print(
              '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
          if (!addr.isLoopback && addr.type.name == "IPv4") {
            ip = addr;
            break;
          }
        }
      }
    }
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _charlist.codeUnitAt(_rnd.nextInt(_charlist.length))));

  void _initSocket() {
    var tmNsp = serverSocket.of('/telemetry');
    var nsp = serverSocket.of("/stream");
    nsp.on('connection', (client) {
      print('connection /stream');
      client.on('msg', (data) {
        print('data from /stream => $data');

        if (isPaired) {
          String uri = data.toString();
          print("streamming from $uri");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StreamingPage(uri: uri, nsp: tmNsp)));
        }
        client.emit('fromServer', "ok 2");
      });
    });

    serverSocket.on('connection', (client) {
      print('connection default namespace');
      client.emit('fromServer', "ok");

      client.on('msg', (data) {
        if (data.toString().contains(token) && !isPaired) {
          print("Pair OK!!");
          isPaired = true;
        }

        client.emit('fromServer', "ok");
      });
    });
    serverSocket.listen(port);
  }
}
