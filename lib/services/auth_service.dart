import 'dart:convert';
import 'package:http/http.dart' as http;
import './../common/common.dart';
import './../models/models.dart';

class AuthService {
  /*
Este método login realiza uma requisição HTTP POST para autenticar um usuário.
Envia os dados de login (usuário/senha) no corpo da requisição em formato JSON.
Retorna um objeto LogiResponsenModel com os dados da resposta em caso de 
sucesso (status 200). Caso contrário, lança uma exceção informando erro de 
autenticação junto com o status da resposta.
*/

  Future<LogiResponsenModel> login(LogiResponsenModel request) async {
    final response = await http.post(
      Uri.parse('${HttpBase.baseURL}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return LogiResponsenModel.fromJson(data);
    } else {
      throw Exception(
        'Erro no login: Usuário ou senha está incorreta, Status Code: ${response.statusCode}',
      );
    }
  }
}
