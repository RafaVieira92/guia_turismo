import 'dart:convert';
import 'package:guia_turismo/models/lugares_model.dart';
import 'package:http/http.dart' as http;

class LugaresService {
  final String url = 'https://guiaturismo.onrender.com/lugares';
  int pagina = 1;
  int limite = 10;

  Future<List<LugaresModel>> buscarLugares() async {
    try {
      final response = await http.get(
        Uri.parse('$url?pagina=$pagina&limite=$limite'),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Falha ao carregar os lugares (${response.statusCode}).',
        );
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Resposta inválida do servidor.');
      }
      final data = decoded['data'];
      if (data is! List) {
        throw const FormatException('Lista de lugares ausente na resposta.');
      }

      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Um item da lista de lugares é inválido.');
        }
        return LugaresModel.fromJson(item);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar os lugares: $e');
    }
  }

  Future<String> cadastrarLugar(LugaresModel dados, String token) async {
    if (token.isEmpty) {
      return 'Token de autenticação não fornecido.';
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(dados.toJson()),
      );

      final decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Resposta inválida do servidor.');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          decoded['message']?.toString() ??
              'Falha ao cadastrar o lugar (${response.statusCode}).',
        );
      }
      return decoded['message']?.toString() ?? 'Lugar cadastrado com sucesso.';
    } catch (e) {
      throw Exception('Erro ao cadastrar o lugar: $e');
    }
  }
}
