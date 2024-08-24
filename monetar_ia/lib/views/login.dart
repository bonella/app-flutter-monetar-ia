import 'package:flutter/material.dart';
import 'package:monetar_ia/components/header_login.dart';
import 'package:monetar_ia/components/card_title.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: <Widget>[
          HeaderLogin(),
          Positioned(
            top: 322,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CardTitle(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
