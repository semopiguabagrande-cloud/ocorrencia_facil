import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {

  //====================================================
  // GERAR PDF
  //====================================================

  static Future<void> gerarOcorrencia(
    Map<String, dynamic> oc,
  ) async {

    final pdf = pw.Document();

    //------------------------------------
    // LOGO
    //------------------------------------

    final logo = await rootBundle.load(
      'assets/images/logo_guarda.png',
    );

    final Uint8List logoBytes =
        logo.buffer.asUint8List();

    final imagemLogo =
        pw.MemoryImage(logoBytes);

            //------------------------------------
    // CARREGAR ANEXOS
    //------------------------------------

    final List<pw.MemoryImage> imagens = [];

    final textoAnexos =
        (oc["anexos"] ?? "").toString();

    if (textoAnexos.trim().isNotEmpty) {

      final urls = textoAnexos
          .split(";")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty);

      for (final url in urls) {

        final imagem =
            await _baixarImagem(url);

        if (imagem != null) {

          imagens.add(imagem);

        }

      }

    }

    //------------------------------------
    // PDF
    //------------------------------------

    pdf.addPage(

      pw.MultiPage(

        pageFormat: PdfPageFormat.a4,

        margin: const pw.EdgeInsets.all(30),

        build: (context) => [

          //--------------------------------
          // BRASÃO
          //--------------------------------

          pw.Center(

            child: pw.Image(

              imagemLogo,

              width: 110,

              height: 110,

            ),

          ),

          pw.SizedBox(height: 8),

          //--------------------------------
          // CABEÇALHO
          //--------------------------------

          pw.Center(

            child: pw.Text(

              "GUARDA CIVIL MUNICIPAL",

              style: pw.TextStyle(

                fontSize: 18,

                fontWeight: pw.FontWeight.bold,

              ),

            ),

          ),

          pw.Center(

            child: pw.Text(

              "DE IGUABA GRANDE",

              style: pw.TextStyle(

                fontSize: 13,

                fontWeight: pw.FontWeight.bold,

                color: PdfColors.grey700,

              ),

            ),

          ),

          pw.SizedBox(height: 3),

          pw.Center(

            child: pw.Text(

              "REGISTRO DE OCORRÊNCIA",

              style: const pw.TextStyle(

                fontSize: 12,

                color: PdfColors.grey700,

              ),

            ),

          ),

          pw.SizedBox(height: 18),

          //--------------------------------
          // NÚMERO DA OCORRÊNCIA
          //--------------------------------

          pw.Container(

            width: double.infinity,

            padding: const pw.EdgeInsets.all(10),

            decoration: pw.BoxDecoration(

              color: PdfColors.blue900,

              borderRadius:
                  pw.BorderRadius.circular(6),

            ),

            child: pw.Center(

              child: pw.Text(

                "OCORRÊNCIA Nº ${oc["id"]}",

                style: pw.TextStyle(

                  color: PdfColors.white,

                  fontSize: 15,

                  fontWeight:
                      pw.FontWeight.bold,

                ),

              ),

            ),

          ),

          pw.SizedBox(height: 18),
                    //--------------------------------
          // AGENTE / MATRÍCULA
          //--------------------------------

          pw.Row(

            crossAxisAlignment:
                pw.CrossAxisAlignment.start,

            children: [

              pw.Expanded(

                child: _campo(

                  "AGENTE",

                  oc["agente"],

                ),

              ),

              pw.SizedBox(width: 12),

              pw.Expanded(

                child: _campo(

                  "MATRÍCULA",

                  oc["matricula"],

                ),

              ),

            ],

          ),

          //--------------------------------
          // DATA / HORA
          //--------------------------------

          pw.Row(

            crossAxisAlignment:
                pw.CrossAxisAlignment.start,

            children: [

              pw.Expanded(

                child: _campo(

                  "DATA",

                  oc["data"],

                ),

              ),

              pw.SizedBox(width: 12),

              pw.Expanded(

                child: _campo(

                  "HORA",

                  oc["hora"],

                ),

              ),

            ],

          ),

          //--------------------------------
          // TIPO
          //--------------------------------

          _campo(

            "TIPO DA OCORRÊNCIA",

            oc["tipo"],

          ),

          //--------------------------------
          // LOCAL
          //--------------------------------

          _campo(

            "LOCAL",

            oc["local"],

          ),

          //--------------------------------
          // ENVOLVIDOS
          //--------------------------------

          _campo(

            "ENVOLVIDOS",

            oc["envolvidos"],

          ),

          //--------------------------------
          // RELATO
          //--------------------------------

          //--------------------------------
// RELATO
//--------------------------------

pw.Header(

  level: 1,

  child: pw.Text(

    "RELATO",

    style: pw.TextStyle(

      fontSize: 12,

      fontWeight: pw.FontWeight.bold,

      color: PdfColors.blue900,

    ),

  ),

),

pw.Text(

  oc["relato"]?.toString() ?? "",

  textAlign: pw.TextAlign.justify,

  style: const pw.TextStyle(

    fontSize: 11,

    lineSpacing: 2,

  ),

),
                    //--------------------------------
          // ANEXOS
          //--------------------------------

          if (imagens.isNotEmpty) ...[

            pw.SizedBox(height: 20),

            pw.Text(

              "ANEXOS",

              style: pw.TextStyle(

                fontSize: 14,

                fontWeight: pw.FontWeight.bold,

                color: PdfColors.blue900,

              ),

            ),

            pw.SizedBox(height: 10),

            ...imagens.map(

  (img) => pw.Padding(

    padding: const pw.EdgeInsets.only(

      bottom: 20,

    ),

    child: pw.Center(

      child: pw.Image(

        img,

        width: 200,

        fit: pw.BoxFit.contain,

      ),

    ),

  ),

),
          ],

          //--------------------------------
          // RODAPÉ
          //--------------------------------

          pw.SizedBox(height: 25),

          pw.Divider(),

          pw.SizedBox(height: 8),

          pw.Center(

            child: pw.Text(

              "Sistema Ocorrência Fácil",

              style: pw.TextStyle(

                fontSize: 10,

                fontWeight:
                    pw.FontWeight.bold,

                color: PdfColors.grey700,

              ),

            ),

          ),

          pw.Center(

            child: pw.Text(

              "Guarda Civil Municipal de Iguaba Grande",

              style: const pw.TextStyle(

                fontSize: 9,

                color: PdfColors.grey700,

              ),

            ),

          ),

          pw.Center(

            child: pw.Text(

              "Secretaria Municipal de Segurança e Ordem Pública",

              style: const pw.TextStyle(

                fontSize: 9,

                color: PdfColors.grey700,

              ),

            ),

          ),

        ],

      ),

    );

    //------------------------------------
    // SALVAR / COMPARTILHAR PDF
    //------------------------------------

    final bytes = await pdf.save();

    await Printing.sharePdf(

      bytes: bytes,

      filename:
          "Ocorrencia_${oc["id"]}.pdf",

    );

  }
    //====================================================
  // BAIXAR IMAGEM
  //====================================================

  static Future<pw.MemoryImage?> _baixarImagem(

    String url,

  ) async {

    try {

      final response = await http.get(

        Uri.parse(url),

      );

      if (response.statusCode == 200) {

        return pw.MemoryImage(

          response.bodyBytes,

        );

      }

    } catch (_) {}

    return null;

  }

  //====================================================
  // CAMPO
  //====================================================

  static pw.Widget _campo(

    String titulo,

    dynamic valor,

  ) {

    return pw.Container(

      width: double.infinity,

      margin: const pw.EdgeInsets.only(

        bottom: 12,

      ),

      padding: const pw.EdgeInsets.all(10),

      decoration: pw.BoxDecoration(

        color: PdfColors.grey50,

        border: pw.Border.all(

          color: PdfColors.blueGrey200,

          width: 0.8,

        ),

        borderRadius:

            pw.BorderRadius.circular(6),

      ),

      child: pw.Column(

        crossAxisAlignment:

            pw.CrossAxisAlignment.start,

        children: [

          pw.Text(

            titulo,

            style: pw.TextStyle(

              fontSize: 9,

              fontWeight:

                  pw.FontWeight.bold,

              color: PdfColors.blue900,

            ),

          ),

          pw.SizedBox(height: 5),

          pw.Text(

            valor?.toString() ?? "",

            style: const pw.TextStyle(

              fontSize: 11,

            ),

          ),

        ],

      ),

    );

  }
}