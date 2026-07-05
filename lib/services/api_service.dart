import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

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
        return jsonDecode(response.body);
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
        return jsonDecode(response.body);
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

  required File arquivo,

}) async {

  try {

    final bytes = await arquivo.readAsBytes();

    final base64Arquivo = base64Encode(bytes);

    String mimeType = "image/jpeg";

    final nome = arquivo.path.toLowerCase();

    if (nome.endsWith(".png")) {
      mimeType = "image/png";
    } else if (nome.endsWith(".jpeg")) {
      mimeType = "image/jpeg";
    } else if (nome.endsWith(".jpg")) {
      mimeType = "image/jpeg";
    }

    final request = http.Request(

      'POST',

      Uri.parse(baseUrl),

    );

    request.headers['Content-Type'] =
        'application/json';

    request.body = jsonEncode({

      "tipo": "uploadAnexo",

      "idOcorrencia": idOcorrencia,

      "nomeArquivo":
          arquivo.path.split("\\").last,

      "mimeType": mimeType,

      "base64": base64Arquivo,

    });

    final streamed =
        await request.send();

    debugPrint(
      "STATUS UPLOAD = ${streamed.statusCode}",
    );

    debugPrint(
      "LOCATION = ${streamed.headers['location']}",
    );

    //============================
    // GOOGLE RETORNOU 302
    //============================

    if (streamed.statusCode == 302 &&
        streamed.headers['location'] != null) {

      final respostaFinal =
          await http.get(

        Uri.parse(
          streamed.headers['location']!,
        ),

      );

      debugPrint(
        "BODY FINAL = ${respostaFinal.body}",
      );

      final json =
          jsonDecode(respostaFinal.body);

      if (json["sucesso"] == true) {

        return json["url"];

      }

      return null;

    }

    final response =
        await http.Response.fromStream(
      streamed,
    );

    debugPrint(response.body);

    if (response.statusCode == 200) {

      final json =
          jsonDecode(response.body);

      if (json["sucesso"] == true) {

        return json["url"];

      }

    }

  } catch (e) {

    debugPrint(
      "ERRO UPLOAD = $e",
    );

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

    final request = http.Request(

      'POST',

      Uri.parse(baseUrl),

    );

    request.headers['Content-Type'] =
        'application/json';

    request.body = jsonEncode({

      "action": "atualizarAnexos",

      "id": id,

      "anexos": anexos,

    });

    final streamed =
        await request.send();

    debugPrint(
      "ATUALIZAR STATUS = ${streamed.statusCode}",
    );

    if (streamed.statusCode == 302 &&
        streamed.headers['location'] != null) {

      final respostaFinal =
          await http.get(

        Uri.parse(
          streamed.headers['location']!,
        ),

      );

      debugPrint(
        "ATUALIZAR BODY = ${respostaFinal.body}",
      );

      final json =
          jsonDecode(respostaFinal.body);

      return json["sucesso"] == true;

    }

    final response =
        await http.Response.fromStream(
      streamed,
    );

    debugPrint(response.body);

    if (response.statusCode == 200) {

      final json =
          jsonDecode(response.body);

      return json["sucesso"] == true;

    }

  } catch (e) {

    debugPrint(
      "ERRO ATUALIZAR = $e",
    );

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

    final request = http.Request(

      'POST',

      Uri.parse(baseUrl),

    );

    request.headers['Content-Type'] =
        'application/json';

    request.body = jsonEncode({

      "action": "editarOcorrencia",

      "id": id,

      "data": data,

      "hora": hora,

      "tipo": tipo,

      "local": local,

      "envolvidos": envolvidos,

      "relato": relato,

    });

    final streamed =
        await request.send();

    if (streamed.statusCode == 302 &&
        streamed.headers['location'] != null) {

      final resposta =
          await http.get(

        Uri.parse(
          streamed.headers['location']!,
        ),

      );

      final json =
          jsonDecode(resposta.body);

      return json["sucesso"] == true;

    }

    final response =
        await http.Response.fromStream(
      streamed,
    );

    if (response.statusCode == 200) {

      final json =
          jsonDecode(response.body);

      return json["sucesso"] == true;

    }

  } catch (e) {

    debugPrint(
      "ERRO EDITAR = $e",
    );

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

    final request = http.Request(

      'POST',

      Uri.parse(baseUrl),

    );

    request.headers['Content-Type'] =
        'application/json';

    request.body = jsonEncode({

      "action": "excluirOcorrencia",

      "id": id,

    });

    final streamed =
        await request.send();

    if (streamed.statusCode == 302 &&
        streamed.headers['location'] != null) {

      final resposta =
          await http.get(

        Uri.parse(
          streamed.headers['location']!,
        ),

      );

      final json =
          jsonDecode(resposta.body);

      return json["sucesso"] == true;

    }

    final response =
        await http.Response.fromStream(
      streamed,
    );

    if (response.statusCode == 200) {

      final json =
          jsonDecode(response.body);

      return json["sucesso"] == true;

    }

  } catch (e) {

    debugPrint(
      "ERRO EXCLUIR = $e",
    );

  }

  return false;

}
}