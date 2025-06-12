import 'dart:convert';
import 'package:http/http.dart' as http;
import './../common/common.dart';

class CategoryService {
  Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${HttpBase.baseURL}/categories'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((cat) => cat.toString()).toList();
    } else {
      throw Exception('Erro ao buscar as categorias: ${response.statusCode}');
    }
  }
}
