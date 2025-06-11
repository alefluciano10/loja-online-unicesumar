//Criando a classe RatingModel
class RatingModel {
  final double rate;
  final int count;

  //Construtor da classe RatingModel
  RatingModel({required this.rate, required this.count});

  //Constrói uma instância de [RatingModel] a partir de um mapa JSON
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'],
    );
  }

  //Converte a instância de [RatingModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
