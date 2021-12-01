import 'package:flutter/material.dart';
import 'package:gps/src/views/view_list_location.dart';
import 'package:gps/src/views/view_map.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, initialRoute: '/',
        //Inicializa las rutas a utilizar
        routes: {
          '/': (BuildContext context) => ViewLocationList(),
          'view-map': (BuildContext context) => ViewMap()
        });
  }
}
