import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:guia_turismo/controllers/lugares_controller.dart';
// import 'package:guia_turismo/models/lugares_model.dart';
import 'package:guia_turismo/controllers/camera_controller.dart';

class CadastrarLugarScreen extends StatefulWidget {
  const CadastrarLugarScreen({super.key});

  @override
  State<CadastrarLugarScreen> createState() => _CadastrarLugarScreenState();
}


class _CadastrarLugarScreenState extends State<CadastrarLugarScreen> {
  @override  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar lugar')),
      body: Consumer<CameraController>(
        builder: (context, cameraController, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                // alinhar a imagem e o botão de câmera no centro da tela
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111B24),
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(16),
                      image: exibirImagem(cameraController),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => abrirModal(cameraController, context),
                    icon: const Icon(Icons.camera_alt_rounded),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DecorationImage exibirImagem(CameraController controle) {
    if (controle.imagemSelecionada == null) {
      return DecorationImage(
        image: NetworkImage('https://placehold.jp/150x150.png'),
        fit: BoxFit.cover,
      );
    } else {
      return DecorationImage(
        image: FileImage(controle.imagemSelecionada!),
        fit: BoxFit.cover,
      );
    }
  }

  void abrirModal(CameraController controle, context) {
    showModalBottomSheet(
      context:context,
      builder: (context) =>
      SafeArea(bottom: true,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            onTap: () {
              controle.tirarFotoComCamera();
              Navigator.pop(context);
            },
            title: Text('Tirar foto'),
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            onTap: () {
              controle.selecionarImagemDaGaleria();
              Navigator.pop(context);
            },
            title: Text('Selecionar da galeria'),
          ),
        ],
        ),
      ),
    );
  }  
}
