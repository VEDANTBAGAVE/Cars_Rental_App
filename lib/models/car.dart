import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrls;
  final double pricePerDay;
  final String location;
  final int seats;
  final String fuelType;
  final String transmissionType;
  final bool isAvailable;
  final int warrantyYear;
  final Timestamp? warrantyDate;
  final int meter; // Assuming this is the mileage in kilometers
  final bool delivery;
  final bool isFeatured;
  final bool hasDiscount;
  final double discountAmount;
  final int rentalCount;
  final String brand;
  final String ownerId;
  final String ownerName;
  final int ownerContact;
  final bool isVerified;

  Car({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.pricePerDay,
    required this.location,
    required this.seats,
    required this.fuelType,
    required this.transmissionType,
    required this.isAvailable,
    required this.warrantyYear,
    required this.warrantyDate,
    required this.meter,
    required this.delivery,
    required this.isFeatured,
    required this.hasDiscount,
    required this.discountAmount,
    required this.rentalCount,
    required this.brand,
    required this.ownerId,
    required this.ownerName,
    required this.ownerContact,
    required this.isVerified,
  });

  // For backward compatibility: returns first image
  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrls,
      'pricePerDay': pricePerDay,
      'location': location,
      'seats': seats,
      'fuelType': fuelType,
      'transmissionType': transmissionType,
      'isAvailable': isAvailable,
      'warrantyYear': warrantyYear,
      'warrantyDate': warrantyDate,
      'meter': meter,
      'delivery': delivery,
      'isFeatured': isFeatured,
      'hasDiscount': hasDiscount,
      'discountAmount': discountAmount,
      'rentalCount': rentalCount,
      'brand': brand,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
      'isVerified': isVerified,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    List<String> safeStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) return value.map((item) => item.toString()).toList();
      if (value is String) return [value];
      return [];
    }

    // Safe integer conversion
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    // Safe double conversion
    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Car(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrls: safeStringList(map['imageUrl']),
      pricePerDay: safeDouble(map['pricePerDay']),
      location: map['location'] ?? '',
      seats: safeInt(map['seats']),
      fuelType: map['fuelType'] ?? '',
      transmissionType: map['transmissionType'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      warrantyYear: safeInt(map['warrantyYear']),
      warrantyDate: map['warrantyDate'],
      meter: safeInt(map['meter']),
      delivery: map['delivery'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      hasDiscount: map['hasDiscount'] ?? false,
      discountAmount: safeDouble(map['discountAmount']),
      rentalCount: safeInt(map['rentalCount']),
      brand: map['brand'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerContact: safeInt(map['ownerContact']),
      isVerified: map['isVerified'] ?? false,
    );
  }

  // Get discounted price
  double get discountedPrice => pricePerDay - discountAmount;
  
  // Get discount percentage
  double get discountPercentage => pricePerDay > 0 ? (discountAmount / pricePerDay) * 100 : 0;
}
