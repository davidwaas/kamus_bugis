import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart';

class kalimatPage extends StatefulWidget {
  const kalimatPage({super.key});

  @override
  State<kalimatPage> createState() => _kalimatPageState();
}

class _kalimatPageState extends State<kalimatPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';
  List<Map<String, dynamic>> _allWords = [];

  List<String> languages = ['bugis', 'indonesia', 'inggris'];
  String _sourceLang = 'indonesia';
  String _targetLang = 'bugis';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadWords();
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

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      String localeId;
      switch (_sourceLang) {
        case 'indonesia':
          localeId = 'id_ID';
          break;
        case 'inggris':
          localeId = 'en_US';
          break;
        default:
          localeId = 'id_ID';
      }
      await _speech.listen(
        localeId: localeId,
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
            _controller.text = _spokenText;
          });
        },
      );
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final TextEditingController _controller = TextEditingController();
  String? _result;

  String _translateSentence(String sentence) {
    final wordRegExp = RegExp(r"[\w']+|[.,!?;]");
    final tokens =
        wordRegExp.allMatches(sentence).map((m) => m.group(0)!).toList();
    List<String> translatedTokens = [];

    for (String token in tokens) {
      if (RegExp(r'[.,!?;]').hasMatch(token)) {
        translatedTokens.add(token);
      } else {
        final found = _allWords.firstWhere((word) {
          final value = word[_sourceLang];
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
            found[_targetLang] != null &&
            found[_targetLang].toString().isNotEmpty) {
          final targetValue = found[_targetLang];
          if (targetValue is List) {
            translatedTokens.add(targetValue[0].toString());
          } else {
            translatedTokens.add(targetValue.toString());
          }
        } else {
          translatedTokens.add('[?]');
        }
      }
    }
    return translatedTokens.join(' ');
  }

  void _searchWord() {
    final input = _controller.text.trim();
    setState(() {
      _result = _translateSentence(input);
    });
  }

  final FlutterTts flutterTts = FlutterTts();
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(
      _targetLang == 'inggris'
          ? 'en-US'
          : _targetLang == 'indonesia'
          ? 'id-ID'
          : 'id-ID',
    );
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalimat',
          style: GoogleFonts.lilitaOne(
            fontSize: screenWidth * 0.06,
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      backgroundColor: Colors.orange.shade50,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ListView(
          children: [
            // Dropdown Bahasa Masukan dan Tujuan
            Text(
              'Pilih Bahasa',
              style: GoogleFonts.lilitaOne(
                fontSize: screenWidth * 0.05,
                color: Colors.brown,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _sourceLang,
                    onChanged: (value) {
                      setState(() {
                        _sourceLang = value!;
                        if (_sourceLang == _targetLang) {
                          _targetLang = languages.firstWhere(
                            (lang) => lang != _sourceLang,
                          );
                        }
                      });
                    },
                    items:
                        languages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(
                              'Dari: ${lang.toUpperCase()}',
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(width: screenWidth * 0.06),
                Expanded(
                  child: DropdownButton<String>(
                    value: _targetLang,
                    onChanged: (value) {
                      setState(() {
                        _targetLang = value!;
                      });
                    },
                    items:
                        languages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(
                              'Ke: ${lang.toUpperCase()}',
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),

            // Kotak input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Masukkan kata atau kalimat',
                hintText: "Contoh: Saya Makan",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                hintStyle: TextStyle(fontSize: screenWidth * 0.045),
              ),
              style: TextStyle(fontSize: screenWidth * 0.045),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Tombol rekam
            Center(
              child: SizedBox(
                width: screenWidth * 0.55,
                height: screenHeight * 0.06,
                child: ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(
                    color: Colors.brown,
                    _isListening ? Icons.stop : Icons.mic,
                    size: screenWidth * 0.07,
                  ),
                  label: Text(
                    _isListening ? 'Berhenti' : 'Rekam',
                    style: GoogleFonts.lilitaOne(
                      fontSize: screenWidth * 0.045,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.012),

            // Tombol terjemahkan
            Center(
              child: SizedBox(
                width: screenWidth * 0.55,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: _searchWord,
                  child: Text(
                    'Terjemahkan',
                    style: GoogleFonts.lilitaOne(
                      fontSize: screenWidth * 0.045,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Hasil terjemahan
            if (_result != null)
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _result!,
                        style: TextStyle(fontSize: screenWidth * 0.048),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.012),
                    SizedBox(
                      width: screenWidth * 0.55,
                      height: screenHeight * 0.06,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _speak(_result!);
                        },
                        icon: Icon(Icons.volume_up, size: screenWidth * 0.07),
                        label: Text(
                          'Dengarkan',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
