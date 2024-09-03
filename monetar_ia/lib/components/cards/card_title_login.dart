import 'package:flutter/material.dart';
import 'package:monetar_ia/components/cards/card_btn_login.dart';

class CardTitleLogin extends StatelessWidget {
  const CardTitleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            margin: const EdgeInsets.only(top: 40, bottom: 20),
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
          const CardBtnLogin(),
        ],
      ),
    );
  }
}
