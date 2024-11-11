import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Container(
        color: const Color(0xFFE4F2E6),
        child: Column(
          children: <Widget>[
            const HeaderLogin(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFA9BF99),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 20),
                      child: const Center(
                        child: Text(
                          'Monetar.ia',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 50,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF738C61),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Qual sua próxima meta?',
                              style: TextStyle(
                                fontFamily: 'Kantumruy',
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Image.asset(
                              'lib/assets/monetar_corpo2.png',
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
