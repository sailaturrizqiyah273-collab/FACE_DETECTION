import 'package:flutter/material.dart';
import '../data/attendance_data.dart';

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