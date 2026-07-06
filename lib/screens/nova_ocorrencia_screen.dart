import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';

class NovaOcorrenciaScreen extends StatefulWidget {
final String nome;
final String matricula;

const NovaOcorrenciaScreen({
super.key,
required this.nome,
required this.matricula,
});

@override
State<NovaOcorrenciaScreen> createState() =>
_NovaOcorrenciaScreenState();
}

class _NovaOcorrenciaScreenState
extends State<NovaOcorrenciaScreen> {

final dataController =
TextEditingController();

final horaController =
TextEditingController();

final localController =
TextEditingController();

final envolvidosController =
TextEditingController();

final relatoController =
TextEditingController();

String? tipoSelecionado;
List<PlatformFile> imagensSelecionadas = [];

final List<String> tiposOcorrencia = [
'AGRESSÃO',
'DESACATO',
'PERTURBAÇÃO DO SOSSEGO',
'POSSE DE DROGAS',
'ROUBO/FURTO',
'TRÂNSITO',
'VANDALISMO/DEPREDAÇÃO',
'VIOLÊNCIA DOMÉSTICA',
'OUTROS',
];

Future<void> selecionarData() async {
DateTime? data =
await showDatePicker(
context: context,
initialDate: DateTime.now(),
firstDate: DateTime(2024),
lastDate: DateTime(2100),
);

if (data != null) {
  dataController.text =
      '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year}';
}

}
Future<void> selecionarImagens() async {

  final resultado = await FilePicker.platform.pickFiles(

    allowMultiple: true,

    type: FileType.image,

    withData: true,

  );

  if (resultado != null) {

    setState(() {

      imagensSelecionadas = resultado.files;

    });

  }

}

Future<void> selecionarHora() async {
final TimeOfDay? hora =
await showTimePicker(
context: context,
initialTime: TimeOfDay.now(),
);

if (hora != null) {
  horaController.text =
      '${hora.hour.toString().padLeft(2, '0')}:'
      '${hora.minute.toString().padLeft(2, '0')}';
}

}

@override
Widget build(BuildContext context) {

final largura =
    MediaQuery.of(context).size.width;

final mobile = largura < 900;
return Scaffold(
  appBar: AppBar(
    backgroundColor: const Color(0xFF07152B),
    elevation: 0,

    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),

    title: const Text(
      'NOVA OCORRÊNCIA',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  body: Container(
    width: double.infinity,
    height: double.infinity,

    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          mobile
              ? 'assets/images/fundo_mobile.png'
              : 'assets/images/fundo_pc.png',
        ),
        fit: BoxFit.cover,
      ),
    ),

    child: SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Center(
          child: Container(
            constraints:
                const BoxConstraints(
              maxWidth: 900,
            ),

            padding:
                const EdgeInsets.all(20),

            decoration: BoxDecoration(
  color: const Color(0xFF07152B),

  borderRadius:
      BorderRadius.circular(
    25,
  ),

  border: Border.all(
    color: const Color(0xFF1E88E5),
    width: 1.2,
  ),

  boxShadow: const [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 15,
      offset: Offset(0, 5),
    ),
  ],
),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  'NOVA OCORRÊNCIA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

              DropdownButtonFormField<String>(
  value: tipoSelecionado,

  dropdownColor: const Color(0xFF07152B),

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),

  icon: const Icon(
    Icons.arrow_drop_down,
    color: Colors.white,
  ),

  decoration: InputDecoration(
    labelText: 'TIPO DE OCORRÊNCIA',

    labelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    filled: true,
    fillColor: const Color(0xFF07152B),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 22,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.white24,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFF1E88E5),
        width: 2,
      ),
    ),
  ),

  items: tiposOcorrencia.map((tipo) {
    return DropdownMenuItem<String>(
      value: tipo,
      child: Text(
        tipo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }).toList(),

  onChanged: (value) {
    setState(() {
      tipoSelecionado = value;
    });
  },
),

const SizedBox(height: 15),

Row(
  children: [

    Expanded(
      child: TextFormField(
        controller: dataController,
        readOnly: true,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          labelText: 'DATA',

          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          prefixIcon: const Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),

          filled: true,
          fillColor: const Color(0xFF07152B),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 22,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onTap: selecionarData,
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: TextFormField(
        controller: horaController,
        readOnly: true,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          labelText: 'HORA',

          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          prefixIcon: const Icon(
            Icons.access_time,
            color: Colors.white,
          ),

          filled: true,
          fillColor: const Color(0xFF07152B),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 22,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onTap: selecionarHora,
      ),
    ),
  ],
),

const SizedBox(height: 15),

TextFormField(
  enabled: false,
  initialValue: widget.nome,

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),

  decoration: InputDecoration(
    labelText: 'AGENTE',

    labelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    filled: true,
    fillColor: const Color(0xFF07152B),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 22,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

const SizedBox(height: 15),

TextFormField(
  enabled: false,
  initialValue: widget.matricula,

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),

  decoration: InputDecoration(
    labelText: 'MATRÍCULA',

    labelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    filled: true,
    fillColor: const Color(0xFF07152B),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 22,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

const SizedBox(height: 15),

TextFormField(
  controller: localController,

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),

  decoration: InputDecoration(
    labelText: 'LOCAL',

    labelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    filled: true,
    fillColor: const Color(0xFF07152B),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 22,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

const SizedBox(height: 15),

TextFormField(
  controller: envolvidosController,
  maxLines: 3,

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),

  decoration: InputDecoration(
    labelText: 'ENVOLVIDOS',

    labelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    filled: true,
    fillColor: const Color(0xFF07152B),

    contentPadding: const EdgeInsets.all(15),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

const SizedBox(height: 15),

TextFormField(
  controller: relatoController,
  maxLines: 12,
  minLines: 8,

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),

  decoration: InputDecoration(
    labelText: 'RELATO',

    alignLabelWithHint: true,

    labelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    filled: true,
    fillColor: const Color(0xFF07152B),

    contentPadding: const EdgeInsets.all(20),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),
const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton.icon(
    onPressed: selecionarImagens,
    icon: const Icon(Icons.attach_file),
    label: const Text(
      'ANEXAR ARQUIVOS',
    ),
  ),
),

const SizedBox(height: 15),

if (imagensSelecionadas.isNotEmpty)
  Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.black26,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        for (int i = 0; i < imagensSelecionadas.length; i++)
          ListTile(
            leading: const Icon(
              Icons.image,
              color: Colors.white,
            ),
            title: Text(
    imagensSelecionadas[i].name,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  imagensSelecionadas.removeAt(i);
                });
              },
            ),
          ),
      ],
    ),
  ),

