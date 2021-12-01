//Esta clase es el modelo donde se guarda cada parametro que se saca del archivo txt
class Gps {
  String id;
  String hrs;
  String latitud;
  String oriLa;
  String longitud;
  String oriLo;

  Gps(
      {required this.id,
      required this.hrs,
      required this.latitud,
      required this.oriLa,
      required this.longitud,
      required this.oriLo});

  String get gethrs {
    String hrs = this.hrs.substring(0, 2);
    String min = this.hrs.substring(2, 4);
    String seg = this.hrs.substring(4, this.hrs.length);
    return "$hrs : $min : $seg";
  }

  String get getLatitud {
    String digito1 = latitud.substring(0, 2);
    String digito2 = latitud.substring(2, latitud.length);
    double la = double.parse(digito1) + (double.parse(digito2) / 60);
    return la.toString();
  }

  String lat() {
    return latitud;
  }

  String lng() {
    return longitud;
  }

  String get getLongitud {
    String digito1 = longitud.substring(0, 3);
    String digito2 = longitud.substring(3, longitud.length);
    double lo = (double.parse(digito1) + (double.parse(digito2) / 60)) * -1;
    return lo.toString();
  }

  String get getOriLa {
    return oriLa;
  }

  String get getid => id;

  String get getOriLo {
    return oriLo;
  }
}
