import 'dart:convert';
import 'package:http/http.dart' as http;
import './../common/common.dart';
import './../models/models.dart';

class CartService {
  /*
    Este método fetchCarts realiza uma requisição HTTP GET para obter todos os 
    carrinhos da API. Retorna uma lista de objetos CartModel em caso de 
    sucesso (status 200). Caso contrário, lança uma exceção com o código de 
    status da resposta.
  */

  Future<List<CartModel>> fetchCarts() async {
    final response = await http.get(Uri.parse('${HttpBase.baseURL}/carts'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CartModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar os carrinhos: ${response.statusCode}');
    }
  }

  /*
    Este método fetchCartById busca um carrinho específico na API com base no 
    ID fornecido. Se a resposta for bem-sucedida (status 200), os dados JSON 
    são convertidos em um CartModel. Caso contrário, lança uma exceção com o 
    código de erro e o ID do carrinho consultado.
  */

  Future<CartModel> fetchCartById(int id) async {
    final response = await http.get(Uri.parse('${HttpBase.baseURL}/carts/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CartModel.fromJson(data);
    } else {
      throw Exception(
        'Erro ao buscar o carrinho pelo id: $id - Status Code: ${response.statusCode}',
      );
    }
  }
}