const SizedBox(height: 20),


SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.save),
    label: const Text(
      'SALVAR OCORRÊNCIA',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () async {

      if (tipoSelecionado == null ||
          localController.text.trim().isEmpty ||
          relatoController.text.trim().isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Preencha todos os campos obrigatórios.',
            ),
          ),
        );

        return;
      }

      final resposta =
          await ApiService.salvarOcorrencia(

        data: dataController.text,
        hora: horaController.text,
        agente: widget.nome,
        matricula: widget.matricula,
        tipo: tipoSelecionado!,
        local: localController.text,
        envolvidos: envolvidosController.text,
        relato: relatoController.text,
        anexos: '',
      );

      if (resposta == null || resposta["sucesso"] != true) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Erro ao salvar ocorrência.',
            ),
          ),
        );

        return;
      }

      final String id = resposta["id"];

debugPrint("ID = $id");
debugPrint("Quantidade de imagens = ${imagensSelecionadas.length}");

List<String> links = [];

for (final imagem in imagensSelecionadas) {

  if (imagem.bytes == null) continue;

  final url = await ApiService.uploadImagem(

    idOcorrencia: id,

    nomeArquivo: imagem.name,

    bytes: imagem.bytes!,

  );

  if (url != null) {

    links.add(url);

  }

}

if (links.isNotEmpty) {

  await ApiService.atualizarAnexos(

    id: id,

    anexos: links.join(";"),

  );

}

ScaffoldMessenger.of(context).showSnackBar(

  SnackBar(

    backgroundColor: Colors.green,

    content: Text(

      'Ocorrência $id salva com sucesso!',

    ),

  ),

);

Navigator.pop(context);

},
),
),

              ],
            ),
          ),
        ),
      ),
    ),
  ),
);

}

}