import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/components/animations/animated_mic_button.dart';

class VoicePage extends StatefulWidget {
  final String userName;
  const VoicePage({super.key, required this.userName});

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  bool listening = false;
  final SpeechToText _speechToText = SpeechToText();
  TextEditingController message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RequestHttp requestHttp = RequestHttp();

  // Controla quais respostas estão visíveis
  Map<int, bool> expandedText = {};

  @override
  void initState() {
    super.initState();
    getPermissionMIC();
  }

  Future<void> getPermissionMIC() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      setState(() {
        // Lógica para microfone não disponível
      });
    }
  }

  Future<void> _animateMicButton() async {
    setState(() {
      listening = !listening;
    });
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Função para alternar o estado de expansão do texto
  void toggleText(int index) {
    setState(() {
      expandedText[index] = !(expandedText[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 260,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5A9276), Color(0xFF3D5936)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
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
                            "Monetar.IA",
                            style: TextStyle(
                              fontFamily: 'Kumbh Sans',
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/assets/monetar_rosto.png',
                            width: 170,
                            height: 70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Muito bem ${widget.userName}",
                            style: const TextStyle(
                              fontFamily: 'Kumbh Sans',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Como posso ajudar você?",
                        style: TextStyle(
                          fontFamily: 'Kumbh Sans',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        buildExpandableButton(
                          index: 0,
                          text: "Gostaria de economizar mais",
                          response:
                              "Para economizar mais, sugiro que você revise seus gastos fixos mensais.",
                        ),
                        buildExpandableButton(
                          index: 1,
                          text: "Gostaria de bater metas financeiras",
                          response:
                              "Estabeleça metas financeiras específicas e revise seu orçamento.",
                        ),
                        buildExpandableButton(
                          index: 2,
                          text: "Não sei pra onde meu dinheiro vai",
                          response:
                              "Para entender melhor seus gastos, recomendo registrar todas as suas despesas.",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Footer(
                backgroundColor: Color(0xFF738C61),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: AnimatedMicButton(
              listening: listening,
              onPressed: () async {
                setState(() {
                  listening = !listening; // Alterna o estado
                });

                // Inicia ou para a gravação dependendo do estado
                if (listening) {
                  await _speechToText.listen(onResult: (result) {
                    setState(() {
                      message.text = result.recognizedWords;
                    });
                  });
                } else {
                  await _speechToText.stop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget para criar botões expansíveis
  // Widget para criar botões expansíveis
  Widget buildExpandableButton({
    required int index,
    required String text,
    required String response,
  }) {
    return Column(
      children: [
        BtnOutlineGreen(
          text: text,
          onPressed: () => toggleText(index),
          width: 320,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: expandedText[index] == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F0),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF738C61),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      response,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Kumbh Sans',
                        fontSize: 16,
                        color: Color(0xFF3D5936),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
