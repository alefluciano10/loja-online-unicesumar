import './../models/models.dart';

//Criando a classe AddressModel
class AddressModel {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeolocationModel geolication;

  //Construtor da classe AddressModel
  AddressModel({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolication,
  });

  //Constrói uma instância de [AddressModel] a partir de um mapa JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'],
      street: json['street'],
      number: json['number'],
      zipcode: json['zipcode'],
      geolication: GeolocationModel.fromJson(json['geolocation']),
    );
  }

  //Converte a instância de [AddressModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      'geolocation': geolication.toJson(),
    };
  }
}
