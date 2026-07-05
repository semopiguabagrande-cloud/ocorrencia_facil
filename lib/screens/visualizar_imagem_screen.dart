import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class VisualizarImagemScreen extends StatelessWidget {

  final String url;

  const VisualizarImagemScreen({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        foregroundColor: Colors.white,

        title: const Text("Visualizar Imagem"),

      ),

      body: PhotoView(

        imageProvider: NetworkImage(
          _urlImagem(url),
        ),

        minScale: PhotoViewComputedScale.contained,

        maxScale: PhotoViewComputedScale.covered * 4,

        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),

      ),

    );

  }

  String _urlImagem(String url) {

    if (url.contains("/file/d/")) {

      final id =
          url.split("/file/d/")[1].split("/")[0];

      return "https://drive.google.com/uc?export=view&id=$id";

    }

    return url;

  }

}