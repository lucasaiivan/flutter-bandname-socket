
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;


  enum ServerStatus{
    Online,
    Offline,
    Connecting,
  }

// ChangeNotifier : 
class SocketService with ChangeNotifier{
  

  late IO.Socket _socket;
  IO.Socket get socket => _socket;

  ServerStatus _serverStatus = ServerStatus.Connecting;
  ServerStatus get serverStatus => _serverStatus;
  bool get online => serverStatus == ServerStatus.Online;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    // Flutter client 192.168.1.45 lanus /192.168.0.12 liniers
    _socket = IO.io('https://flutter-socket-server-lb-fe0eb6a6be91.herokuapp.com/',{
      'transports':['websocket'],
      'autoConnect': true,
    });
    _socket.onConnect((_) {
      print('connect');
      _socket.emit('msg', 'test');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    }); 
    _socket.onDisconnect((_){
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });  
  }

}