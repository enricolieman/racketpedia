import 'package:flutter/material.dart';

class WeightGuideView extends StatelessWidget {
  const WeightGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Racketpedia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
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
                    'Panduan Berat Raket',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/weight.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Berat raket dilambangkan dengan "U" dan tersedia dalam berbagai tingkatan. Kebanyakan raket memiliki bobot sekitar 3U (85.0 - 89.9g) atau 4U (80,0 - 84,9g).\n\n 4U umumnya direkomendasikan sebagai standar dan di mana sebagian besar pemain memulai. Setelah mereka menunjukkan peningkatan dalam kekuatan dan keterampilan untuk meningkatkan kekuatan pukulan, mereka dapat beralih ke 3U.\n\n Pemain yang masih belajar bagaimana menerapkan kekuatan dengan benar atau pemain wanita dapat memilih raket 5U.',
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
