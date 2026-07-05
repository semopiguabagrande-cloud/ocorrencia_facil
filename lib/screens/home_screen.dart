import 'package:flutter/material.dart';
import 'nova_ocorrencia_screen.dart';
import 'minhas_ocorrencias_screen.dart';
import 'todas_ocorrencias_screen.dart';

class HomeScreen extends StatelessWidget {
  final String nome;
  final String matricula;
  final String perfil;

  const HomeScreen({
    super.key,
    required this.nome,
    required this.matricula,
    required this.perfil,
  });

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    if (largura < 900) {
      return _mobile(context);
    }

    return _desktop(context);
  }


  // ==========================
  // DESKTOP
  // ==========================

  Widget _desktop(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/fundo_pc.png',
            ),
            fit: BoxFit.cover,
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Container(
                width: 700,
                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color:
                      Colors.black.withOpacity(
                    0.35,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    25,
                  ),

                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),

                child: Row(
                  children: [

                    const CircleAvatar(
                      radius: 45,
                      backgroundColor:
                          Color(0xFF1E88E5),

                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),

                    const SizedBox(width: 20),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          nome,
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(
                          'Matrícula: $matricula',
                          style:
                              const TextStyle(
                            color:
                                Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

             Row(
  mainAxisAlignment: MainAxisAlignment.center,

  children: [

    _desktopButton(
      context,
      Icons.note_add,
      'Nova\nOcorrência',
      nome,
      matricula,
    ),

    const SizedBox(width: 30),

    _desktopButton(
      context,
      Icons.assignment,
      'Minhas\nOcorrências',
      nome,
      matricula,
    ),

    if (perfil == "ADMIN") ...[

      const SizedBox(width: 30),

      _desktopButton(
        context,
        Icons.admin_panel_settings,
        'Todas\nOcorrências',
        nome,
        matricula,
      ),

    ],

  ],

),
            ],
          ),
        ),
      ),
    );
  }

// ==========================
// MOBILE
// ==========================

Widget _mobile(BuildContext context) {
  return Scaffold(
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

      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Espaço para não cobrir o logo do fundo
              const SizedBox(height: 250),

              // CARD DO AGENTE
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                    0.35,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),

                child: Row(
                  children: [

                    const CircleAvatar(
                      radius: 35,
                      backgroundColor:
                          Color(0xFF1E88E5),

                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            nome.toUpperCase(),
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            'Matrícula: $matricula',
                            style:
                                const TextStyle(
                              color:
                                  Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // NOVA OCORRÊNCIA
              _mobileButton(
  context,
  Icons.note_add,
  'Nova Ocorrência',
  nome,
  matricula,
),

              const SizedBox(height: 20),

              // MINHAS OCORRÊNCIAS
            _mobileButton(
  context,
  Icons.assignment,
  'Minhas Ocorrências',
  nome,
  matricula,
),

if (perfil == "ADMIN") ...[

  const SizedBox(height: 20),

  _mobileButton(
    context,
    Icons.admin_panel_settings,
    'Todas Ocorrências',
    nome,
    matricula,
  ),

],

const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    ),
  );
}
// ==========================
// BOTÃO DESKTOP
// ==========================
Widget _desktopButton(
  BuildContext context,
  IconData icon,
  String titulo,
  String nome,
  String matricula,
) {
  return InkWell(

    onTap: () {

      if (titulo.contains('Nova')) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NovaOcorrenciaScreen(
              nome: nome,
              matricula: matricula,
            ),
          ),
        );

      } else if (titulo.contains('Minhas')) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MinhasOcorrenciasScreen(
              matricula: matricula,
            ),
          ),
        );

      } else if (titulo.contains('Todas')) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TodasOcorrenciasScreen(),
          ),
        );

      }

    },

    borderRadius: BorderRadius.circular(25),

    child: Container(
      width: 280,
      height: 200,

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),

        borderRadius: BorderRadius.circular(25),

        border: Border.all(
          color: Colors.white24,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 80,
            color: Colors.white,
          ),

          const SizedBox(height: 20),

          Text(
            titulo,
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],

      ),

    ),

  );

}

// ==========================
// BOTÃO MOBILE
// ==========================

Widget _mobileButton(
  BuildContext context,
  IconData icon,
  String titulo,
  String nome,
  String matricula,
) {
  return InkWell(

    onTap: () {

      if (titulo.contains('Nova')) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NovaOcorrenciaScreen(
              nome: nome,
              matricula: matricula,
            ),
          ),
        );

      } else if (titulo.contains('Minhas')) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MinhasOcorrenciasScreen(
              matricula: matricula,
            ),
          ),
        );

      } else if (titulo.contains('Todas')) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TodasOcorrenciasScreen(),
          ),
        );

      }

    },

    borderRadius: BorderRadius.circular(25),

    child: Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      height: 120,

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),

        borderRadius: BorderRadius.circular(25),

        border: Border.all(
          color: Colors.white24,
        ),
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),

          const SizedBox(width: 15),

          Text(
            titulo,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],

      ),

    ),

  );

}
}