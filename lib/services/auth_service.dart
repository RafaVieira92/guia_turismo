import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String url = 'https://guia.liliaborges.com.br/api-docs';

  Future<Map<String, dynamic>> autenticar(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "senha": senha}),
      );
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Resposta inválida do servidor.');
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) return data;
        throw const FormatException('Dados de autenticação ausentes.');
      }
      if (response.statusCode >= 400 && response.statusCode < 500) {
        return <String, dynamic>{};
      }
      throw Exception(
        decoded['message']?.toString() ??
            'Falha ao autenticar (${response.statusCode}).',
      );
    } catch (e) {
      rethrow;
    }
  }
}
