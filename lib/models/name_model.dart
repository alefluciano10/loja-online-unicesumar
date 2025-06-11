//Criando a classe NameModel
class NameModel {
  final String firstname;
  final String lastanme;

  //Construtor da classe NameProduct
  NameModel({required this.firstname, required this.lastanme});

  //Constrói uma instância de [NameProduct] a partir de um mapa JSON
  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(firstname: json['firstname'], lastanme: json['lastname']);
  }

  //Converte a instância de [NameProduct] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'firstname': firstname, 'lastname': lastanme};
  }
}
