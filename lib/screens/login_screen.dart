import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final senhaController =
      TextEditingController();
      bool carregando = false;

      Future<void> fazerLogin() async {

  if (senhaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Digite a senha'),
      ),
    );
    return;
  }

  setState(() {
    carregando = true;
  });

  final resultado =
      await ApiService.login(
    senhaController.text,
  );

  setState(() {
    carregando = false;
  });

  if (resultado == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Erro de conexão'),
      ),
    );
    return;
  }

  if (resultado['sucesso'] == true) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          nome: resultado['nome'],
          matricula:
              resultado['matricula']
                  .toString(),
          perfil:
              resultado['perfil'],
        ),
      ),
    );

  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Senha inválida',
        ),
      ),
    );

  }
}
  @override
  Widget build(BuildContext context) {

    final largura =
        MediaQuery.of(context).size.width;

    final mobile = largura < 600;

    return Scaffold(
      body: Stack(
        children: [

          /// FUNDO
          Positioned.fill(
            child: Image.asset(
              mobile
                  ? 'assets/images/background_login.png'
                  : 'assets/images/viatura.png',
              fit: BoxFit.cover,
            ),
          ),

          /// ESCURECE O FUNDO
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(
                0.65,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 20),

                /// TÍTULO
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(
                    children: [

                      Text(
                        'REGISTRO DE OCORRÊNCIAS',
                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          color: Colors.white,

                          fontSize:
                              mobile
                                  ? 22
                                  : 34,

                          fontWeight:
                              FontWeight.bold,

                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'GUARDA CIVIL MUNICIPAL DE IGUABA GRANDE',
                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          color:
                              Colors.white70,

                          fontSize:
                              mobile
                                  ? 14
                                  : 18,

                          letterSpacing:
                              0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment:
                        Alignment.topCenter,

                    child:
                        SingleChildScrollView(
                      child: Container(
                        width:
                            mobile
                                ? largura * 0.92
                                : 650,

                        margin:
                            const EdgeInsets.only(
                          top: 30,
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),

                        padding:
                            const EdgeInsets.all(
                          35,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                                0xFF07152B,
                              ).withOpacity(
                                0.92,
                              ),

                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),

                          border:
                              Border.all(
                            color:
                                Colors.white24,
                          ),

                          boxShadow: const [
                            BoxShadow(
                              color:
                                  Colors.black54,
                              blurRadius: 20,
                              offset:
                                  Offset(0, 10),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: [

                            const Icon(
                              Icons
                                  .admin_panel_settings,
                              color:
                                  Colors.white,
                              size: 70,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            const Text(
                              'ACESSO AO SISTEMA',
                              textAlign:
                                  TextAlign.center,

                              style:
                                  TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 30,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              'Digite sua senha para continuar',
                              textAlign:
                                  TextAlign.center,

                              style:
                                  TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            TextField(
                              controller:
                                  senhaController,

                              obscureText:
                                  true,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),

                              decoration:
                                  InputDecoration(
                                labelText:
                                    'Senha',

                                labelStyle:
                                    const TextStyle(
                                  color:
                                      Colors.white70,
                                ),

                                prefixIcon:
                                    const Icon(
                                  Icons.lock,
                                  color:
                                      Colors.white,
                                ),

                                filled: true,

                                fillColor:
                                    Colors.white10,

                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    15,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            SizedBox(
                              width:
                                  double.infinity,

                              height: 60,

                              child:
                                  ElevatedButton(
                                onPressed: carregando
    ? null
    : fazerLogin,

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(
                                    0xFF0A4FBF,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                ),

                                child: carregando
    ? const CircularProgressIndicator(
        color: Colors.white,
      )
    : const Text(
        'ACESSAR',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
                              ),
                            ),

                            const SizedBox(
                              height: 25,
                            ),

                            const Row(
                              children: [

                                Icon(
                                  Icons.security,
                                  color:
                                      Colors.white70,
                                ),

                                SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child:
                                      Text(
                                    'Sistema restrito para agentes autorizados',
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}