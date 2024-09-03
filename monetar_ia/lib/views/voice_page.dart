import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:monetar_ia/components/headers/header_first_steps.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  bool listening = false;
  String text = '';
  final SpeechToText _speechToText = SpeechToText();
  TextEditingController message = TextEditingController();

  List<String> historic = [];

  @override
  void initState() {
    super.initState();
    getPermissionMIC();
  }

  Future<void> getPermissionMIC() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      setState(() {
        text = 'Microfone não disponível';
      });
    }
  }

  Future<void> sendMessage(String text) async {
    var model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyDVtWjFoY9bBwKB4uUkhWMg2AT2-Y7aW5U');
    var content = [Content.text(text)];
    var response = await model.generateContent(content);
    setState(() {
      if (response.text != null) {
        historic.add(response.text!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const HeaderFirstSteps(
                title: 'Monetar.ia',
                subtitle: 'Página de Voz',
                backgroundColor: Color(0xFF697077),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 20,
                        child: ListView.builder(
                          itemCount: historic.length,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: (index % 2) == 0
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: (index % 2) == 0
                                        ? const Color.fromARGB(
                                            208, 165, 163, 163)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  historic[index],
                                  style:
                                      const TextStyle(color: Color(0xFF3D5936)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      WhiteCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Fale algo ou digite uma mensagem:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: message,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              historic.add(message.text);
                                            });
                                            sendMessage(message.text);
                                            message.clear();
                                          },
                                          icon: const Icon(Icons.send),
                                          splashRadius: 1,
                                          color: const Color(0xFF3D5936),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Footer(
                backgroundColor: Color(0xFF697077),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: RoundButton(
              icon: listening ? Icons.stop : Icons.mic,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFF697077),
              iconColor:
                  listening ? const Color(0xFF8C1C03) : const Color(0xFF3D5936),
              onPressed: () {
                if (!listening) {
                  setState(() {
                    listening = true;
                  });

                  _speechToText.listen(
                    listenFor: const Duration(seconds: 15),
                    onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                        if (result.finalResult) {
                          listening = false;
                          historic.add(text);
                          sendMessage(text);
                        }
                      });
                    },
                  );
                } else {
                  setState(() {
                    listening = false;
                    _speechToText.stop();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
