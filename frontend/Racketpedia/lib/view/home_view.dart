import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // Import untuk fungsi random
import 'dart:async';
import 'package:Racketpedia/model/racket_list_model.dart';
import 'package:Racketpedia/view/information_view.dart';
import 'package:Racketpedia/view/racket_detail_view.dart';
import 'package:Racketpedia/view/recommendations_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Racket> rackets = [];
  int currentPage = 0;
  static const int itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0; // Track the selected index for the bottom navigation
  String _selectedSort = 'Random'; // Default to random sort option
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    loadRackets();
  }

  Future<void> loadRackets() async {
    setState(() {
      isLoading = true; // Start loading
    });

    final url = 'https://enricoliman.pythonanywhere.com/rackets';
    // final url = 'http://192.168.1.4:5000/rackets';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 30)); // Timeout setelah 30 detik
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          rackets =
              data['rackets'].map<Racket>((r) => Racket.fromMap(r)).toList();
          _sortRackets('Random'); // Set initial random order
        });
      } else {
        throw Exception('Failed to load rackets');
      }
    } on TimeoutException catch (_) {
      print('The connection has timed out!');
      // Optionally show a snackbar or alert to the user about the timeout
      setState(() {
        // You can add a custom error message or flag here
      });
    } catch (e) {
      print('Error loading rackets: $e'); // Log other errors
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void _sortRackets(String criterion) {
    setState(() {
      if (criterion == 'Brand(A-Z)') {
        rackets.sort((a, b) => a.brand.compareTo(b.brand));
      } else if (criterion == 'Brand(Z-A)') {
        rackets.sort((a, b) => b.brand.compareTo(a.brand));
      } else if (criterion == 'Weight (Low to High)') {
        rackets.sort((a, b) => a.weight.compareTo(b.weight));
      } else if (criterion == 'Weight (High to Low)') {
        rackets.sort((a, b) => b.weight.compareTo(a.weight));
      } else if (criterion == 'Price (Low to High)') {
        rackets.sort((a, b) => a.price.compareTo(b.price));
      } else if (criterion == 'Price (High to Low)') {
        rackets.sort((a, b) => b.price.compareTo(a.price));
      } else if (criterion == 'Random') {
        rackets.shuffle(Random()); // Randomize the order
      }
    });
  }

  void _navigateToPage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Racketpedia'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          automaticallyImplyLeading: false,
        ),
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    List<Racket> displayRackets = rackets.sublist(
      startIndex,
      endIndex > rackets.length ? rackets.length : endIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Racketpedia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sort by:'),
                DropdownButton<String>(
                  value: _selectedSort,
                  items: <String>[
                    'Random',
                    'Price (Low to High)',
                    'Price (High to Low)',
                    'Weight (Low to High)',
                    'Weight (High to Low)',
                    'Brand(A-Z)',
                    'Brand(Z-A)'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSort = value;
                        _sortRackets(value);
                        currentPage = 0;
                      });
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final racket = displayRackets[index];
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
                          margin: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: Colors.teal),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.network(
                                          racket.image.isNotEmpty
                                              ? racket.image
                                              : 'https://strapiproduction-16636.kxcdn.com/uploads/Template_02_89b63fa337/Template_02_89b63fa337.jpg?width=640&quality=65',
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
                                  const SizedBox(height: 1),
                                  Text(
                                    '${racket.brand} ${racket.model}',
                                    style: const TextStyle(
                                      fontSize: 15,
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
                    childCount: displayRackets.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.8,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: currentPage > 0
                              ? () {
                                  _navigateToPage(currentPage - 1);
                                }
                              : null,
                        ),
                        Text(
                          '${currentPage + 1}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed:
                              (currentPage + 1) * itemsPerPage < rackets.length
                                  ? () {
                                      _navigateToPage(currentPage + 1);
                                    }
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Anda ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // Exit the app
            },
            child: Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
