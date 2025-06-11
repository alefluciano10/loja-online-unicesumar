//Criando a classe CartProductModel
class CartProductModel {
  final int productid;
  final int quantity;

  //Construtor da classe CartProductModel
  CartProductModel({required this.productid, required this.quantity});

  //Constrói uma instância de [CartProductModel] a partir de um mapa JSON
  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      productid: json['productid'],
      quantity: json['quantity'],
    );
  }

  //Converte a instância de [CartProductModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'productId': productid, 'quantity': quantity};
  }
}
