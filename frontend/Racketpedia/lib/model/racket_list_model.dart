class Racket {
  final String brand;
  final String model;
  final double price;
  final double weight;
  final String stiffness;
  final String balancePoint;
  final String image;
  final String description;

  Racket({
    required this.brand,
    required this.model,
    required this.price,
    required this.weight,
    required this.stiffness,
    required this.balancePoint,
    required this.image,
    required this.description,
  });

  factory Racket.fromMap(Map<String, dynamic> map) {
    String imageUrl = (map['Image'] as String?) ?? 'No URL available.';
    // Print the image URL for debugging
    return Racket(
      brand: (map['Brand'] as String?) ?? 'Unknown',
      model: (map['Model'] as String?) ?? 'Unknown Model',
      price: double.tryParse(map['Price']?.toString() ?? '0') ?? 0.0,
      weight: double.tryParse(map['Weight']?.toString() ?? '0') ?? 0.0,
      stiffness: (map['Stiffness'] as String?) ?? 'Unknown',
      balancePoint: (map['Balance_Point'] as String?) ?? 'Unknown',
      image: imageUrl,
      description:
          (map['Description'] as String?) ?? 'No description available.',
    );
  }

  // Method to convert Racket object back to a Map
  Map<String, dynamic> toMap() {
    return {
      'Brand': brand,
      'Model': model,
      'Price': price,
      'Weight': weight,
      'Stiffness': stiffness,
      'Balance_Point': balancePoint,
      'Image': image,
      'Description': description,
    };
  }
}
