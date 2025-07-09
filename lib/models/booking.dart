import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String carId;
  final String carName;
  final String carImageUrl;
  final String carBrand;
  final DateTime pickUpDate;
  final TimeOfDay pickUpTime;
  final DateTime dropOffDate;
  final TimeOfDay dropOffTime;
  final String deliveryAddress;
  final String customerName;
  final String customerPhone;
  final double dailyRate;
  final double totalPrice;
  final int rentalDays;
  final String status; // 'pending', 'confirmed', 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final String? driverLicense;
  final String? paymentMethod;
  final String? paymentStatus; // 'pending', 'paid', 'failed', 'refunded'

  Booking({
    required this.id,
    required this.userId,
    required this.carId,
    required this.carName,
    required this.carImageUrl,
    required this.carBrand,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.dropOffDate,
    required this.dropOffTime,
    required this.deliveryAddress,
    required this.customerName,
    required this.customerPhone,
    required this.dailyRate,
    required this.totalPrice,
    required this.rentalDays,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.driverLicense,
    this.paymentMethod,
    this.paymentStatus,
  });

  // Create from Firestore document
  factory Booking.fromMap(Map<String, dynamic> map, String documentId) {
    return Booking(
      id: documentId,
      userId: map['userId'] ?? '',
      carId: map['carId'] ?? '',
      carName: map['carName'] ?? '',
      carImageUrl: map['carImageUrl'] ?? '',
      carBrand: map['carBrand'] ?? '',
      pickUpDate: (map['pickUpDate'] as Timestamp).toDate(),
      pickUpTime: _timeFromMap(map['pickUpTime']),
      dropOffDate: (map['dropOffDate'] as Timestamp).toDate(),
      dropOffTime: _timeFromMap(map['dropOffTime']),
      deliveryAddress: map['deliveryAddress'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      dailyRate: (map['dailyRate'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      rentalDays: map['rentalDays'] ?? 0,
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      notes: map['notes'],
      driverLicense: map['driverLicense'],
      paymentMethod: map['paymentMethod'],
      paymentStatus: map['paymentStatus'] ?? 'pending',
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'carId': carId,
      'carName': carName,
      'carImageUrl': carImageUrl,
      'carBrand': carBrand,
      'pickUpDate': Timestamp.fromDate(pickUpDate),
      'pickUpTime': _timeToMap(pickUpTime),
      'dropOffDate': Timestamp.fromDate(dropOffDate),
      'dropOffTime': _timeToMap(dropOffTime),
      'deliveryAddress': deliveryAddress,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'dailyRate': dailyRate,
      'totalPrice': totalPrice,
      'rentalDays': rentalDays,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'notes': notes,
      'driverLicense': driverLicense,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }

  // Helper methods for TimeOfDay serialization
  static TimeOfDay _timeFromMap(Map<String, dynamic>? timeMap) {
    if (timeMap == null) return TimeOfDay.now();
    return TimeOfDay(hour: timeMap['hour'] ?? 0, minute: timeMap['minute'] ?? 0);
  }

  static Map<String, dynamic> _timeToMap(TimeOfDay time) {
    return {
      'hour': time.hour,
      'minute': time.minute,
    };
  }

  // Create a copy with updated fields
  Booking copyWith({
    String? id,
    String? userId,
    String? carId,
    String? carName,
    String? carImageUrl,
    String? carBrand,
    DateTime? pickUpDate,
    TimeOfDay? pickUpTime,
    DateTime? dropOffDate,
    TimeOfDay? dropOffTime,
    String? deliveryAddress,
    String? customerName,
    String? customerPhone,
    double? dailyRate,
    double? totalPrice,
    int? rentalDays,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    String? driverLicense,
    String? paymentMethod,
    String? paymentStatus,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      carName: carName ?? this.carName,
      carImageUrl: carImageUrl ?? this.carImageUrl,
      carBrand: carBrand ?? this.carBrand,
      pickUpDate: pickUpDate ?? this.pickUpDate,
      pickUpTime: pickUpTime ?? this.pickUpTime,
      dropOffDate: dropOffDate ?? this.dropOffDate,
      dropOffTime: dropOffTime ?? this.dropOffTime,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      dailyRate: dailyRate ?? this.dailyRate,
      totalPrice: totalPrice ?? this.totalPrice,
      rentalDays: rentalDays ?? this.rentalDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      driverLicense: driverLicense ?? this.driverLicense,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  // Get formatted date strings
  String get formattedPickUpDate => '${pickUpDate.day}/${pickUpDate.month}/${pickUpDate.year}';
  String get formattedDropOffDate => '${dropOffDate.day}/${dropOffDate.month}/${dropOffDate.year}';
  String get formattedPickUpTime => '${pickUpTime.hour.toString().padLeft(2, '0')}:${pickUpTime.minute.toString().padLeft(2, '0')}';
  String get formattedDropOffTime => '${dropOffTime.hour.toString().padLeft(2, '0')}:${dropOffTime.minute.toString().padLeft(2, '0')}';

  // Check if booking is active
  bool get isActive {
    final now = DateTime.now();
    final pickUpDateTime = DateTime(
      pickUpDate.year,
      pickUpDate.month,
      pickUpDate.day,
      pickUpTime.hour,
      pickUpTime.minute,
    );
    final dropOffDateTime = DateTime(
      dropOffDate.year,
      dropOffDate.month,
      dropOffDate.day,
      dropOffTime.hour,
      dropOffTime.minute,
    );
    return now.isAfter(pickUpDateTime) && now.isBefore(dropOffDateTime);
  }

  // Check if booking is upcoming
  bool get isUpcoming {
    final now = DateTime.now();
    final pickUpDateTime = DateTime(
      pickUpDate.year,
      pickUpDate.month,
      pickUpDate.day,
      pickUpTime.hour,
      pickUpTime.minute,
    );
    return now.isBefore(pickUpDateTime);
  }

  // Check if booking is completed
  bool get isCompleted {
    final now = DateTime.now();
    final dropOffDateTime = DateTime(
      dropOffDate.year,
      dropOffDate.month,
      dropOffDate.day,
      dropOffTime.hour,
      dropOffTime.minute,
    );
    return now.isAfter(dropOffDateTime);
  }
} 