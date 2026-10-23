// import 'package:secure_shared_preferences/secure_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SessionService {
  static String nome = '';
  static String email = '';

  Future<String> pegarNome() async {
    final prefs = await SharedPreferences.getInstance();
    nome = prefs.getString('nome') ?? '';
    return nome;
  }

  Future<String> pegarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    return email;
  }

  Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> pegarToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('nome');
    nome = '';
    email = '';
  }

  Future<void> salvarUsuario(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user['email']?.toString() ?? '');
    await prefs.setString('nome', user['nome']?.toString() ?? '');
  }
}
