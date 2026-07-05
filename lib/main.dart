import 'package:flutter/material.dart';
import 'screens/tela_inicial.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OcorrenciaFacilApp());
}

class OcorrenciaFacilApp extends StatelessWidget {
  const OcorrenciaFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ocorrência Fácil',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}