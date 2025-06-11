//Criando a classe CategoryModel
class CategoryModel {
  final String name;
  final String? colorHex;
  final String? iconAsset;

  //Construtor da classe CategoryModel
  CategoryModel({required this.name, this.colorHex, this.iconAsset});

  //Constrói uma instância de [CategoryModel] a partir de um mapa JSON
  factory CategoryModel.fromJson(String categoryName) {
    return CategoryModel(name: categoryName);
  }

  //Converte a instância de [CategoryModel] em um mapa JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'colorHex': colorHex, 'iconAsset': iconAsset};
  }
}
