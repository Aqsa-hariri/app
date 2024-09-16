import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/electronic_tasbeeh.dart';

import 'prayer_times.dart';
import 'quiblah_page.dart';
import 'quran_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مشكاة',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.amber,
        fontFamily: GoogleFonts.cairo().fontFamily,
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'القرآن الكريم',
                style: GoogleFonts.cairo(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavButton(context, 'قائمة السور', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuranPage()),
                        );
                      }),
                      const SizedBox(height: 20),
                      _buildNavButton(context, 'مواقيت الصلاة', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrayerTimesPage()),
                        );
                      }),
                      const SizedBox(height: 20),
                      _buildNavButton(context, 'القبلة', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QiblahScreen()),
                        );
                      }),
                      const SizedBox(height: 20),
                      _buildNavButton(context, ' السبحة', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ElectronicTasbeeh()),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
