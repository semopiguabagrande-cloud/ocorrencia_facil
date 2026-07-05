import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/pdf_service.dart';
import 'visualizar_imagem_screen.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class DetalhesOcorrenciaScreen extends StatefulWidget {

  final Map<String, dynamic> ocorrencia;

  const DetalhesOcorrenciaScreen({
    super.key,
    required this.ocorrencia,
  });

  @override
  State<DetalhesOcorrenciaScreen> createState() =>
      _DetalhesOcorrenciaScreenState();

}

class _DetalhesOcorrenciaScreenState
    extends State<DetalhesOcorrenciaScreen> {

  bool editando = false;

  late TextEditingController dataController;
  late TextEditingController horaController;
  late TextEditingController tipoController;
  late TextEditingController localController;
  late TextEditingController envolvidosController;
  late TextEditingController relatoController;

  @override
  void initState() {

    super.initState();

    dataController = TextEditingController(
      text: widget.ocorrencia["data"]?.toString() ?? "",
    );

    horaController = TextEditingController(
      text: widget.ocorrencia["hora"]?.toString() ?? "",
    );

    tipoController = TextEditingController(
      text: widget.ocorrencia["tipo"]?.toString() ?? "",
    );

    localController = TextEditingController(
      text: widget.ocorrencia["local"]?.toString() ?? "",
    );

    envolvidosController = TextEditingController(
      text: widget.ocorrencia["envolvidos"]?.toString() ?? "",
    );

    relatoController = TextEditingController(
      text: widget.ocorrencia["relato"]?.toString() ?? "",
    );

  }

  @override
  void dispose() {

    dataController.dispose();
    horaController.dispose();
    tipoController.dispose();
    localController.dispose();
    envolvidosController.dispose();
    relatoController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: const Color(0xFF07152B),

        foregroundColor: Colors.white,

        title: const Text(
          "DETALHES DA OCORRÊNCIA",
        ),

      ),

      body: Container(

        width: double.infinity,

        height: double.infinity,

        decoration: const BoxDecoration(

          image: DecorationImage(

            image: AssetImage(
              'assets/images/fundo_mobile.png',
            ),

            fit: BoxFit.cover,

          ),

        ),

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Card(

            color: const Color(0xFF07152B),

            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(18),

            ),

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

  _linha(
    "Número",
    widget.ocorrencia["id"],
  ),

  _linha(
    "Agente",
    widget.ocorrencia["agente"],
  ),

  _linha(
    "Matrícula",
    widget.ocorrencia["matricula"],
  ),

  _linha(
    "Data",
    widget.ocorrencia["data"],
    controller: dataController,
  ),

  _linha(
    "Hora",
    _formatarHora(
      widget.ocorrencia["hora"]?.toString() ?? "",
    ),
    controller: horaController,
  ),

  _linha(
    "Tipo",
    widget.ocorrencia["tipo"],
    controller: tipoController,
  ),

  _linha(
    "Local",
    widget.ocorrencia["local"],
    controller: localController,
  ),

  _linha(
    "Envolvidos",
    widget.ocorrencia["envolvidos"],
    controller: envolvidosController,
  ),

  _linha(
    "Relato",
    widget.ocorrencia["relato"],
    controller: relatoController,
  ),

  const SizedBox(height: 15),

  const Text(

    "Anexos",

    style: TextStyle(

      color: Color(0xFFFFC107),

      fontSize: 18,

      fontWeight: FontWeight.bold,

    ),

  ),

const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  child: _galeriaAnexos(context),
),

const SizedBox(height: 8),

SizedBox(

  width: double.infinity,

  child: ElevatedButton.icon(

    icon: const Icon(Icons.add_a_photo),

    label: const Text(

      "ADICIONAR IMAGEM",

      style: TextStyle(

        fontSize: 18,

        fontWeight: FontWeight.bold,

      ),

    ),

    style: ElevatedButton.styleFrom(

      backgroundColor: Colors.blue,

      foregroundColor: Colors.white,

      padding: const EdgeInsets.symmetric(

        vertical: 15,

      ),

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(12),

      ),

    ),

    onPressed: () async {

      await _adicionarImagem();

    },

  ),

),

