import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import './../common/common.dart';
import './../models/models.dart';

class UserService {
  /*
    Este método fetch busca todos os usuários na API.
    Ele realiza uma requisição HTTP GET para o endpoint /users e retorna
    uma lista de objetos UserModel se a resposta for bem-sucedida (status 200).
    Caso contrário, lança uma exceção com o código de erro da resposta.
  */

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('${HttpBase.baseURL}/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar os usuários: ${response.statusCode}');
    }
  }

  /*
    Este método fetchUserById busca um usuário específico na API com base no 
    ID fornecido. Ele realiza uma requisição HTTP GET para /users/{id} e 
    retorna um objeto UserModel em caso de sucesso. Caso contrário, lança uma 
    exceção com o código de status.
  */

  Future<UserModel> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('${HttpBase.baseURL}/users/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception(
        'Erro ao buscar o usuário pelo ID: $id - Status Code: ${response.statusCode}',
      );
    }
  }
}
