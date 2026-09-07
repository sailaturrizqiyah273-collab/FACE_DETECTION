import 'package:flutter/material.dart';

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