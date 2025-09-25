import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class percakapanPage extends StatefulWidget {
  @override
  State<percakapanPage> createState() => _percakapanPageState();
}

class _percakapanPageState extends State<percakapanPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  bool _isListening = false;
  String _translatedText = "Hasil Terjemahan";

  final List<String> languages = ['bugis', 'indonesia', 'inggris'];
  String sourceLang = 'indonesia';
  String targetLang = 'bugis';

  List<Map<String, dynamic>> _allWords = [];

  Timer? _silenceTimer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _requestMicPermission();
    _loadWords();
  }

  Future<void> _requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> _loadWords() async {
    final String jsonString = await rootBundle.loadString(
      'assets/kosakata.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _allWords = jsonData.cast<Map<String, dynamic>>();
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);

        await _speech.listen(
          localeId: sourceLang == 'inggris' ? 'en_US' : 'id_ID',
          onResult: (val) async {
            // Reset timer setiap ada suara
            _silenceTimer?.cancel();
            _silenceTimer = Timer(const Duration(seconds: 3), () {
              _speech.stop();
              setState(() => _isListening = false);
            });

            await _searchWord(val.recognizedWords);
          },
        );

        // Mulai timer saat mulai rekaman
        _silenceTimer = Timer(const Duration(seconds: 3), () {
          _speech.stop();
          setState(() => _isListening = false);
        });
      }
    } else {
      _silenceTimer?.cancel();
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _speak() async {
    await _flutterTts.setLanguage(
      targetLang == 'inggris'
          ? 'en-US'
          : targetLang == 'indonesia'
          ? 'id-ID'
          : 'id-ID', // fallback untuk bahasa lokal
    );
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(_translatedText);
  }

  Future<void> _searchWord(String input) async {
    final wordRegExp = RegExp(r"[\w']+|[.,!?;]");
    final tokens =
        wordRegExp.allMatches(input).map((m) => m.group(0)!).toList();
    List<String> translatedTokens = [];

    int i = 0;
    while (i < tokens.length) {
      // Cek frasa 2 kata
      String twoToken = '';
      if (i + 1 < tokens.length) {
        twoToken = '${tokens[i]} ${tokens[i + 1]}'.toLowerCase();
        final foundPhrase = _allWords.firstWhere((word) {
          final value = word[sourceLang];
          if (value is List) {
            return value
                .map((v) => v.toString().toLowerCase())
                .contains(twoToken);
          } else if (value is String) {
            return value.toLowerCase() == twoToken;
          }
          return false;
        }, orElse: () => {});
        if (foundPhrase.isNotEmpty &&
            foundPhrase[targetLang] != null &&
            foundPhrase[targetLang].toString().isNotEmpty) {
          final targetValue = foundPhrase[targetLang];
          translatedTokens.add(
            targetValue is List ? targetValue[0] : targetValue.toString(),
          );
          i += 2;
          continue;
        }
      }
      // Cek satu kata
      final token = tokens[i];
      if (RegExp(r'[.,!?;]').hasMatch(token)) {
        translatedTokens.add(token);
      } else {
        final found = _allWords.firstWhere((word) {
          final value = word[sourceLang];
          if (value is List) {
            return value
                .map((v) => v.toString().toLowerCase())
                .contains(token.toLowerCase());
          } else if (value is String) {
            return value.toLowerCase() == token.toLowerCase();
          }
          return false;
        }, orElse: () => {});
        if (found.isNotEmpty &&
            found[targetLang] != null &&
            found[targetLang].toString().isNotEmpty) {
          final targetValue = found[targetLang];
          translatedTokens.add(
            targetValue is List ? targetValue[0] : targetValue.toString(),
          );
        } else {
          translatedTokens.add('[?]');
        }
      }
      i++;
    }

    setState(() {
      _translatedText = _combineTokens(translatedTokens);
    });
  }

  String _combineTokens(List<String> tokens) {
    final buffer = StringBuffer();
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      if (i > 0 && !RegExp(r'[.,!?;]').hasMatch(token)) {
        buffer.write(' ');
      }
      buffer.write(token);
    }
    return buffer.toString();
  }

  Widget languageSelector(String selected, ValueChanged<String?> onChanged) {
    return DropdownButton2<String>(
      value: selected,
      items:
          languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang,
              child: Text(lang.toUpperCase()),
            );
          }).toList(),
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: 40,
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      dropdownStyleData: DropdownStyleData(maxHeight: 120),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Percakapan',
          style: GoogleFonts.lilitaOne(
            fontSize: screenWidth * 0.06,
            color: Colors.brown,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.07),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: ListView(
            children: [
              Text(
                'Pilih Bahasa',
                style: GoogleFonts.lilitaOne(
                  fontSize: screenWidth * 0.05,
                  color: Colors.brown,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  languageSelector(sourceLang, (val) {
                    if (val != null) setState(() => sourceLang = val);
                  }),
                  SizedBox(width: screenWidth * 0.02),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Tukar bahasa asal dan tujuan
                        final temp = sourceLang;
                        sourceLang = targetLang;
                        targetLang = temp;
                      });
                    },
                    child: Icon(Icons.compare_arrows, size: screenWidth * 0.07),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  languageSelector(targetLang, (val) {
                    if (val != null) setState(() => targetLang = val);
                  }),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              IconButton(
                icon: Icon(
                  _isListening
                      ? Icons.stop_circle
                      : Icons.mic, // berubah saat rekaman
                  color: Colors.brown,
                  size: screenWidth * 0.13,
                ),
                onPressed: _listen,
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _translatedText,
                        style: GoogleFonts.lilitaOne(
                          color: Colors.brown,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.volume_up,
                        color: Colors.brown,
                        size: screenWidth * 0.08,
                      ),
                      onPressed: () async {
                        await _speak();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
