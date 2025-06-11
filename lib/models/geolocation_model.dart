//Criando a classe GeolocationModel
class GeolocationModel {
  final String lat; // Latitude
  final String long; //Longitude

  //Contrutor da classe GeolocationModel
  GeolocationModel({required this.lat, required this.long});

  //Constrói uma instância de [GeolocationModel] a partir de um mapa JSON
  factory GeolocationModel.fromJson(Map<String, dynamic> json) {
    return GeolocationModel(lat: json['lat'], long: json['long']);
  }

  //Converte a instância de [GeolocationModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'lat': lat, 'long': long};
  }
}
