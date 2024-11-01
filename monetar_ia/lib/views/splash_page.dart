import 'package:flutter/material.dart';
import 'package:monetar_ia/components/cards/card_title_login.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/headers/header_login.dart';
import 'package:monetar_ia/services/token_storage.dart';
import 'package:monetar_ia/views/home_page.dart';
import 'package:monetar_ia/views/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    await Future.delayed(const Duration(seconds: 3));

    final tokenStorage = TokenStorage();
    final token = await tokenStorage.getToken();

    if (token != null && token.isNotEmpty) {
      final isValid = await tokenStorage.isTokenValid();
      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        // Usar SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderLogin(),
            CardTitleLogin(),
            SizedBox(height: 20),
            Footer(
              backgroundColor: Color(0xFF738C61),
            ),
          ],
        ),
      ),
    );
  }
}
