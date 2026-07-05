import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detalhes_ocorrencia_screen.dart';

class MinhasOcorrenciasScreen extends StatefulWidget {

  final String matricula;

  const MinhasOcorrenciasScreen({

    super.key,

    required this.matricula,

  });

  @override
  State<MinhasOcorrenciasScreen> createState() =>
      _MinhasOcorrenciasScreenState();

}

class _MinhasOcorrenciasScreenState
    extends State<MinhasOcorrenciasScreen> {

  late Future<List<dynamic>> ocorrencias;

  String pesquisa = "";

  @override
  void initState() {

    super.initState();

    carregarOcorrencias();

  }

  void carregarOcorrencias() {

    ocorrencias = ApiService.listarOcorrencias(

      widget.matricula,

    );

  }

  @override
  Widget build(BuildContext context) {

    final largura =
        MediaQuery.of(context).size.width;

    return Scaffold(

      body: Container(

        width: double.infinity,

        height: double.infinity,

        decoration: BoxDecoration(

          image: DecorationImage(

            image: AssetImage(

              largura > 900

                  ? 'assets/images/fundo_pc.png'

                  : 'assets/images/fundo_mobile.png',

            ),

            fit: BoxFit.cover,

          ),

        ),

        child: SafeArea(

          child: Column(

            children: [

              Container(

                padding: const EdgeInsets.fromLTRB(

                  20,

                  35,

                  20,

                  20,

                ),

                child: Row(

                  children: [

                    IconButton(

                      icon: const Icon(

                        Icons.arrow_back,

                        color: Colors.white,

                        size: 30,

                      ),

                      onPressed: () {

                        Navigator.pop(context);

                      },

                    ),

                    Expanded(

                      child: Text(

                        'MINHAS OCORRÊNCIAS',

                        style: TextStyle(

                          color: const Color(0xFFFFC107),

                          fontSize:

                              largura > 900 ? 28 : 20,

                          fontWeight:

                              FontWeight.bold,

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

                          carregarOcorrencias();

                        });

                      },

                    ),

                  ],

                ),

              ),

              Padding(

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: TextField(

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),

                  decoration: InputDecoration(

                    hintText:
                        'Pesquisar...',

                    hintStyle:
                        const TextStyle(
                      color: Colors.white70,
                    ),

                    prefixIcon:
                        const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),

                    filled: true,

                    fillColor:
                        const Color(
                      0xFF07152B,
                    ),

                    border:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                    ),

                  ),

                  onChanged: (value) {

                    setState(() {

                      pesquisa =
                          value.toUpperCase();

                    });

                  },

                ),

              ),

              const SizedBox(height: 20),

              Expanded(

                child:
                    FutureBuilder<List<dynamic>>(

                  future: ocorrencias,

                  builder:
                      (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {

                      return const Center(

                        child:
                            CircularProgressIndicator(),

                      );

                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {

                      return const Center(

                        child: Text(

                          'Nenhuma ocorrência encontrada.',

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 20,

                          ),

                        ),

                      );

                    }

                    final lista =
                        snapshot.data!;
                                            final filtrada = lista.where((item) {

                      if (pesquisa.isEmpty) {
                        return true;
                      }

                      return item['id']
                              .toString()
                              .toUpperCase()
                              .contains(pesquisa) ||

                          item['tipo']
                              .toString()
                              .toUpperCase()
                              .contains(pesquisa) ||

                          item['local']
                              .toString()
                              .toUpperCase()
                              .contains(pesquisa);

                    }).toList();

                    if (filtrada.isEmpty) {

                      return const Center(

                        child: Text(

                          'Nenhuma ocorrência localizada.',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),

                        ),

                      );

                    }

                    return ListView.builder(

                      padding:
                          const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),

                      itemCount:
                          filtrada.length,

                    itemBuilder: (context, index) {

  final oc = filtrada[index];

  return InkWell(

  borderRadius: BorderRadius.circular(15),

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

    carregarOcorrencias();

  });

}

  },

  child: Card(

      color: const Color(0xFF07152B),

      margin: const EdgeInsets.only(
        bottom: 15,
      ),

      elevation: 8,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(

        padding: const EdgeInsets.all(18),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(

              oc['id'],

              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),

            ),

            const SizedBox(height: 10),

            Text(

              oc['tipo'],

              style: const TextStyle(
                color: Color(0xFF42A5F5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),

            ),

            const SizedBox(height: 12),

            Row(

              children: [

                const Icon(
                  Icons.calendar_month,
                  color: Colors.white70,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Text(
                  oc['data'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(width: 25),

                const Icon(
                  Icons.access_time,
                  color: Colors.white70,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Text(
                  oc['hora'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

              ],

            ),

            const SizedBox(height: 15),

            Row(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Expanded(

                  child: Text(

                    oc['local'],

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),

                  ),

                ),

              ],

            ),

            const SizedBox(height: 15),

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