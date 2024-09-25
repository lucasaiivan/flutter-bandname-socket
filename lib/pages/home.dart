
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';
import '../services/socket_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  // var 
  List<Band> list = [];

  @override
  void initState() {
    
    final socketService = Provider.of<SocketService>(context, listen: false);
    // on : obtenemos la lista de datos
    socketService.socket.on('active-bands', _handleActiveBands );
    super.initState();
  }

  _handleActiveBands( dynamic payload ) {
    list = (payload as List)
        .map( (band) => Band.fromMap(band) )
        .toList();

    setState(() {});
  }
  @override
  void dispose() { 
    final socketServicesStatus = Provider.of<SocketService>(context,listen: false);
    socketServicesStatus.socket.off('active-bands');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

 
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,title: const Text('BandNames'),elevation:1,
        actions: [
          socketService.online?const Row(
            children: [
              Icon(Icons.brightness_1_rounded,size: 10,color: Colors.green),
              SizedBox(width:3),
              Text('Online',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
            ],
          ):const Row(
            children: [
              Icon(Icons.brightness_1_rounded,size: 10,color: Colors.red),
              SizedBox(width:3),
              Text('Offline',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
            ],
          ),  
          const SizedBox(width:8),
          ],
        ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => bandTile(band: list[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bandTile({required Band band }){

    final socketService = Provider.of<SocketService>(context,listen: false);

    return Dismissible(
      key: Key(band.id),
      background: Container(color: Colors.red.shade200,padding: const EdgeInsets.all(12),child: const Align(alignment: Alignment.centerLeft,child: Text('Delete band',style: TextStyle(color: Colors.white),),),),
      onDismissed: (direction) {
        deleteBand( band:band);
      },
      child: ListTile(
        leading: CircleAvatar(child: Text(band.name.substring(0,2))),
        title: Text(band.name),
        trailing: Text(band.votes.toString()),
        onTap: (){
          socketService.socket.emit('vote-band',{'id':band.id,'name':band.name});
        },
      ),
    );
  }
  void addNewBand(){
    final textFieldController = TextEditingController();
    showDialog(
      context: context,
      builder: (_){
        return AlertDialog(
          title: const Text('New band name:'),
          content: TextField(controller: textFieldController,decoration: const InputDecoration(hintText: 'band')),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancelar')),
            TextButton(onPressed: (){addBandToList(name: textFieldController.text);}, child: const Text('Agregar')),
          ],
        );
      }
    );
  }
  void addBandToList({required String name}){
    final socketService = Provider.of<SocketService>(context,listen: false);
    if(name.isNotEmpty){
      socketService.socket.emit('add-band',{'name':name});
    } 
    Navigator.pop(context);
  }
  void deleteBand({ required Band band }){
    final socketService = Provider.of<SocketService>(context,listen: false);
    if(band.id.isNotEmpty){
      socketService.socket.emit('delete-band',{'id':band.id,'name':band.name});
    }
  }
}