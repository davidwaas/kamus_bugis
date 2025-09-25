import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> _allQuestions = [
    // Kosakata
    {
      'type': 'kosakata',
      'image': 'assets/1.png',
      'question':
          'Pada gambar di atas, anak kecil sedang tidur. Tidur dalam bahasa Bugis adalah?',
      'options': ['Manre', 'Minung', 'Matinro', 'Macawa'],
      'answer': 'Matinro',
    },
    {
      'type': 'kosakata',
      'image': 'assets/3.jpg',
      'question':
          'Gambar di atas menunjukkan musim hujan. Hujan dalam bahasa Bugis adalah?',
      'options': ['Bosi', 'Sulo', 'Tasi', 'Salo'],
      'answer': 'Bosi',
    },
    {
      'type': 'kosakata',
      'image': 'assets/4.png',
      'question': "Sebutkan buah di atas dalam bahasa Bugis...",
      'options': ['Lemo', 'Pandang', 'Apel', 'Pao'],
      'answer': 'Pao',
    },
    {
      'type': 'kosakata',
      'image': 'assets/5.png',
      'question':
          "Gambar di atas menunjukkan orang yang sedang makan. Apa kata makan dalam bahasa Bugis ",
      'options': ['Sembahyang', "Matinro", 'Manre', 'Minung'],
      'answer': "Manre",
    },
    {
      'type': 'kosakata',
      'image': 'assets/9.png',
      'question':
          "Sebutkan kegiatan apa yang sedang dilakukan pada gambar di atas menggunakan bahasa Bugis.",
      'options': ['Sembahyang', "Matinro", 'Manre', 'Minung'],
      'answer': "Sembahyang",
    },
    // Kalimat
    {
      'type': 'kalimat',
      'question': "Naiya (...) léngko, déng tu mattama ri lalong.",
      'options': ['Kasi', 'Mabbaca', 'Melok', 'Sutta'],
      'answer': 'Mabbaca',
    },
    {
      'type': 'kalimat',
      'question': "Iyya (...) manre garongkong.",
      'options': ['Mettong', "Mettu", 'Mabbaca', 'Engka'],
      'answer': 'Mettong',
    },
    {
      'type': 'kalimat',
      'question': "Ana'é (...) lao ri léwako.",
      'options': ["Masek", 'Maowa', 'Keman', 'Makkita'],
      'answer': "Masek",
    },
    {
      'type': 'kalimat',
      'question': "(...) ta lufai manre!",
      'options': ['Aja', 'Yé', "De'na", 'Niga'],
      'answer': 'Aja',
    },
    {
      'type': 'kalimat',
      'question': "Pekerjaan ini berat tapi (...) melekai.",
      'options': ['Mabbaca', 'Macek', 'Engka', 'Mattama'],
      'answer': 'Engka',
    },

    // Percakapan
    {
      'type': 'percakapan',
      'context': [
        {'speaker': 'A', 'text': 'Assalamualaikum!'},
        {'speaker': 'B', 'text': "Waalaikumsalam! Pattama'mu mako"},
      ],
      'question': "Apa arti dari kalimat yang diucapkan B?",
      'options': [
        "Jangan Masuk!",
        'Tutup Pintu',
        'Pergi Sana',
        'Silahkan Masuk',
      ],
      'answer': "Silahkan Masuk",
    },
    {
      'type': 'percakapan',
      'context': [
        {'speaker': 'A', 'text': 'Engka ko ri bonto?'},
        {'speaker': 'B', 'text': "La'bi ri dallekku"},
      ],
      'question': "Di mana B berada?",
      'options': ["di depan", 'di belakang', 'di samping', 'di bawah'],
      'answer': "di depan",
    },
    {
      'type': 'percakapan',
      'context': [
        {'speaker': 'A', 'text': 'Mapparilalengmu?'},
        {'speaker': 'B', 'text': "Maji-maji'i"},
      ],
      'question': "Bagaimana keadaan B?",
      'options': [
        "Tidak baik-baik saja",
        'Sakit',
        'Tidak baik',
        'Baik-baik saja',
      ],
      'answer': "Baik-baik saja",
    },
    {
      'type': 'percakapan',
      'context': [
        {'speaker': 'A', 'text': 'Asi\'mu ?'},
        {'speaker': 'B', 'text': "Sitiro"},
      ],
      'question': "Apa yang B inginkan?",
      'options': ["Air putih", 'Kopi', 'Susu', 'Teh'],
      'answer': "Kopi",
    },
    {
      'type': 'percakapan',
      'context': [
        {'speaker': 'A', 'text': 'Apa narekko tona muna?'},
        {'speaker': 'B', 'text': "Nitaro mako panggau "},
      ],
      'question': "Apa yang akan B makan nanti?",
      'options': ["Singkong", 'Pepaya', 'Pisang', 'Apel'],
      'answer': "Pisang",
    },

    // Tambahkan soal lain disini
  ];

  List<Map<String, Object>> _questions = [];

  @override
  void initState() {
    super.initState();
    _questions = _getLimitedQuestions();
  }

  List<Map<String, Object>> _getLimitedQuestions() {
    List<Map<String, Object>> kosakata = [];
    List<Map<String, Object>> kalimat = [];
    List<Map<String, Object>> percakapan = [];

    // Kumpulkan semua soal per tipe
    for (var q in _allQuestions) {
      if (q['type'] == 'kosakata') {
        kosakata.add(q);
      } else if (q['type'] == 'kalimat') {
        kalimat.add(q);
      } else if (q['type'] == 'percakapan') {
        percakapan.add(q);
      }
    }

    // Acak urutan soal tiap tipe
    kosakata.shuffle();
    kalimat.shuffle();
    percakapan.shuffle();

    // Ambil 5 soal pertama dari tiap tipe
    List<Map<String, Object>> selectedKosakata = kosakata.take(5).toList();
    List<Map<String, Object>> selectedKalimat = kalimat.take(5).toList();
    List<Map<String, Object>> selectedPercakapan = percakapan.take(5).toList();

    // Gabungkan dan acak urutan keseluruhan soal
    List<Map<String, Object>> combined = [
      ...selectedKosakata,
      ...selectedKalimat,
      ...selectedPercakapan,
    ];
    combined.shuffle();

    return combined;
  }

  final FlutterTts _flutterTts = FlutterTts();

  int _currentQuestion = 0;
  int _score = 0;
  bool _quizFinished = false;

  // Tambahkan variabel untuk menandai pilihan yang sedang ditekan
  int? _pressedOptionIndex;

  Future<void> _playTTS(String text, {double pitch = 1.0}) async {
    await _flutterTts.setLanguage('id-ID');
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(0.57);
    await _flutterTts.speak(text);
  }

  void _answerQuestion(String selectedOption) {
    if (selectedOption == _questions[_currentQuestion]['answer']) {
      _score++;
    }
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _quizFinished = false;
    });
  }

  String _getInstruction(String? type) {
    switch (type) {
      case 'kosakata':
        return 'Petunjuk:\nLihat gambar, kemudian pilihlah jawaban yang benar sesuai dengan gambar tersebut.';
      case 'kalimat':
        return 'Petunjuk:\nLengkapi kalimat dengan pilihan jawaban yang paling tepat.';
      case 'percakapan':
        return 'Petunjuk:\nDengarkan audio, kemudian pilihlah jawaban yang sesuai dengan percakapan.';
      default:
        return 'Petunjuk:\nPilihlah jawaban yang paling tepat.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final question = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis Gabungan',
          style: GoogleFonts.lilitaOne(
            fontSize: screenWidth * 0.055,
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
            _quizFinished
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '~ KUIS SELESAI ~',
                      style: GoogleFonts.lilitaOne(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    Text(
                      'SELAMAT:',
                      style: GoogleFonts.lilitaOne(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    Text(
                      'Jawaban Benar Anda: $_score/${_questions.length}',
                      style: GoogleFonts.abel(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        onPressed: _resetQuiz,
                        child: Text(
                          'Ulangi Kuis',
                          style: GoogleFonts.lilitaOne(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Petunjuk pengerjaan soal
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getInstruction(question['type'] as String?),
                        style: GoogleFonts.abel(fontSize: screenWidth * 0.04),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Text(
                      'Soal ${_currentQuestion + 1} dari ${_questions.length}',
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (question['type'] == 'kosakata' &&
                        question['image'] != null)
                      Image.asset(
                        question['image'] as String,
                        height: screenHeight * 0.20,
                      ),
                    if (question['type'] == 'percakapan' &&
                        question['context'] != null)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.volume_up,
                              size: screenWidth * 0.10,
                              color: Colors.brown,
                            ),
                            onPressed: () async {
                              // Gabungkan semua teks dialog jadi satu string dengan suara berbeda
                              final dialogs = question['context'] as List;
                              for (var dialog in dialogs) {
                                final text =
                                    (dialog as Map<String, dynamic>)['text']
                                        as String;
                                double pitch =
                                    (dialog['speaker'] == 'A') ? 1.5 : 0.3;
                                await _playTTS(text, pitch: pitch);
                                await Future.delayed(
                                  const Duration(milliseconds: 1500),
                                );
                              }
                            },
                          ),
                          Text(
                            'Putar percakapan',
                            style: GoogleFonts.abel(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      question['question'] as String,
                      style: GoogleFonts.abel(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ...(question['options'] as List<String>)
                        .asMap()
                        .entries
                        .map((entry) {
                          int idx = entry.key;
                          String option = entry.value;
                          bool isPressed = _pressedOptionIndex == idx;
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: screenHeight * 0.012,
                            ),
                            child: GestureDetector(
                              onTap: () => _answerQuestion(option),
                              onTapDown: (_) {
                                setState(() {
                                  _pressedOptionIndex = idx;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _pressedOptionIndex = null;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _pressedOptionIndex = null;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 100),
                                decoration: BoxDecoration(
                                  color:
                                      isPressed
                                          ? Colors.brown.shade100
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.brown.shade100,
                                  ),
                                ),
                                height: screenHeight * 0.06,
                                alignment: Alignment.center,
                                child: Text(
                                  option,
                                  style: GoogleFonts.abel(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
