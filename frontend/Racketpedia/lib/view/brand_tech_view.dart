import 'package:flutter/material.dart';

class BrandTechnologyView extends StatelessWidget {
  const BrandTechnologyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Racketpedia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Aligns all children to the start (left)
          children: [
            // Yonex Brand
            BrandCard(
              brandName: 'Yonex',
              technologies: [
                'Sonic Flare System',
                'ISOMETRIC',
                'Rotational Generator System',
              ],
              descriptions: [
                'Sonic Flare System dibangun melalui kombinasi cermat antara grafit modulus tinggi di ujung bingkai, dan grafit yang kuat namun elastis, di dasar bingkai. Bahan grafit ini memberikan tolakan yang tinggi untuk akselerasi pesawat ulang-alik maksimum...',
                'Dikembangkan lebih dari 30 tahun yang lalu, desain ISOMETRIC meningkatkan sweet spot sebesar 7%. Dibandingkan dengan rangka bulat konvensional, raket ISOMETRIC berbentuk persegi...',
                'Distribusi Berat yang Diimbangi. Dengan menerapkan teori penyeimbang, bobot didistribusikan ke seluruh ujung pegangan, bagian atas rangka, dan sambungan untuk kontrol maksimal...',
              ],
              image: 'assets/images/logo_yonex.png',
            ),

            // Lining Brand
            BrandCard(
              brandName: 'Lining',
              technologies: [
                'UHB Shaft',
                'Wing Stabilizer',
                'Dynamic Optimum Frame',
              ],
              descriptions: [
                'Penelitian dan desain yang ekstensif telah menghasilkan UHB Shaft untuk meningkatkan kelenturan raket bulutangkis lebih tinggi pada porosnya untuk memberikan kekuatan dan kontrol...',
                'Teknologi wing stabilizer merupakan teknologi terbaru dari Li Ning yang berfungsi sebagai alat peredam pada rangka raket...',
                'Desain serba optimal ini meningkatkan struktur mekanis raket, meningkatkan efisiensi serangan dan pertahanan...',
              ],
              image: 'assets/images/logo_lining.png',
            ),

            // Victor Brand
            BrandCard(
              brandName: 'Victor',
              technologies: [
                'PYROFIL',
                'FREE CORE',
                'HARD CORED TECHNOLOGY',
              ],
              descriptions: [
                'Serat karbon PYROFIL dan kompositnya, adalah material berkinerja tinggi canggih dari Jepang...',
                'Dirancang dengan simulasi komputer dan dibantu dengan penerapan teknik cetakan injeksi...',
                'Terinspirasi oleh helikopter militer, struktur berlapis-lapis yang terbuat dari serat karbon...',
              ],
              image: 'assets/images/logo_victor.png',
            ),

            // Mizuno Brand
            BrandCard(
              brandName: 'Mizuno',
              technologies: [
                'Hot Melt Tech',
                'Aerogroove',
                'RAPID RESPONSE SYSTEM',
              ],
              descriptions: [
                'Lembaran grafit dipanaskan pada suhu yang lebih tinggi untuk menghilangkan kotoran lebih lanjut...',
                'Desain alur unik yang meningkatkan keuletan rangka memungkinkan senar terpasang dengan kuat...',
                'Rapid Response System adalah teknologi inovatif yang bertujuan menghasilkan daya ledak pada setiap tembakan...',
              ],
              image: 'assets/images/logo_mizuno.png',
            ),

            // Hundred Brand
            BrandCard(
              brandName: 'Hundred',
              technologies: [
                'Control Foam',
                'Vaporshaft XS 6.5mm',
                'Power Beam System'
              ],
              descriptions: [
                'Rangka raket diperkuat dengan menggunakan teknologi cetakan khusus...',
                'VaporShaft dirancang untuk Penggandaan Daya murni. Raket dilengkapi poros yang dibuat dengan halus...',
                'Power Beam System meningkatkan stabilitas, menjaga raket tetap stabil selama pukulan kuat untuk permainan agresif tanpa kehilangan kendali'
              ],
              image: 'assets/images/logo_hundred.png',
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for Brand Technology Cards
class BrandCard extends StatelessWidget {
  final String brandName;
  final String image;
  final List<String> technologies;
  final List<String> descriptions;

  const BrandCard({
    super.key,
    required this.brandName,
    required this.image,
    required this.technologies,
    required this.descriptions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                width: 200,
                height: 150,
              ),
            ),
            // Brand Name
            Text(
              brandName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 20),
            // Technologies List
            for (int i = 0; i < technologies.length; i++) ...[
              Text(
                technologies[i],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Text(
                descriptions[i],
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
