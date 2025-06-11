import 'models.dart';

//Criando a classe ProductModel
class ProductModel {
  final int? id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  //Construtor da classe ProductModel
  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  //Constrói uma instância de [ProductModel] a partir de um mapa JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: RatingModel.fromJson(json['rating']),
    );
  }

  //Converte a instância de [ProductModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'Rating': rating.toJson(),
    };
  }
}
