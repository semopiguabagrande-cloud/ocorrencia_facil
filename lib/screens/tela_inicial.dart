import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() =>
      _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 4),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final mobile =
        MediaQuery.of(context).size.width <
            600;

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          mobile
              ? 'assets/images/background_login.png'
              : 'assets/images/viatura.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}