const SizedBox(height: 12),
                                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton.icon(

                      icon: const Icon(Icons.picture_as_pdf),

                      label: const Text(

                        "GERAR PDF",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.red,

                        foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(

                          vertical: 16,

                        ),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(12),

                        ),

                      ),

                      onPressed: () async {

                        await PdfService.gerarOcorrencia(

                          widget.ocorrencia,

                        );

                      },

                    ),

                  ),

                  const SizedBox(height: 12),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton.icon(

                      icon: Icon(

                        editando
                            ? Icons.save
                            : Icons.edit,

                      ),

                      label: Text(

                        editando
                            ? "SALVAR ALTERAÇÕES"
                            : "EDITAR OCORRÊNCIA",

                        style: const TextStyle(

                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.orange,

                        foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(

                          vertical: 16,

                        ),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(12),

                        ),

                      ),

                      onPressed: () async {

                        if (!editando) {

                          setState(() {

                            editando = true;

                          });

                          return;

                        }

                        final sucesso =
                            await ApiService.editarOcorrencia(

                          id: widget.ocorrencia["id"],

                          data: dataController.text,

                          hora: horaController.text,

                          tipo: tipoController.text,

                          local: localController.text,

                          envolvidos:
                              envolvidosController.text,

                          relato:
                              relatoController.text,

                        );

                        if (sucesso) {

                          setState(() {

                            widget.ocorrencia["data"] =
                                dataController.text;

                            widget.ocorrencia["hora"] =
                                horaController.text;

                            widget.ocorrencia["tipo"] =
                                tipoController.text;

                            widget.ocorrencia["local"] =
                                localController.text;

                            widget.ocorrencia["envolvidos"] =
                                envolvidosController.text;

                            widget.ocorrencia["relato"] =
                                relatoController.text;

                            editando = false;

                          });

                          if (context.mounted) {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(

                              const SnackBar(

                                content: Text(

                                                                   "Ocorrência atualizada com sucesso.",

                                ),

                              ),

                            );

                          }

                        }

                      },

                    ),

                  ),

                  const SizedBox(height: 12),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton.icon(

                      icon: const Icon(Icons.delete_forever),

                      label: const Text(

                        "EXCLUIR OCORRÊNCIA",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                     style: ElevatedButton.styleFrom(

  backgroundColor: Colors.green.shade700,

  foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(

                          vertical: 16,

                        ),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(12),

                        ),

                      ),

                      onPressed: () async {

                        await _excluirOcorrencia();

                      },

                    ),

                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }


  Future<void> _adicionarImagem() async {

  FilePickerResult? resultado =
      await FilePicker.platform.pickFiles(

    type: FileType.image,

  );

  if (resultado == null) return;

  final File arquivo =
      File(resultado.files.single.path!);

  final String? url =
      await ApiService.uploadImagem(

    idOcorrencia:
        widget.ocorrencia["id"],

    arquivo: arquivo,

  );

  if (url == null) {

    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(

            "Erro ao enviar imagem.",

          ),

        ),

      );

    }

    return;

  }

  List<String> anexos = [];

  final texto =
      widget.ocorrencia["anexos"]?.toString() ?? "";

  if (texto.trim().isNotEmpty) {

    anexos = texto

        .split(";")

        .map((e) => e.trim())

        .where((e) => e.isNotEmpty)

        .toList();

  }

  anexos.add(url);

  final sucesso =
      await ApiService.atualizarAnexos(

    id: widget.ocorrencia["id"],

    anexos: anexos.join(";"),

  );

  if (!sucesso) {

    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(

            "Erro ao atualizar anexos.",

          ),

        ),

      );

    }

    return;

  }

  setState(() {

    widget.ocorrencia["anexos"] =
        anexos.join(";");

  });

  if (mounted) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          "Imagem adicionada.",

        ),

      ),

    );

  }

}
//====================================================
// REMOVER IMAGEM
//====================================================

Future<void> _removerImagem(String url) async {

  final confirmar = await showDialog<bool>(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: const Text(

          "Remover imagem",

        ),

        content: const Text(

          "Deseja remover esta imagem?",

        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(

                context,

                false,

              );

            },

            child: const Text(

              "Cancelar",

            ),

          ),

          ElevatedButton(

            onPressed: () {

              Navigator.pop(

                context,

                true,

              );

            },

            child: const Text(

              "Remover",

            ),

          ),

        ],

      );

    },

  );

  if (confirmar != true) return;

  List<String> anexos =

      (widget.ocorrencia["anexos"] ?? "")

          .toString()

          .split(";")

          .map((e) => e.trim())

          .where((e) => e.isNotEmpty)

          .toList();

  anexos.remove(url);

  final sucesso =

      await ApiService.atualizarAnexos(

    id: widget.ocorrencia["id"],

    anexos: anexos.join(";"),

  );

  if (!sucesso) {

    if (mounted) {

      ScaffoldMessenger.of(context)

          .showSnackBar(

        const SnackBar(

          content: Text(

            "Erro ao remover imagem.",

          ),

        ),

      );

    }

    return;

  }

  setState(() {

    widget.ocorrencia["anexos"] =

        anexos.join(";");

  });

  if (mounted) {

    ScaffoldMessenger.of(context)

        .showSnackBar(

      const SnackBar(

        content: Text(

          "Imagem removida.",

        ),

      ),

    );

  }

}
//====================================================
// EXCLUIR OCORRÊNCIA
//====================================================

