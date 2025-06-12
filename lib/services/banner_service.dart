import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import './../common/common.dart';
import './../models/models.dart';

class BannerService {
  /*
  Este método fetchBanners simula a obtenção de banners promocionais a partir 
  de produtos.

  - Realiza uma requisição HTTP GET no endpoint /products para obter a lista 
  completa de produtos.
  - Embaralha a lista usando Random().
  - Seleciona até [maxBanners] produtos aleatoriamente.
  - Transforma os produtos selecionados em objetos BannerModel contendo apenas 
  as informações relevantes para exibição de banners.

  Caso a requisição falhe, lança uma exceção com o código de status da resposta.
  */

  Future<List<BannerModel>> fetchBanners({int maxBanners = 5}) async {
    final response = await http.get(Uri.parse('${HttpBase.baseURL}/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<ProductModel> products = data
          .map((json) => ProductModel.fromJson(json))
          .toList();
      products.shuffle(Random());
      final selectedProducts = products.take(maxBanners).toList();

      return selectedProducts.map((product) {
        return BannerModel(
          id: product.id,
          title: product.title,
          price: product.price,
          imageURL: product.image,
        );
      }).toList();
    } else {
      throw Exception(
        'Erro ao buscar os produtos pelo banner: ${response.statusCode}',
      );
    }
  }
}
