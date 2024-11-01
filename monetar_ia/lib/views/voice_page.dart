import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/services/request_http.dart';

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
  final RequestHttp requestHttp = RequestHttp();

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
    try {
      print('Enviando mensagem: $text'); // Verificar msg enviada
      var response = await requestHttp.chatWithAI(text);

      print('Resposta da API: ${response.body}'); // Verifica a resposta da API

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        // Verifica se "texto_gerado_ia" está presente e se não é nulo
        if (responseData['texto_gerado_ia'] != null) {
          // Decodifica o JSON contido na string
          var innerResponse = json.decode(responseData['texto_gerado_ia']);
          String aiResponse = innerResponse['response'];

          // Verifica se aiResponse não é nulo
          historic.add(aiResponse);
          _scrollToBottom();
          await _typeResponse(aiResponse);
        } else {
          historic.add('Erro: texto_gerado_ia é nulo');
          _scrollToBottom();
        }
      } else {
        historic.add('Erro: ${response.statusCode}');
        _scrollToBottom();
      }
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
      historic.add('Erro ao enviar mensagem: $e');
      _scrollToBottom();
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
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
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
              Container(
                color: const Color(0xFF697077),
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'lib/assets/logo2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Monetar.IA',
                            style: TextStyle(
                              fontFamily: 'Kumbh Sans',
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Como posso ajudar? ',
                            style: TextStyle(
                              fontFamily: 'Kumbh Sans',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset(
                              'lib/assets/monetar_rosto.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF697077),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
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
                                      ? const Color.fromARGB(208, 165, 163, 163)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                    textCapitalization:
                                        TextCapitalization.sentences,
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
