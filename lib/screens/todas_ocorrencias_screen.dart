import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detalhes_ocorrencia_screen.dart';

class TodasOcorrenciasScreen extends StatefulWidget {
  const TodasOcorrenciasScreen({super.key});

  @override
  State<TodasOcorrenciasScreen> createState() =>
      _TodasOcorrenciasScreenState();
}

class _TodasOcorrenciasScreenState
    extends State<TodasOcorrenciasScreen> {

  late Future<List<dynamic>> _future;

  String _pesquisa = "";

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _future = ApiService.listarTodasOcorrencias();
  }

  List<dynamic> _filtrar(List<dynamic> lista) {

    if (_pesquisa.isEmpty) {
      return lista;
    }

    return lista.where((oc) {

      final texto = (
          "${oc["id"]}"
          "${oc["tipo"]}"
          "${oc["agente"]}"
          "${oc["matricula"]}"
          "${oc["local"]}"
      ).toUpperCase();

      return texto.contains(
        _pesquisa.toUpperCase(),
      );

    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    final largura =
        MediaQuery.of(context).size.width;

    final fundo =
        largura > 900
            ? 'assets/images/fundo_pc.png'
            : 'assets/images/fundo_mobile.png';

    return Scaffold(

      body: Container(

        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(

          image: DecorationImage(

            image: AssetImage(fundo),

            fit: BoxFit.cover,

          ),

        ),

        child: SafeArea(

          child: Column(

            children: [

              Container(

                padding: const EdgeInsets.fromLTRB(
                  20,
                  30,
                  20,
                  20,
                ),

                child: Row(

                  children: [

                    IconButton(

                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),

                      onPressed: () {
                        Navigator.pop(context);
                      },

                    ),

                    const Expanded(

                      child: Text(

                        "TODAS AS OCORRÊNCIAS",

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(

                          color: Color(0xFFFFC107),

                          fontSize: 22,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                    ),

                    IconButton(

                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),

                      onPressed: () {

                        setState(() {
                          _carregar();
                        });

                      },

                    ),

                  ],

                ),

              ),

              Padding(

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: TextField(

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: "Pesquisar",

                    hintStyle: const TextStyle(
                      color: Colors.white70,
                    ),

                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),

                    filled: true,

                    fillColor:
                        const Color(0xFF07152B),

                    border: OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(12),

                    ),

                  ),

                  onChanged: (v) {

                    setState(() {

                      _pesquisa = v;

                    });

                  },

                ),

              ),

              const SizedBox(height: 20),

              Expanded(

                child: FutureBuilder<List<dynamic>>(

                  future: _future,

                  builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erro: ${snapshot.error}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma ocorrência encontrada.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final lista =
                        _filtrar(snapshot.data!);

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: lista.length,
                      itemBuilder: (context, index) {

                        final Map<String, dynamic> oc =
                            Map<String, dynamic>.from(
                                lista[index]);

                        return Card(
                          margin:
                              const EdgeInsets.only(
                            bottom: 18,
                          ),
                          elevation: 8,
                          color: const Color(
                            0xFF07152B,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                           onTap: () async {

  final resultado = await Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) => DetalhesOcorrenciaScreen(

        ocorrencia: oc,

      ),

    ),

  );

  if (resultado == true) {

    setState(() {

      _carregar();

    });

  }

},

child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                18,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [

                                  Text(
                                    oc["id"]
                                        .toString(),
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize: 22,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Text(
                                    oc["tipo"]
                                        .toString(),
                                    style:
                                        const TextStyle(
                                      color: Color(
                                          0xFF42A5F5),
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  Text(
                                    "AGENTE: ${oc["agente"]}",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  Text(
                                    "MATRÍCULA: ${oc["matricula"]}",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                 Row(
  children: [

    const Icon(
      Icons.calendar_month,
      color: Colors.white70,
      size: 18,
    ),

    const SizedBox(width: 6),

    Text(
      oc["data"].toString(),
      style: const TextStyle(
        color: Colors.white,
      ),
    ),

    const SizedBox(width: 20),

    const Icon(
      Icons.access_time,
      color: Colors.white70,
      size: 18,
    ),

    const SizedBox(width: 6),

    Text(
      oc["hora"].toString(),
      style: const TextStyle(
        color: Colors.white,
      ),
    ),

  ],
),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                                                    Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          oc["local"].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E88E5),
                                        borderRadius:
                                            BorderRadius.circular(25),
                                      ),
                                      child: const Text(
                                        "TOQUE PARA VER DETALHES",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}