import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turismo/controllers/auth_controller.dart';
import 'package:guia_turismo/controllers/lugares_controller.dart';
import 'package:guia_turismo/screens/login_screen.dart';
import 'package:guia_turismo/screens/lugares_screen.dart';
import 'package:guia_turismo/services/session_service.dart';
import 'package:guia_turismo/controllers/camera_controller.dart';
import 'package:guia_turismo/screens/cadastrar_lugar_screen.dart';
import 'package:guia_turismo/controllers/theme_controller.dart';

void main() {
  runApp(const Inicializar());
}

class Inicializar extends StatelessWidget {
  const Inicializar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => LugaresController()),
        ChangeNotifierProvider(create: (_) => CameraController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'cadastrar_lugar',
        routes: {
          'login': (context) => const LoginScreen(),
          'lugares': (context) => const LugaresScreen(),
          'cadastrar_lugar': (context) => const CadastrarLugarScreen(),
        },
        title: 'Rota Ciano',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0B1117),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF22D3EE),
            secondary: Color(0xFF22D3EE),
            surface: Color(0xFF111B24),
            error: Color(0xFFFF6B6B),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0B1117),
            foregroundColor: Color(0xFFF1F5F9),
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF111B24),
            labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
            hintStyle: const TextStyle(color: Color(0xFF64748B)),
            prefixIconColor: const Color(0xFF22D3EE),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF253442)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF253442)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 1.5),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: const Color(0xFF17232E),
            contentTextStyle: const TextStyle(color: Color(0xFFF1F5F9)),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = SessionService().pegarToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF22D3EE)),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Não foi possível recuperar sua sessão: ${snapshot.error}'),
              ),
            ),
          );
        }
        return snapshot.data?.isNotEmpty == true
            ? const LugaresScreen()
            : const LoginScreen();
      },
    );
  }
}
