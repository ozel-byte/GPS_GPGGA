import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:gps/src/models/gps.dart';

class ViewMap extends StatefulWidget {
  final List<Gps>? gp;
  const ViewMap({Key? key, this.gp}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  String token = "";

  MapboxMapController? controller_map;
  final rng = new Random();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width * 1,
            height: size.height * 1,
            child: MapboxMap(
              accessToken: token,
              styleString: "",
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                zoom: 14.5,
                target: LatLng(double.parse(widget.gp![0].getLatitud),
                    double.parse(widget.gp![0].getLongitud)),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: Container(
                width: size.width * 1,
                height: size.height * 0.25,
                child: generarListData(size)),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
              backgroundColor: Color(0xffe9f3f0),
              heroTag: 'btn3',
              onPressed: () {
                controller_map!.animateCamera(CameraUpdate.zoomIn());
              },
              child: const Icon(
                Icons.zoom_in,
                color: Color(0xff25a789),
              )),
          FloatingActionButton(
              backgroundColor: Color(0xffe9f3f0),
              heroTag: 'btn4',
              onPressed: () {
                controller_map!.animateCamera(CameraUpdate.zoomOut());
              },
              child: Icon(Icons.zoom_out, color: Color(0xff25a789))),
          FloatingActionButton(
            backgroundColor: Color(0xffe9f3f0),
            heroTag: 'btn1',
            onPressed: () {
              controller_map!.animateCamera(CameraUpdate.bearingTo(70));
            },
            child: Icon(Icons.view_array_outlined, color: Color(0xff25a789)),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMapController con) async {
    controller_map = con;
    controller_map!.animateCamera(CameraUpdate.tiltTo(80));

    crearRuta();
  }

//Este metodo se encarga de generar la lista de las tarjetas de lat y lng y hrs
  Widget generarListData(Size size) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.gp!.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Color(0xffe9f3f0),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://picsum.photos/200/300?random=${rng.nextInt(2000)}"))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Latitud",
                        style: TextStyle(color: Color(0xff25a789)),
                      ),
                      Text(widget.gp![index].getLatitud),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Longitud",
                        style: TextStyle(color: Color(0xff25a789)),
                      ),
                      Text(widget.gp![index].getLongitud),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hora",
                        style: TextStyle(color: Color(0xff25a789)),
                      ),
                      Text(widget.gp![index].gethrs)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//Este metodo se encarga de trazar la ruta y dibujarla en el mapa
  void crearRuta() {
    List<LatLng> ruta = [];

    if (widget.gp!.isNotEmpty) {
      final gp = widget.gp;
      if (gp != null) {
        for (var item in gp) {
          ruta.add(LatLng(
              double.parse(item.getLatitud), double.parse(item.getLongitud)));
        }
      }

      controller_map!.addLine(
          LineOptions(lineWidth: 3.0, lineColor: "blue", geometry: ruta));
      controller_map!.addSymbol(SymbolOptions(
          iconImage: "mar",
          textField: "inicio",
          textOffset: Offset(0, 1),
          geometry: LatLng(double.parse(widget.gp![0].getLatitud),
              double.parse(widget.gp![0].getLongitud))));
      controller_map!.addSymbol(SymbolOptions(
          iconImage: "mar",
          textField: "final",
          textOffset: Offset(0, 1),
          geometry: LatLng(
              double.parse(widget.gp![(widget.gp!.length) - 1].getLatitud),
              double.parse(widget.gp![(widget.gp!.length) - 1].getLongitud))));
    } else {
      print(widget.gp);
    }
  }
}
