import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ElectronicTasbeeh extends StatefulWidget {
  const ElectronicTasbeeh({super.key});

  @override
  _ElectronicTasbeehState createState() => _ElectronicTasbeehState();
}

class _ElectronicTasbeehState extends State<ElectronicTasbeeh>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  final int _target = 100;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    HapticFeedback.lightImpact();
    setState(() {
      _counter++;
      if (_counter >= _target) {
        _showCompletionDialog();
      }
    });
    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('أكملت التسبيح',
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          content: Text(
            'لقد أكملت $_target تسبيحة. هل تريد البدء من جديد؟',
            style: GoogleFonts.cairo(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('نعم',
                  style: GoogleFonts.cairo(color: Colors.deepPurple)),
              onPressed: () {
                _resetCounter();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('لا', style: GoogleFonts.cairo(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('السبحة الإلكترونية',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade100, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'عدد التسبيحات',
                style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _incrementCounter,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            height: 220,
                            child: CircularProgressIndicator(
                              value: _counter / _target,
                              strokeWidth: 15,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.amber),
                            ),
                          ),
                          Text(
                            '$_counter',
                            style: GoogleFonts.cairo(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _incrementCounter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'تسبيح',
                  style: GoogleFonts.cairo(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _resetCounter,
                child: Text(
                  'إعادة ضبط',
                  style:
                      GoogleFonts.cairo(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