Future<void> _excluirOcorrencia() async {

  final confirmar = await showDialog<bool>(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: const Text(

          "Excluir ocorrência",

        ),

        content: const Text(

          "Deseja realmente excluir esta ocorrência?\n\nEssa ação não poderá ser desfeita.",

        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(

                context,

                false,

              );

            },

            child: const Text(

              "Cancelar",

            ),

          ),

          ElevatedButton(

            style: ElevatedButton.styleFrom(

              backgroundColor: Colors.red,

            ),

            onPressed: () {

              Navigator.pop(

                context,

                true,

              );

            },

            child: const Text(

              "Excluir",

            ),

          ),

        ],

      );

    },

  );

  if (confirmar != true) return;

  final sucesso =

      await ApiService.excluirOcorrencia(

    id: widget.ocorrencia["id"],

  );

  if (!mounted) return;

  if (sucesso) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          "Ocorrência excluída com sucesso.",

        ),

      ),

    );

    Navigator.pop(

      context,

      true,

    );

  } else {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          "Erro ao excluir ocorrência.",

        ),

      ),

    );

  }

}

//====================================================
// LINHAS
//====================================================
  Widget _linha(

    String titulo,

    dynamic valor, {

    TextEditingController? controller,

  }) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 18),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(

            titulo,

            style: const TextStyle(

              color: Color(0xFFFFC107),

              fontSize: 18,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 5),

          if (!editando || controller == null)

            Text(

              valor.toString(),

              style: const TextStyle(

                color: Colors.white,

                fontSize: 18,

              ),

            )

          else

            TextField(

              controller: controller,

              style: const TextStyle(

                color: Colors.white,

              ),

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white10,

                border: OutlineInputBorder(

                  borderRadius:

                      BorderRadius.circular(10),

                ),

              ),

            ),

        ],

      ),

    );

  }
    //====================================================
  // GALERIA DE ANEXOS
  //====================================================

  Widget _galeriaAnexos(BuildContext context) {

    final texto =
    widget.ocorrencia["anexos"]?.toString() ?? "";
    if (texto.trim().isEmpty) {

      return const Text(

        "Nenhum anexo.",

        style: TextStyle(

          color: Colors.white,

          fontSize: 18,

        ),

      );

    }

    final imagens = texto

        .split(";")

        .map((e) => e.trim())

        .where((e) => e.isNotEmpty)

        .toList();

return Align(

  alignment: Alignment.centerLeft,

  child: Wrap(

    spacing: 10,

    runSpacing: 10,

    children: imagens.map((url) {

       return Stack(

  children: [

    InkWell(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) => VisualizarImagemScreen(

              url: url,

            ),

          ),

        );

      },

      child: ClipRRect(

        borderRadius: BorderRadius.circular(12),

        child: Image.network(

          url,

          width: 150,

          height: 120,

          fit: BoxFit.cover,

          loadingBuilder: (

            context,

            child,

            loadingProgress,

          ) {

            if (loadingProgress == null) {

              return child;

            }

            return Container(

              width: 150,

              height: 120,

              color: Colors.black26,

              child: const Center(

                child: CircularProgressIndicator(),

              ),

            );

          },

          errorBuilder: (

            context,

            error,

            stackTrace,

          ) {

            return Container(

              width: 150,

              height: 120,

              color: Colors.black26,

              alignment: Alignment.center,

              child: const Icon(

                Icons.broken_image,

                color: Colors.white,

                size: 40,

              ),

            );

          },

        ),

      ),

    ),

    Positioned(

      top: 4,

      right: 4,

      child: Material(

        color: Colors.transparent,

        child: InkWell(

          borderRadius: BorderRadius.circular(30),

          onTap: () {

            _removerImagem(url);

          },

          child: Container(

            decoration: const BoxDecoration(

              color: Colors.red,

              shape: BoxShape.circle,

            ),

            padding: const EdgeInsets.all(4),

            child: const Icon(

              Icons.close,

              color: Colors.white,

              size: 16,

            ),

          ),

        ),

      ),

    ),

  ],

);

          }).toList(),

    ),

  );

}

  //====================================================
  // FORMATA HORA
  //====================================================

  String _formatarHora(String hora) {

    if (hora.contains("T")) {

      try {

        return hora.split("T")[1].substring(0, 5);

      } catch (_) {}

    }

    return hora;

  }

  //====================================================
  // CONVERTE URL DO DRIVE
  //====================================================

  String _urlImagem(String url) {

    if (url.contains("/file/d/")) {

      final id =

          url.split("/file/d/")[1].split("/")[0];

      return

          "https://drive.google.com/uc?export=view&id=$id";

    }

    return url;

  }

}