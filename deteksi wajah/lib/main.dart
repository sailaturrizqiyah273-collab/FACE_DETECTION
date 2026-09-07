import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:si_wajah/firebase_options.dart';
import 'package:si_wajah/pages/login_page.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp (
    options : DefaultFirebaseOptions . currentPlatform , 
);

  runApp(const AbsensiDinasApp());
}


class AbsensiDinasApp extends StatelessWidget {
  const AbsensiDinasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi Dinas',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const LoginPage(),
    );
  }
}


class AttendanceRecord {
  final String date;
  final String time;
  final String type;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.time,
    required this.type,
    required this.status,
  });
}

// Data sementara
final List<AttendanceRecord> attendanceRecords = [];