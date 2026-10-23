import 'package:flutter/material.dart';
import 'package:guia_turismo/models/lugares_model.dart';
import 'package:guia_turismo/services/lugares_service.dart';
import 'package:guia_turismo/services/session_service.dart';

class LugaresController extends ChangeNotifier {
  bool carregando = false;
  String erro = '';

  List<LugaresModel> _lugares = [];
  List<LugaresModel> get lugares => _lugares;

  Future<void> listarLugares() async {
    carregando = true;
    erro = '';
    notifyListeners(); 

    try {
      final lugaresService = LugaresService();
      _lugares = await lugaresService.buscarLugares();
    } catch (e) {
      erro = 'Erro ao carregar os lugares: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  // cadastrar novo lugar
  Future<String> cadastrarLugar(LugaresModel dados) async {
    final token = await SessionService().pegarToken() ?? ''; 
    carregando = true;
    erro = '';
    notifyListeners();
    try {
      final lugaresService = LugaresService();
      final resposta = await lugaresService.cadastrarLugar(dados, token);
      return resposta;
    } catch (e) {
      erro = 'Erro ao cadastrar o lugar: $e';
      return erro;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}