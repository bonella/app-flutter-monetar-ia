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
      print('Enviando mensagem: $text');
      var response = await requestHttp.chatWithAI(text);

      print('Resposta da API: ${response.body}');

      if (response.statusCode == 200) {
        String aiResponse = utf8.decode(response.bodyBytes);
        if (aiResponse.isNotEmpty) {
          historic.add(aiResponse);
          _scrollToBottom();
          await _typeResponse(aiResponse);
        } else {
          historic.add('Erro: resposta da IA vazia');
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
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  void _sendUserMessage(String text) {
    setState(() {
      historic.add(text);
    });
    sendMessage(text);
    message.clear();
    _scrollToBottom();
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
                width: double.infinity,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFF697077),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Monetar.IA',
                      style: TextStyle(
                        fontFamily: 'Kumbh Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 36,
                        letterSpacing: 0.04,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'lib/assets/monetar_rosto.png',
                      height: 80,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Como posso ajudar?',
                      style: TextStyle(
                        fontFamily: 'Kumbh Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: message,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onFieldSubmitted: (text) {
                                      if (text.isNotEmpty) {
                                        _sendUserMessage(text);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Digite sua mensagem',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF003566), width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                      labelStyle: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 16),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Chama `sendMessage` ao pressionar o ícone "enviar"
                                    if (message.text.isNotEmpty) {
                                      _sendUserMessage(message.text);
                                    }
                                  },
                                  icon: const Icon(Icons.send),
                                  splashRadius: 1,
                                  color: const Color(0xFF3D5936),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
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
              onPressed: () async {
                if (listening) {
                  setState(() {
                    listening = false;
                  });
                  await _speechToText.stop();
                } else {
                  setState(() {
                    listening = true;
                  });
                  await _speechToText.listen(onResult: (result) {
                    setState(() {
                      message.text = result.recognizedWords;
                    });
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
