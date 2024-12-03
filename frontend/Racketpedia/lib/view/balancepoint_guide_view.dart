import 'package:flutter/material.dart';

class BalancePointGuideView extends StatelessWidget {
  const BalancePointGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Racketpedia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Panduan Titik Keseimbangan Raket',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/balance_point.jpg',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'Titik keseimbangan menunjukkan pusat massa raket bulutangkis. Ada tiga jenis titik keseimbangan:\n\n'
                  '1. Head-heavy: Raket dengan head-heavy memiliki titik keseimbangan yang lebih dekat ke kepala raket. Mengemudikan momentum lebih baik saat mengayun, tetapi mungkin sedikit sulit untuk memainkan pukulan datar atau melakukan permainan bertahan.\n\n'
                  '2. Even-balanced: Raket yang seimbang memiliki titik keseimbangan yang lebih dekat ke tengah. Raket jenis ini memiliki performa yang seimbang, menjadikannya pilihan ideal untuk pemula.\n\n'
                  '3. Head-light: Raket head-light memiliki titik keseimbangan yang lebih dekat ke pegangan, yang memungkinkan pukulan pendek dan cepat, tetapi membutuhkan lebih banyak kekuatan untuk mengembalikan shuttlecock ke bagian belakang lapangan lawan.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
