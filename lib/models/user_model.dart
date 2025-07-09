import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final List<String> bookingHistory;
  final List<String> favoriteCars;
  final bool isEmailVerified;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.createdAt,
    required this.lastLoginAt,
    this.bookingHistory = const [],
    this.favoriteCars = const [],
    this.isEmailVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'bookingHistory': bookingHistory,
      'favoriteCars': favoriteCars,
      'isEmailVerified': isEmailVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
      bookingHistory: List<String>.from(map['bookingHistory'] ?? []),
      favoriteCars: List<String>.from(map['favoriteCars'] ?? []),
      isEmailVerified: map['isEmailVerified'] ?? false,
    );
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? bookingHistory,
    List<String>? favoriteCars,
    bool? isEmailVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      bookingHistory: bookingHistory ?? this.bookingHistory,
      favoriteCars: favoriteCars ?? this.favoriteCars,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
} 