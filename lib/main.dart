import 'package:band_name_app/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:band_name_app/pages/home.dart';
import 'pages/status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData( 
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: 'home',
        routes: {
          'home': (_) => const MyHomePage(),
          'status': (_) => const StatusPage(),
        }, 
      ),
    );
  }
}
