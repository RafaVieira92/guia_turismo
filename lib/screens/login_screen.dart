import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turismo/controllers/auth_controller.dart';
import 'package:guia_turismo/screens/lugares_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (context.read<AuthController>().carregando) return;
    if (!_formKey.currentState!.validate()) return;

    final autenticado = await context.read<AuthController>().autenticarUsuario(
      _emailController.text.trim(),
      _senhaController.text,
    );
    if (!mounted) return;
    if (autenticado) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LugaresScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carregando = context.watch<AuthController>().carregando;
    final erro = context.watch<AuthController>().erro;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF22D3EE).withValues(alpha: 0.08),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 72,
                          height: 72,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22D3EE)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0xFF22D3EE)
                                  .withValues(alpha: 0.28),
                            ),
                          ),
                          child: const Icon(
                            Icons.explore_rounded,
                            color: Color(0xFF22D3EE),
                            size: 38,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'ROTA CIANO',
                          style: TextStyle(
                            color: Color(0xFF22D3EE),
                            fontSize: 12,
                            letterSpacing: 2.8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Seu próximo lugar\nfavorito está por aqui.',
                          style: TextStyle(
                            color: Color(0xFFF1F5F9),
                            fontSize: 30,
                            height: 1.18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Entre para explorar destinos e compartilhar novos lugares.',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 34),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            hintText: 'voce@exemplo.com',
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) return 'Informe seu e-mail.';
                            if (!email.contains('@')) {
                              return 'Digite um e-mail válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: !_senhaVisivel,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => _entrar(),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              tooltip: _senhaVisivel
                                  ? 'Ocultar senha'
                                  : 'Mostrar senha',
                              onPressed: () => setState(() {
                                _senhaVisivel = !_senhaVisivel;
                              }),
                              icon: Icon(
                                _senhaVisivel
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                              ),
                            ),
                          ),
                          validator: (value) => (value?.isEmpty ?? true)
                              ? 'Informe sua senha.'
                              : null,
                        ),
                        if (erro.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFF6B6B)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              erro,
                              style: const TextStyle(color: Color(0xFFFF9B9B)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed: carregando ? null : _entrar,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF22D3EE),
                              foregroundColor: const Color(0xFF06232B),
                              disabledBackgroundColor: const Color(0xFF22D3EE)
                                  .withValues(alpha: 0.45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: carregando
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Color(0xFF06232B),
                                    ),
                                  )
                                : const Text(
                                    'Entrar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Center(
                          child: Text(
                            'Descubra. Salve. Compartilhe.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
