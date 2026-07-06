import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbyVl7jRQEytL7PK-oDCnFMH3h7OrAxWp8LQL6snUz_D7XEYOrARDP8DA9Z76tolLnob2A/exec';

  //=========================
  // LOGIN
  //=========================

  static Future<Map<String, dynamic>?> login(
      String senha) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl?action=login&senha=$senha',
        ),
      );

      debugPrint("STATUS = ${response.statusCode}");
      debugPrint("BODY = ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;

    } catch (e) {

      debugPrint("ERRO LOGIN = $e");

      return null;

    }

  }

  //=========================
  // SALVAR OCORRÊNCIA
  //=========================

  static Future<Map<String, dynamic>?> salvarOcorrencia({

    required String data,
    required String hora,
    required String agente,
    required String matricula,
    required String tipo,
    required String local,
    required String envolvidos,
    required String relato,
    required String anexos,

  }) async {

    try {

      final uri = Uri.parse(baseUrl).replace(

        queryParameters: {

          'action': 'salvarOcorrencia',
          'data': data,
          'hora': hora,
          'agente': agente,
          'matricula': matricula,
          'tipo': tipo,
          'local': local,
          'envolvidos': envolvidos,
          'relato': relato,
          'anexos': anexos,

        },

      );

      final response = await http.get(uri);

      debugPrint("STATUS = ${response.statusCode}");
      debugPrint("BODY = ${response.body}");

      if (response.statusCode == 200) {

        return jsonDecode(response.body);

      }

      return null;

    } catch (e) {

      debugPrint("ERRO SALVAR = $e");

      return null;

    }

  }
    //=========================
  // MINHAS OCORRÊNCIAS
  //=========================

  static Future<List<dynamic>> listarOcorrencias(
      String matricula) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl?action=minhasOcorrencias&matricula=$matricula',
        ),
      );

      debugPrint("STATUS = ${response.statusCode}");
      debugPrint("BODY = ${response.body}");

      if (response.statusCode == 200) {

  final lista = jsonDecode(response.body);

  debugPrint("==================================");
  debugPrint(lista.toString());

  if (lista.isNotEmpty) {
    debugPrint("DATA = ${lista[0]['data']}");
    debugPrint("HORA = ${lista[0]['hora']}");
  }

  return lista;
}
      return [];

    } catch (e) {

      debugPrint("ERRO LISTAR = $e");

      return [];

    }

  }

  //=========================
  // TODAS AS OCORRÊNCIAS
  //=========================

  static Future<List<dynamic>> listarTodasOcorrencias() async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl?action=todasOcorrencias',
        ),
      );

      debugPrint("STATUS = ${response.statusCode}");
      debugPrint("BODY = ${response.body}");

      if (response.statusCode == 200) {

  final lista = jsonDecode(response.body);

  debugPrint("==================================");
  debugPrint(lista.toString());

  if (lista.isNotEmpty) {
    debugPrint("DATA = ${lista[0]['data']}");
    debugPrint("HORA = ${lista[0]['hora']}");
  }

  return lista;
}
      return [];

    } catch (e) {

      debugPrint("ERRO TODAS = $e");

      return [];

    }

  }
 //=========================
// UPLOAD DE IMAGEM
//=========================

static Future<String?> uploadImagem({

  required String idOcorrencia,
  required String nomeArquivo,
  required Uint8List bytes,

}) async {

  try {

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/aialj9ni/image/upload",
    );

    final request = http.MultipartRequest(
      "POST",
      uri,
    );

    request.fields["upload_preset"] = "ocorrenciafacil";

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        bytes,
        filename: nomeArquivo,
      ),
    );

    final streamed = await request.send();

    final response =
        await http.Response.fromStream(streamed);

    debugPrint(response.body);

    if (response.statusCode == 200) {

      final json =
          jsonDecode(response.body);
          debugPrint("UPLOAD CLOUDINARY OK");
debugPrint(json["secure_url"]);

      return json["secure_url"];

    }

  } catch (e) {

    debugPrint("ERRO CLOUDINARY = $e");

  }

  return null;

}
//=========================
// ATUALIZAR ANEXOS
//=========================

static Future<bool> atualizarAnexos({

  required String id,

  required String anexos,

}) async {

  try {

    final uri = Uri.parse(baseUrl).replace(

      queryParameters: {

        "action": "atualizarAnexos",

        "id": id,

        "anexos": anexos,

      },

    );

    final response = await http.get(uri);

    debugPrint("STATUS = ${response.statusCode}");
    debugPrint("BODY = ${response.body}");

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      return json["sucesso"] == true;

    }

  } catch (e) {

    debugPrint("ERRO ATUALIZAR = $e");

  }

  return false;

}
//=========================
// EDITAR OCORRÊNCIA
//=========================

static Future<bool> editarOcorrencia({

  required String id,
  required String data,
  required String hora,
  required String tipo,
  required String local,
  required String envolvidos,
  required String relato,

}) async {

  try {

    final uri = Uri.parse(baseUrl).replace(

      queryParameters: {

        "action": "editarOcorrencia",

        "id": id,

        "data": data,

        "hora": hora,

        "tipo": tipo,

        "local": local,

        "envolvidos": envolvidos,

        "relato": relato,

      },

    );

    final response = await http.get(uri);

    debugPrint("STATUS = ${response.statusCode}");
    debugPrint("BODY = ${response.body}");

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      return json["sucesso"] == true;

    }

  } catch (e) {

    debugPrint("ERRO EDITAR = $e");

  }

  return false;

}
//=========================
// EXCLUIR OCORRÊNCIA
//=========================

static Future<bool> excluirOcorrencia({
  required String id,
}) async {

  try {

    final uri = Uri.parse(baseUrl).replace(

      queryParameters: {

        "action": "excluirOcorrencia",

        "id": id,

      },

    );

    final response = await http.get(uri);

    debugPrint("STATUS = ${response.statusCode}");
    debugPrint("BODY = ${response.body}");

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      return json["sucesso"] == true;

    }

  } catch (e) {

    debugPrint("ERRO EXCLUIR = $e");

  }

  return false;

}
}