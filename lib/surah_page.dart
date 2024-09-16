import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SurahPage extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahPage(
      {super.key, required this.surahNumber, required this.surahName});

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List<dynamic> ayahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAyahs();
  }

  Future<void> fetchAyahs() async {
    final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/surah/${widget.surahNumber}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ayahs = data['data']['ayahs'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple))
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.deepPurple.shade100, Colors.white],
                ),
              ),
              child: ListView.builder(
                itemCount: ayahs.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        ayahs[index]['text'],
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                            fontSize: 20, color: Colors.deepPurple[700]),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          ayahs[index]['numberInSurah'].toString(),
                          style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
