import 'dart:convert';
import 'package:http/http.dart' as http;
import './../models/models.dart';
import './../common/common.dart';

class ProductService {
  /*
  Este método fetchProducts realiza uma requisição HTTP GET para buscar uma 
  lista de produtos a partir da API. Caso a resposta seja bem-sucedida 
  (status code 200), os dados JSON retornados são convertidos em uma lista de 
  objetos ProductModel. Se a requisição falhar, uma exceção é lançada com o 
  código de erro da resposta.
*/
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse('${HttpBase.baseURL}/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar os produtos: ${response.statusCode}');
    }
  }

  /*
  Este método fetchProductById busca um produto específico na API com base no 
  ID fornecido. Ele realiza uma requisição HTTP GET para o endpoint 
  /products/{id}. Se a resposta for bem-sucedida (status code 200), os dados 
  JSON são convertidos em um objeto ProductModel. Caso contrário, uma exceção é 
  lançada com o código de erro retornado.
  */

  Future<ProductModel> fetchProductById(int id) async {
    final response = await http.get(
      Uri.parse('${HttpBase.baseURL}/products/$id'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception(
        'Erro ao buscar o produto pelo ID: $id - Status Code: ${response.statusCode}',
      );
    }
  }
}
