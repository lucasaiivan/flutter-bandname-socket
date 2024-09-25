
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {

    final _socketServicesStatus = Provider.of<SocketService>(context);


    return Scaffold(
      appBar: AppBar(centerTitle: true,title: const Text('Status Server'),),
      body: Column(
        children: [
          Text('Conectado ${_socketServicesStatus.serverStatus}'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: (){
          _socketServicesStatus.socket.emit('emitir-mensaje',{'nombre':'lucas','mensaje':'hola desde Flutter!!!'});
        },
      ),
    );
  }
}