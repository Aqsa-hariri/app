import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ElectronicTasbeeh extends StatefulWidget {
  const ElectronicTasbeeh({super.key});

  @override
  _ElectronicTasbeehState createState() => _ElectronicTasbeehState();
}

class _ElectronicTasbeehState extends State<ElectronicTasbeeh> {
  int _counter = 0;
  final int _target = 100;

  void _incrementCounter() {
    HapticFeedback.lightImpact();
    setState(() {
      _counter++;
      if (_counter >= _target) {
        _showCompletionDialog();
      }
    });
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
          title: const Text('أكملت التسبيح'),
          content: Text('لقد أكملت $_target تسبيحة. هل تريد البدء من جديد؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('نعم'),
              onPressed: () {
                _resetCounter();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('لا'),
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
        title: const Text('السبحة الإلكترونية'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'عدد التسبيحات:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _counter / _target,
                    strokeWidth: 15,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
                Text(
                  '$_counter',
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('تسبيح', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _resetCounter,
              child: const Text('إعادة ضبط', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
