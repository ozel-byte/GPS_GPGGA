import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gps/src/models/gps.dart';
import 'package:gps/src/views/view_map.dart';

class ViewLocationList extends StatefulWidget {
  const ViewLocationList({Key? key}) : super(key: key);

  @override
  State<ViewLocationList> createState() => _ViewLocationListState();
}

class _ViewLocationListState extends State<ViewLocationList> {
  FilePickerResult? result;
  PlatformFile? file;
  bool status = false;
  LinkedHashMap<String, Gps> rutasNoRepetidas = LinkedHashMap();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Visualizacion de ruta",
            style: TextStyle(color: Color(0xff8b6641)),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: status == false
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 1,
                    height: size.height * 0.6,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/img2.png"))),
                  ),
                  TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 40)),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xfff9edd6))),
                      onPressed: () async {
                        pickedFile();
                      },
                      child: const Text("Buscar archivo txt",
                          style: TextStyle(
                            color: Color(0xff8b6641),
                          ))),
                ],
              ))
            : map());
  }

  //Esta funcion se encarga de leer el archivo txt y esperar la respuesta
  Widget map() {
    return FutureBuilder(
      future: readfile(),
      builder: (BuildContext context, AsyncSnapshot<List<Gps>> snapshot) {
        if (snapshot.hasData) {
          return ViewMap(
            gp: snapshot.data,
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xff25a789),
          ));
        }
      },
    );
  }

//Esta funcion se encarga de buscar el archivo en el sistema del telefono
  pickedFile() async {
    result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    file = result!.files.first;
    setState(() {});
    readfile();
  }

  //Este metodo se encarga de cargar el path del archivo que se seleciono
  Future<File> _localfile() async {
    return File(file!.path.toString());
  }

  //En esta funcion se empieza a leer cada linea del txt
  Future<List<Gps>> readfile() async {
    status = true;
    setState(() {});
    final file2 = await _localfile();
    List<Gps> gpslist = [];
    List<String> contens = await file2.readAsLines();
    if (contens.isNotEmpty) {
      for (var item in contens) {
        if (item.contains('\$GPGGA')) {
          //cortamos  cada linea del txt
          List<String> itemSplit = item.split(",");
          if (itemSplit[1] != "" &&
              itemSplit[2] != "" &&
              itemSplit[2] != "⸮⸮" &&
              itemSplit[3] != "" &&
              itemSplit[4] != "" &&
              itemSplit[4] != "⸮⸮" &&
              itemSplit[5] != "" &&
              itemSplit[6] != "") {
            //Guardamos los datos en la clase Gps
            gpslist.add(Gps(
                id: itemSplit[2] + itemSplit[4],
                hrs: itemSplit[1],
                latitud: itemSplit[2],
                oriLa: itemSplit[3],
                longitud: itemSplit[4],
                oriLo: itemSplit[5]));
          }
        }
      }
      verificarGpsRepetidos(gpslist);
      print("rutas ${gpslist.length}");
      return rutasNoRepetidas.values.toList();
    } else {
      return [];
    }
  }

  //verificamos los datos repetidos de las coordenadas
  void verificarGpsRepetidos(List<Gps> rutasCompletas) {
    for (var item in rutasCompletas) {
      rutasNoRepetidas.putIfAbsent(item.getid, () => item);
    }
    print("total sin repetidos ${rutasNoRepetidas.length}");
  }
}
