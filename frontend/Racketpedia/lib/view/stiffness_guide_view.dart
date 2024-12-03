import 'package:flutter/material.dart';

class StiffnessGuideView extends StatelessWidget {
  const StiffnessGuideView({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                        'Panduan Kekakuan Raket',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/stiffness.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Kekakuan pada raket merujuk pada seberapa besar poros (shaft) raket bisa membengkok atau fleksibel saat pemain melakukan ayunan. Faktor ini memengaruhi kontrol, kekuatan, dan respons raket, tergantung pada kecepatan ayunan dan gaya bermain pemain.\n',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Umumnya, kekakuan pada raket dibagi menjadi tiga kategori utama:\n\n'
                      '1. Stiff (Kaku):  Raket dengan kekakuan tinggi (stiff) memiliki poros yang tidak banyak membengkok saat diayunkan. Artinya, raket akan tetap lebih kaku, sehingga mentransfer tenaga lebih langsung dari lengan pemain ke shuttlecock.\n\n'
                      '2. Medium (Sedang): Raket dengan kekakuan sedang memberikan keseimbangan antara fleksibilitas dan kekakuan, dengan tingkat membengkok yang sedang saat diayunkan.\n\n'
                      '3. Flex (Fleksibel): Raket dengan fleksibilitas tinggi (flex) memiliki poros yang mudah membengkok saat diayunkan, memungkinkan untuk menyimpan dan melepaskan energi dengan lebih dinamis',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
