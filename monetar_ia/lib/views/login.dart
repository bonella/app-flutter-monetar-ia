import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monetar_ia/components/headers/header_login.dart';
import 'package:monetar_ia/components/cards/card_title_login.dart';
import 'package:monetar_ia/components/buttons/btn_scroll.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isBtnScrollVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final offset = _scrollController.offset;
        setState(() {
          _isBtnScrollVisible = offset <= 100;
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    // Retornar false impede que a página atual seja removida da pilha de navegação.
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          color: const Color(0xFFE4F2E6),
          child: Column(
            children: <Widget>[
              const HeaderLogin(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CardTitleLogin(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _isBtnScrollVisible
            ? BtnScroll(scrollController: _scrollController)
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
