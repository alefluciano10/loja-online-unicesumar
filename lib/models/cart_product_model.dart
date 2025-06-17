//Criando a classe CartProductModel
class CartProductModel {
  final int productId;
  final String title;
  final double price;
  final int quantity;
  final String imageURL; // Adicionado para imagem do produto

  double get subtotal => quantity * price;

  //Construtor da classe CartProductModel
  CartProductModel({
    required this.title,
    required this.imageURL,
    required this.price,
    required this.productId,
    required this.quantity,
  });

  //Constrói uma instância de [CartProductModel] a partir de um mapa JSON
  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageURL: json['imageUrl'] ?? '',
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      productId: map['productId'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      imageURL: map['imageUrl'] as String,
    );
  }

  //Converte a instância de [CartProductModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageURL,
    };
  }
}
