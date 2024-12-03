import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Racketpedia/view/home_view.dart';
import 'package:Racketpedia/view/recommendations_view.dart';
import 'package:Racketpedia/view/brand_tech_view.dart';
import 'package:Racketpedia/view/weight_guide_view.dart';
import 'package:Racketpedia/view/stiffness_guide_view.dart';
import 'package:Racketpedia/view/balancepoint_guide_view.dart';

class InformationView extends StatefulWidget {
  const InformationView({super.key});

  @override
  _InformationViewState createState() => _InformationViewState();
}

class _InformationViewState extends State<InformationView> {
  int selectedIndex = 2; // Set the selected index to 2 for InformationView

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Racketpedia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildInfoTile(
              context,
              title: 'Teknologi Merek Raket',
              icon: Icons.info,
              destination:
                  BrandTechnologyView(), // Navigate to Brand Technology Guide
            ),
            _buildInfoTile(
              context,
              title: 'Panduan Berat Raket',
              icon: Icons.scale,
              destination: WeightGuideView(), // Navigate to Weight Guide
            ),
            _buildInfoTile(
              context,
              title: 'Panduan Kekakuan Raket',
              icon: Icons.tune,
              destination: StiffnessGuideView(), // Navigate to Stiffness Guide
            ),
            _buildInfoTile(
              context,
              title: 'Panduan Titik Keseimbangan Raket',
              icon: Icons.balance,
              destination:
                  BalancePointGuideView(), // Navigate to Balance Point Guide
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Rekomendasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Keluar',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendationsView(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformationView(),
                ),
              );
              break;
            case 3:
              _showExitConfirmationDialog(
                  context); // Show exit confirmation dialog
              break;
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget destination}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 5),
            Icon(
              icon,
              size: 30,
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Anda ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop(); // Exit the app
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
