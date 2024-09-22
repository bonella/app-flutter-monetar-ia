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
  final SpeechToText _speechToText = SpeechToText();
  TextEditingController message = TextEditingController();
  List<String> historic = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPermissionMIC();
  }

  Future<void> getPermissionMIC() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      setState(() {
        historic.add('Microfone não disponível');
      });
    }
  }

  Future<void> sendMessage(String text) async {
    var model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyDVtWjFoY9bBwKB4uUkhWMg2AT2-Y7aW5U');
    var content = [Content.text(text)];
    var response = await model.generateContent(content);

    if (response.text != null) {
      historic.add(response.text!);
      _scrollToBottom();
      await _typeResponse(response.text!);
    }
  }

  Future<void> _typeResponse(String response) async {
    String displayedText = '';
    for (int i = 0; i < response.length; i++) {
      displayedText += response[i];
      setState(() {
        historic[historic.length - 1] = displayedText;
      });
      _scrollToBottom();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
                subtitle: 'Assistente Monetar.ia',
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
                          controller: _scrollController,
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
                                    textCapitalization: TextCapitalization
                                        .sentences, // Capitalização
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            if (message.text.isNotEmpty) {
                                              setState(() {
                                                historic.add(message.text);
                                              });
                                              sendMessage(message.text);
                                              message.clear();
                                              _scrollToBottom();
                                            }
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
                        if (result.finalResult) {
                          listening = false;
                          historic.add(result.recognizedWords);
                          sendMessage(result.recognizedWords);
                          _scrollToBottom();
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
