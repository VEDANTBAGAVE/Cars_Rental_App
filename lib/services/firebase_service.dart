import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/car.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get all cars from Firestore
  Future<List<Car>> getCars() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cars').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID as the car ID
        return Car.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting cars: $e');
      return [];
    }
  }

  // Get a single car by ID
  Future<Car?> getCarById(String carId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('cars')
          .doc(carId)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Car.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting car: $e');
      return null;
    }
  }

  // Add a new car
  Future<void> addCar(Car car) async {
    try {
      await _firestore.collection('cars').add(car.toMap());
    } catch (e) {
      print('Error adding car: $e');
      throw e;
    }
  }

  // Update a car
  Future<void> updateCar(String carId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('cars').doc(carId).update(data);
    } catch (e) {
      print('Error updating car: $e');
      throw e;
    }
  }

  // Delete a car
  Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection('cars').doc(carId).delete();
    } catch (e) {
      print('Error deleting car: $e');
      throw e;
    }
  }
}
