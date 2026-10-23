import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turismo/controllers/auth_controller.dart';
import 'package:guia_turismo/controllers/lugares_controller.dart';
import 'package:guia_turismo/models/lugares_model.dart';
import 'package:guia_turismo/screens/cadastrar_lugar_screen.dart';
import 'package:guia_turismo/screens/login_screen.dart';
import 'package:guia_turismo/services/session_service.dart';

class LugaresScreen extends StatefulWidget {
  const LugaresScreen({super.key});

  @override
  State<LugaresScreen> createState() => _LugaresScreenState();
}

class _LugaresScreenState extends State<LugaresScreen> {
  String _busca = '';
  late final Future<String> _nomeFuture;

  @override
  void initState() {
    super.initState();
    _nomeFuture = SessionService().pegarNome();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<LugaresController>().listarLugares();
    });
  }

  Future<void> _abrirCadastro() async {
    final cadastrado = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const CadastrarLugarScreen(),
      ),
    );
    if (!mounted) return;
    if (cadastrado == true) {
      await context.read<LugaresController>().listarLugares();
    }
  }

  Future<void> _sair() async {
    try {
      await context.read<AuthController>().deslogarUsuario();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível encerrar a sessão: $e')),
      );
    }
  }

  void _mostrarDetalhes(LugaresModel lugar) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111B24),
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lugar.nome,
                style: const TextStyle(
                  color: Color(0xFFF1F5F9),
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lugar.categoria?.isNotEmpty == true
                    ? lugar.categoria!
                    : 'Sem categoria',
                style: const TextStyle(color: Color(0xFF22D3EE)),
              ),
              if (lugar.descricao.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  lugar.descricao,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    size: 18,
                    color: Color(0xFF22D3EE),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${lugar.latitude.toStringAsFixed(5)}, '
                    '${lugar.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLugarCard(LugaresModel lugar) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF111B24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFF1E2C38)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _mostrarDetalhes(lugar),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF22D3EE),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lugar.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFF1F5F9),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lugar.categoria?.isNotEmpty == true
                          ? lugar.categoria!
                          : 'Sem categoria',
                      style: const TextStyle(
                        color: Color(0xFF22D3EE),
                        fontSize: 13,
                      ),
                    ),
                    if (lugar.descricao.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        lugar.descricao,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _estadoVazio({
    required IconData icone,
    required String titulo,
    required String mensagem,
    Widget? acao,
  }) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 320,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icone, color: const Color(0xFF22D3EE), size: 44),
                  const SizedBox(height: 16),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF1F5F9),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mensagem,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                  ),
                  if (acao != null) ...[
                    const SizedBox(height: 18),
                    acao,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LugaresController>();
    final lugaresFiltrados = controller.lugares.where((lugar) {
      final termo = _busca.trim().toLowerCase();
      return termo.isEmpty ||
          lugar.nome.toLowerCase().contains(termo) ||
          (lugar.categoria?.toLowerCase().contains(termo) ?? false);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.explore_rounded, color: Color(0xFF22D3EE), size: 24),
            SizedBox(width: 9),
            Text(
              'Rota Ciano',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair da conta',
            onPressed: _sair,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        backgroundColor: const Color(0xFF22D3EE),
        foregroundColor: const Color(0xFF06232B),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Novo lugar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: _nomeFuture,
                    builder: (context, snapshot) {
                      final nome = snapshot.data?.trim() ?? '';
                      return Text(
                        nome.isEmpty ? 'Descubra novos lugares' : 'Olá, $nome',
                        style: const TextStyle(
                          color: Color(0xFFF1F5F9),
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Inspire-se para a sua próxima aventura.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => setState(() => _busca = value),
                    decoration: const InputDecoration(
                      hintText: 'Buscar por lugar ou categoria',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Lugares para explorar',
                      style: TextStyle(
                        color: Color(0xFFF1F5F9),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${controller.lugares.length} locais',
                    style: const TextStyle(
                      color: Color(0xFF22D3EE),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (controller.erro.isNotEmpty && controller.lugares.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Material(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Color(0xFFFF9B9B),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.erro,
                            style: const TextStyle(
                              color: Color(0xFFFFB4B4),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Tentar novamente',
                          onPressed: controller.listarLugares,
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Color(0xFFFFB4B4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF22D3EE),
                backgroundColor: const Color(0xFF111B24),
                onRefresh: controller.listarLugares,
                child: controller.carregando && controller.lugares.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF22D3EE),
                        ),
                      )
                    : controller.erro.isNotEmpty && controller.lugares.isEmpty
                        ? _estadoVazio(
                            icone: Icons.cloud_off_rounded,
                            titulo: 'Não foi possível carregar',
                            mensagem: controller.erro,
                            acao: OutlinedButton.icon(
                              onPressed: controller.listarLugares,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Tentar novamente'),
                            ),
                          )
                        : lugaresFiltrados.isEmpty
                            ? _estadoVazio(
                                icone: _busca.isEmpty
                                    ? Icons.travel_explore_rounded
                                    : Icons.search_off_rounded,
                                titulo: _busca.isEmpty
                                    ? 'Ainda não há lugares'
                                    : 'Nenhum resultado',
                                mensagem: _busca.isEmpty
                                    ? 'Cadastre o primeiro destino e comece a montar seu guia.'
                                    : 'Tente buscar por outro nome ou categoria.',
                                acao: _busca.isEmpty
                                    ? OutlinedButton.icon(
                                        onPressed: _abrirCadastro,
                                        icon: const Icon(Icons.add_rounded),
                                        label: const Text('Adicionar lugar'),
                                      )
                                    : null,
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 100),
                                itemCount: lugaresFiltrados.length,
                                itemBuilder: (context, index) =>
                                    _buildLugarCard(lugaresFiltrados[index]),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
