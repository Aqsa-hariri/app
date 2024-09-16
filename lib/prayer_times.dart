import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  PrayerTimes? _prayerTimes;
  String _location = 'جاري تحديد الموقع...';

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndGetPrayerTimes();
  }

  Future<void> _checkPermissionsAndGetPrayerTimes() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      _getPrayerTimes();
    } else if (status.isDenied) {
      // Request permission
      final result = await Permission.location.request();
      if (result.isGranted) {
        _getPrayerTimes();
      } else {
        setState(() {
          _location = 'الرجاء منح إذن الوصول إلى الموقع';
        });
      }
    } else {
      setState(() {
        _location = 'الرجاء منح إذن الوصول إلى الموقع';
      });
    }
  }

  Future<void> _getPrayerTimes() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;

      final date = DateComponents.from(DateTime.now());
      final prayerTimes = PrayerTimes(coordinates, date, params);

      setState(() {
        _prayerTimes = prayerTimes;
        _location =
            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      print('Error getting prayer times: $e');
      setState(() {
        _location = 'حدث خطأ في تحديد الموقع';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواقيت الصلاة',
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
          child: _prayerTimes == null
              ? const CircularProgressIndicator(color: Colors.deepPurple)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'مواقيت الصلاة',
                      style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 20),
                    _buildPrayerTimeCard('الفجر', _prayerTimes!.fajr),
                    _buildPrayerTimeCard('الشروق', _prayerTimes!.sunrise),
                    _buildPrayerTimeCard('الظهر', _prayerTimes!.dhuhr),
                    _buildPrayerTimeCard('العصر', _prayerTimes!.asr),
                    _buildPrayerTimeCard('المغرب', _prayerTimes!.maghrib),
                    _buildPrayerTimeCard('العشاء', _prayerTimes!.isha),
                    const SizedBox(height: 20),
                    Text(
                      _location,
                      style: GoogleFonts.cairo(
                          fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeCard(String prayerName, DateTime? time) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prayerName,
              style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            Text(
              _formatTime(time),
              style: GoogleFonts.cairo(fontSize: 18, color: Colors.amber[800]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? time) {
    return time != null ? DateFormat.jm().format(time.toLocal()) : 'N/A';
  }
}
