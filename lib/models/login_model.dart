//Criando a classe LoginRequestModel
class LoginRequestModel {
  final String username;
  final String password;

  //Construtor da classe LoginRequestModel
  LoginRequestModel({required this.username, required this.password});

  //Converte a instância de [LoginRequestModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

//Criando a classe LoginResponseModel
class LogiResponsenModel {
  final String token;

  //Construtor da classe LoginResponseModel
  LogiResponsenModel({required this.token});

  //Constrói uma instância de [NameProduct] a partir de um mapa JSON
  factory LogiResponsenModel.fromJson(Map<String, dynamic> json) {
    return LogiResponsenModel(token: json['token']);
  }
  //Converte a instância de [LoginResponseModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}
