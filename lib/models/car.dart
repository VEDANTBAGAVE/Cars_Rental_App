import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
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

  Car({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.pricePerDay,
    required this.location,
    required this.seats,
    required this.fuelType,
    required this.transmissionType,
    required this.warrantyYear,
    required this.isAvailable,
    this.warrantyDate,
    required this.meter,
    required this.delivery,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
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
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      seats: map['seats'] ?? 0,
      fuelType: map['fuelType'] ?? '',
      transmissionType: map['transmissionType'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      warrantyYear: map['warrantyYear'] ?? 0,
      warrantyDate: map['warrantyDate'],
      meter: map['meter'] ?? 0,
      delivery: map['delivery'] ?? false,
    );
  }
}
