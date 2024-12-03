import 'package:flutter/material.dart';
import 'package:Racketpedia/model/racket_list_model.dart';

// Halaman Detail Raket
class RacketDetailView extends StatelessWidget {
  final Racket racket;

  RacketDetailView({required this.racket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Racketpedia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                '${racket.brand} ${racket.model}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, top: 50, bottom: 50),
                child: Image.network(
                  racket.image.isNotEmpty
                      ? racket.image
                      : 'https://www.yonex.com/media/catalog/product/d/u/duo-zs.png?quality=80&fit=bounds&height=819&width=600&canvas=600:819',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  width: 300, // Adjusted width for 2-column layout
                  fit: BoxFit.cover, // Ensures the image fits the container
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: Rp ${racket.price.toStringAsFixed(0)}'),
                    Text('Weight: ${racket.weight.toInt()} gram'),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stiffness: ${racket.stiffness}'),
                    Text('Balance Point: ${racket.balancePoint}'),
                  ],
                ),
              ]),
              SizedBox(height: 20),
              // Text(
              //   'Deskripsi:',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              SizedBox(height: 10),
              Text(
                racket.description.isNotEmpty
                    ? racket.description
                    : 'Tidak ada deskripsi tersedia.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
