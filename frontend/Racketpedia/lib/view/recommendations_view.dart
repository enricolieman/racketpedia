import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Racketpedia/model/racket_list_model.dart';
import 'package:Racketpedia/view/home_view.dart';
import 'package:Racketpedia/view/information_view.dart';
import 'package:Racketpedia/view/racket_detail_view.dart';

class RecommendationsView extends StatefulWidget {
  @override
  _RecommendationsViewState createState() => _RecommendationsViewState();
}

class _RecommendationsViewState extends State<RecommendationsView> {
  double? price; // Changed to nullable
  double? weight; // Changed to nullable

  bool isPriceRandom = false;
  bool isWeightRandom = false;

  final double minPrice = 0;
  final double maxPrice = 4000000;
  final double minWeight = 0;
  final double maxWeight = 100;

  final TextEditingController keywordController = TextEditingController();
  int selectedIndex = 1;

  String? selectedStiffness;
  final List<String> stiffness = ['Stiff', 'Medium', 'Flex', 'Random'];

  String? selectedBalancePoint;
  final List<String> balancePoints = [
    'Head Heavy',
    'Even Balance',
    'Head Light',
    'Random'
  ];

  String? selectedBrand;
  final List<String> brands = [
    'Yonex',
    'Lining',
    'Victor',
    'Mizuno',
    'Hundred',
    'Felet',
    'Maxbolt',
    'Apacs',
    'Random'
  ];

  List<dynamic> recommendations = [];
  bool isLoading = false;
  String errorMessage = '';

  void _submit() async {
    FocusScope.of(context).unfocus();

    String keyword = keywordController.text.trim();

    // Set price and weight to null if set to Random
    final priceValue = isPriceRandom ? null : price;
    final weightValue = isWeightRandom ? null : weight;

    // Check if only brand is selected without any other filters
    if (selectedBrand != null &&
        selectedBrand != null &&
        priceValue == null &&
        weightValue == null &&
        (selectedStiffness == null) &&
        (selectedBalancePoint == null) &&
        keyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill at least one another field beside Brand'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if at least one of the fields is filled
    if (priceValue == null &&
        weightValue == null &&
        selectedStiffness == null &&
        selectedBalancePoint == null &&
        selectedBrand == null &&
        keyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please fill at least one required field before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final url = 'https://enricoliman.pythonanywhere.com/recommend';
    // final url = 'http://192.168.1.4:5000/recommend';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'price': priceValue,
          'weight': weightValue,
          'stiffness':
              selectedStiffness == 'Random' ? 'Random' : selectedStiffness,
          'balance_point': selectedBalancePoint == 'Random'
              ? 'Random'
              : selectedBalancePoint,
          'brand': selectedBrand == 'Random' ? 'Random' : selectedBrand,
          'keyword': keyword,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          recommendations = responseData['recommendations'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load recommendations. Status code: ${response.statusCode}.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Please check your connection.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Racketpedia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Slider for Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price: Rp ${price?.toInt() ?? 0}",
                        style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Text("Random"),
                        Checkbox(
                          value: isPriceRandom,
                          onChanged: (bool? value) {
                            setState(() {
                              isPriceRandom = value ?? false;
                              if (isPriceRandom)
                                price =
                                    null; // Reset price if Random is checked
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Slider(
                  value: price ??
                      minPrice, // Use default minPrice if price is null
                  min: minPrice,
                  max: maxPrice,
                  divisions: ((maxPrice - minPrice) / 100000).round(),
                  label: (price ?? 0).toInt().toString(),
                  onChanged: isPriceRandom
                      ? null
                      : (value) {
                          setState(() {
                            price = value;
                          });
                        },
                ),
              ],
            ),

            // Slider for Weight
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Weight: ${weight?.toInt() ?? 0} gram",
                        style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Text("Random"),
                        Checkbox(
                          value: isWeightRandom,
                          onChanged: (bool? value) {
                            setState(() {
                              isWeightRandom = value ?? false;
                              if (isWeightRandom)
                                weight =
                                    null; // Reset weight if Random is checked
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Slider(
                  value: weight ??
                      minWeight, // Use default minWeight if weight is null
                  min: minWeight,
                  max: maxWeight,
                  divisions: (maxWeight - minWeight).toInt(),
                  label: (weight ?? 0).toInt().toString(),
                  onChanged: isWeightRandom
                      ? null
                      : (value) {
                          setState(() {
                            weight = value;
                          });
                        },
                ),
              ],
            ),

            // Dropdowns for Stiffness, Balance Point, and Brand
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStiffness,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStiffness = newValue;
                      });
                    },
                    items:
                        stiffness.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Stiffness'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedBalancePoint,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBalancePoint = newValue;
                      });
                    },
                    items: balancePoints
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Balance Point'),
                  ),
                ),
              ],
            ),

            DropdownButtonFormField<String>(
              value: selectedBrand,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBrand = newValue;
                });
              },
              items: brands.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Brand'),
            ),

            TextField(
              controller: keywordController,
              decoration: InputDecoration(
                labelText: 'Keyword',
                suffixIcon: keywordController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            keywordController.clear(); // Menghapus isi keyword
                          });
                        },
                      )
                    : null,
              ),
              maxLength: 100,
              onChanged: (text) {
                setState(
                    () {}); // Memperbarui UI ketika teks berubah untuk menampilkan atau menyembunyikan ikon "Clear"
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Cari Raket'),
            ),
            SizedBox(height: 20),

            // Recommendation Results
            if (isLoading)
              CircularProgressIndicator()
            else if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount:
                    recommendations.length > 10 ? 10 : recommendations.length,
                itemBuilder: (context, index) {
                  final racketMap = recommendations[index];
                  final racket = Racket.fromMap(racketMap);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RacketDetailView(racket: racket),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Colors.teal),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 150,
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(
                                      (racket.image.isNotEmpty &&
                                              Uri.tryParse(racket.image)
                                                      ?.hasAbsolutePath ==
                                                  true)
                                          ? racket.image
                                          : 'https://www.yonex.com/media/catalog/product/d/u/duo-zs.png?quality=80&fit=bounds&height=819&width=600&canvas=600:819',
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 150,
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              color: Colors.grey[600],
                                              size: 50,
                                            ),
                                          ),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              Text(
                                '${racket.brand} ${racket.model}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.teal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
              _showExitConfirmationDialog(context);
              break;
          }
        },
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Keluar'),
        content: Text('Anda ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
