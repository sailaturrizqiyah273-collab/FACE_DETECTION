import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:si_wajah/main.dart';
import '../data/attendance_data.dart' hide attendanceRecords;
import '../models/attendance_record.dart' hide AttendanceRecord;

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
  try {
    // Mencari kamera hanya ketika halaman absensi dibuka
    final availableCamerasList = await availableCameras();

    if (availableCamerasList.isEmpty) {
      debugPrint('Tidak ada kamera yang tersedia');
      return;
    }

    CameraDescription selectedCamera;

    try {
      // Prioritaskan kamera depan
      selectedCamera = availableCamerasList.firstWhere(
        (camera) =>
            camera.lensDirection ==
            CameraLensDirection.front,
      );
    } catch (e) {
      // Jika kamera depan tidak ditemukan,
      // gunakan kamera pertama yang tersedia
      selectedCamera = availableCamerasList.first;
    }

    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

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