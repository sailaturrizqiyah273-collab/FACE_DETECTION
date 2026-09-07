import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:si_wajah/firebase_options.dart';

late List<CameraDescription> cameras;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp (
    options : DefaultFirebaseOptions . currentPlatform , 
);
  
  cameras = await availableCameras();

  runApp(const AbsensiDinasApp());
}

// ============================================================
// APP
// ============================================================

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

// ============================================================
// DATA ABSENSI
// ============================================================

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

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool obscurePassword = true;

  void login() {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password wajib diisi'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                // LOGO
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'ABSENSI DINAS',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Sistem Absensi Pegawai',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // USERNAME
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'NIP / Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'MASUK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Aplikasi Absensi Pegawai Dinas',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

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

// ============================================================
// ABSENSI BUTTON
// ============================================================

class AbsensiButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const AbsensiButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [

              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FACE ATTENDANCE PAGE
// ============================================================

class FaceAttendancePage extends StatefulWidget {
  final String attendanceType;

  const FaceAttendancePage({
    super.key,
    required this.attendanceType,
  });

  @override
  State<FaceAttendancePage> createState() =>
      _FaceAttendancePageState();
}

class _FaceAttendancePageState
    extends State<FaceAttendancePage> {

  CameraController? cameraController;

  late FaceDetector faceDetector;

  bool isCameraReady = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();

    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    initializeCamera();
  }

  Future<void> initializeCamera() async {

    if (cameras.isEmpty) {
      return;
    }

    CameraDescription selectedCamera;

    try {
      selectedCamera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection ==
            CameraLensDirection.front,
      );
    } catch (e) {
      selectedCamera = cameras.first;
    }

    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        isCameraReady = true;
      });
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> scanFace() async {

    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        isProcessing) {
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {

      // Ambil foto
      final XFile image =
          await cameraController!.takePicture();

      // Proses menggunakan ML Kit
      final InputImage inputImage =
          InputImage.fromFilePath(image.path);

      final List<Face> faces =
          await faceDetector.processImage(
        inputImage,
      );

      if (!mounted) return;

      if (faces.isEmpty) {

        setState(() {
          isProcessing = false;
        });

        showResult(
          success: false,
          message:
              'Wajah tidak terdeteksi.\n'
              'Pastikan wajah terlihat jelas.',
        );

      } else {

        // Wajah terdeteksi
        saveAttendance();

        setState(() {
          isProcessing = false;
        });

        showResult(
          success: true,
          message:
              '${widget.attendanceType} berhasil!\n'
              'Wajah terdeteksi.',
        );
      }

    } catch (e) {

      debugPrint('Face detection error: $e');

      if (!mounted) return;

      setState(() {
        isProcessing = false;
      });

      showResult(
        success: false,
        message: 'Terjadi kesalahan saat memproses wajah.',
      );
    }
  }

  void saveAttendance() {

    final now = DateTime.now();

    final date =
        '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';

    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    attendanceRecords.add(
      AttendanceRecord(
        date: date,
        time: time,
        type: widget.attendanceType,
        status: 'Berhasil',
      ),
    );
  }

  void showResult({
    required bool success,
    required String message,
  }) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          icon: Icon(
            success
                ? Icons.check_circle
                : Icons.error,
            color: success
                ? Colors.green
                : Colors.red,
            size: 60,
          ),

          title: Text(
            success
                ? 'Absensi Berhasil'
                : 'Absensi Gagal',
          ),

          content: Text(
            message,
            textAlign: TextAlign.center,
          ),

          actions: [

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.pop(context);

                  if (success) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {

    cameraController?.dispose();
    faceDetector.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text(widget.attendanceType),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: isCameraReady
          ? Stack(
              children: [

                // CAMERA
                Positioned.fill(
                  child: CameraPreview(
                    cameraController!,
                  ),
                ),

                // FACE FRAME
                Center(
                  child: Container(
                    width: 250,
                    height: 320,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      borderRadius:
                          BorderRadius.circular(150),
                    ),
                  ),
                ),

                // INSTRUCTION
                Positioned(
                  top: 30,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Posisikan wajah di dalam lingkaran',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // BUTTON
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                          isProcessing ? null : scanFace,
                      icon: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                            ),
                      label: Text(
                        isProcessing
                            ? 'Memproses...'
                            : 'SCAN WAJAH',
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}

// ============================================================
// HISTORY PAGE
// ============================================================

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() =>
      _HistoryPageState();
}

class _HistoryPageState
    extends State<HistoryPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: attendanceRecords.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.history,
                    size: 70,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Belum ada riwayat absensi',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {

                final data =
                    attendanceRecords[
                        attendanceRecords.length -
                            1 -
                            index];

                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [

                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: data.type ==
                                  'Absen Masuk'
                              ? Colors.green
                                  .withOpacity(0.15)
                              : Colors.orange
                                  .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Icon(
                          data.type ==
                                  'Absen Masuk'
                              ? Icons.login
                              : Icons.logout,
                          color: data.type ==
                                  'Absen Masuk'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              data.type,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              '${data.date} • ${data.time}',
                              style:
                                  const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// PROFILE PAGE
// ============================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [

          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Profil Pegawai'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 10),

            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 65,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Sailatur',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Pegawai Dinas',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            profileItem(
              Icons.badge,
              'NIP',
              '1999000000000001',
            ),

            profileItem(
              Icons.person,
              'Nama',
              'Sailatur',
            ),

            profileItem(
              Icons.business,
              'Instansi',
              'DISKOMINFO PASURUAN',
            ),

            profileItem(
              Icons.work,
              'Jabatan',
              'Staff',
            ),

            profileItem(
              Icons.email,
              'Email',
              'pegawai@dinas.go.id',
            ),
          ],
        ),
      ),
    );
  }
}
