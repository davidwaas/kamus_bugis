import 'package:flutter/material.dart';
import 'package:kamus_bugis/kosakataPage.dart';
import 'package:kamus_bugis/kalimatPage.dart';
import 'package:kamus_bugis/percakapanPage.dart';
import 'package:kamus_bugis/quizPage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(KamusApp());
}

class KamusApp extends StatelessWidget {
  const KamusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kamus Bugis-Indonesia-Inggris',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: KamusHomePage(),
    );
  }
}

class KamusHomePage extends StatefulWidget {
  const KamusHomePage({super.key});

  @override
  _KamusHomePageState createState() => _KamusHomePageState();
}

class _KamusHomePageState extends State<KamusHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KAMUS BUGIS-INDONESIA-INGGRIS',
          style: GoogleFonts.lilitaOne(
            fontSize: screenWidth * 0.04, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
      ),
      body: Container(
        color: Colors.orange.shade50,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Image.asset(
                  'assets/logo.png',
                  height: screenHeight * 0.18, // Responsive image height
                ),
                SizedBox(height: screenHeight * 0.012),
                Text(
                  'KAMUS',
                  style: GoogleFonts.alkalami(
                    fontSize: screenWidth * 0.05, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 235, 0, 2),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  ' BUGIS-INDONESIA-INGGRIS',
                  style: GoogleFonts.alkalami(
                    fontSize: screenWidth * 0.045, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 235, 0, 2),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                ...['Kosakata', 'Kalimat', 'Percakapan', 'Quiz'].map((label) {
                  Widget page;
                  switch (label) {
                    case 'Kosakata':
                      page = kosakataPage();
                      break;
                    case 'Kalimat':
                      page = kalimatPage();
                      break;
                    case 'Percakapan':
                      page = percakapanPage();
                      break;
                    default:
                      page = QuizPage();
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.012),
                    child: SizedBox(
                      width: screenWidth * 0.6, // Responsive button width
                      height: screenHeight * 0.07, // Responsive button height
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => page),
                          );
                        },
                        child: Text(
                          label,
                          style: GoogleFonts.josefinSans(
                            fontSize: screenWidth * 0.06,
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
          ),
        ),
      ),
    );
  }
}
