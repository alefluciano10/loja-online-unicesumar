import './../models/models.dart';
import './../models/name_model.dart';

//Criando a classe UserModel
class UserModel {
  final int id;
  final String email;
  final String username;
  final String password;
  final NameModel name;
  final AddressModel address;
  final String phone;

  //Construtor da classe UserModel
  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
  });

  //Constrói uma instância de [UserModel] a partir de um mapa JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      name: NameModel.fromJson(json['name']),
      address: AddressModel.fromJson(json['address']),
      phone: json['phone'],
    );
  }

  //Converte a instância de [UserModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'name': name.toJson(),
      'address': address.toJson(),
      'phone': phone,
    };
  }
}
