import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monetar_ia/components/headers/header_login.dart';
import 'package:monetar_ia/components/cards/card_title_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return const Scaffold(
      body: Column(
        children: <Widget>[
          HeaderLogin(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CardTitleLogin(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
