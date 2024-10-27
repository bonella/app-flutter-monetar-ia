import 'package:flutter/material.dart';

class CardTest extends StatelessWidget {
  const CardTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('Titulo'),
                  Text('Titulo'),
                  Text('Titulo'),
                ],
              ),
              Column(
                children: [Text('23')],
              )
            ],
          ),
        ),
      ),
    );
  }
}
