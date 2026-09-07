import 'package:flutter/material.dart';
import 'package:si_wajah/main.dart';
import 'package:si_wajah/pages/login_page.dart';

import '../models/attendance_record.dart';
import 'face_attendance.dart';
import 'history_page.dart';
import 'profile_page.dart';
import '../widgets/absensi_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String getCurrentDate() {
    final now = DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';
  }

  String getCurrentTime() {
    final now = DateTime.now();

    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }

  bool sudahAbsenMasuk() {
    return attendanceRecords.any(
      (data) =>
          data.type == 'Absen Masuk' &&
          data.date == getCurrentDate(),
    );
  }

  bool sudahAbsenPulang() {
    return attendanceRecords.any(
      (data) =>
          data.type == 'Absen Pulang' &&
          data.date == getCurrentDate(),
    );
  }

  Future<void> bukaAbsensi(String type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceAttendancePage(
          attendanceType: type,
        ),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ======================================================
      // DRAWER
      // ======================================================

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Sailatur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'NIP. 1999000000000001',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Absensi'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // PROFILE CARD
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [

                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [

                      Text(
                        'Selamat Datang',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Shela Lala',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'NIP. 1999000000000001',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // DATE CARD
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                    size: 35,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Tanggal Hari Ini',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    getCurrentDate(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Absensi Hari Ini',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ABSEN MASUK
            // ==================================================

            AbsensiButton(
              title: 'Absen Masuk',
              subtitle: sudahAbsenMasuk()
                  ? 'Sudah melakukan absen masuk'
                  : 'Lakukan absensi masuk',
              icon: Icons.login,
              color: Colors.green,
              enabled: !sudahAbsenMasuk(),
              onTap: () {
                bukaAbsensi('Absen Masuk');
              },
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ABSEN PULANG
            // ==================================================

            AbsensiButton(
              title: 'Absen Pulang',
              subtitle: sudahAbsenPulang()
                  ? 'Sudah melakukan absen pulang'
                  : 'Lakukan absensi pulang',
              icon: Icons.logout,
              color: Colors.orange,
              enabled: !sudahAbsenPulang(),
              onTap: () {
                bukaAbsensi('Absen Pulang');
              },
            ),

            const SizedBox(height: 25),

            // ==================================================
            // INFO
            // ==================================================

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Pastikan wajah terlihat jelas saat melakukan absensi.',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}