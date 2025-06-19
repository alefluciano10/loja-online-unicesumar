import './../models/models.dart';

//Criando a classe BannerModel
class BannerModel {
  final int id;
  final String title;
  final double price;
  final String imageURL;

  //Construtor da classe BannerModel
  BannerModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageURL,
  });

  //Constrói uma instância de [BannerModel] a partir do ProductModel
  factory BannerModel.fromProduct(ProductModel product) {
    return BannerModel(
      id: product.id,
      title: product.title,
      price: product.price,
      imageURL: product.image,
    );
  }

  //Constrói uma instância de [BannerModel] a partir de um mapa JSON
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      imageURL: json['image'],
    );
  }

  //Converte a instância de [BannerModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'price': price, 'image': imageURL};
  }
}
