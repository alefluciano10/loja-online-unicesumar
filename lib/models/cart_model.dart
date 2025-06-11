import './../models/cart_product_model.dart';

//Criando a classe CartModel
class CartModel {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartProductModel> products;

  //Construtor da classe CartModel
  CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  //Constrói uma instância de [CartModel] a partir de um mapa JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      products: (json['products'] as List<dynamic>)
          .map((item) => CartProductModel.fromJson(item))
          .toList(),
    );
  }

  //Converte a instância de [CartModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}
