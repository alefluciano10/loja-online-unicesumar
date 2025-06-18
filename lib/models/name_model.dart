//Criando a classe NameModel
class NameModel {
  final String firstname;
  final String lastname;

  //Construtor da classe NameProduct
  NameModel({required this.firstname, required this.lastname});

  //Constrói uma instância de [NameProduct] a partir de um mapa JSON
  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(firstname: json['firstname'], lastname: json['lastname']);
  }

  //Converte a instância de [NameProduct] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'firstname': firstname, 'lastname': lastname};
  }
}
