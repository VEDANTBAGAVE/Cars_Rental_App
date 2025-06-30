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
      print('Fetching cars from Firestore...'); // Debug print
      QuerySnapshot snapshot = await _firestore.collection('cars').get();
      print(
        'Firestore returned ${snapshot.docs.length} documents',
      ); // Debug print

      List<Car> cars = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID as the car ID
        print('Processing car: ${data['name']}'); // Debug print
        return Car.fromMap(data);
      }).toList();

      print('Successfully converted ${cars.length} cars'); // Debug print
      return cars;
    } catch (e) {
      print('Error getting cars: $e');
      return [];
    }
  }

  // Get featured cars for carousel
  Future<List<Car>> getFeaturedCars() async {
    try {
      // Get all featured cars first
      QuerySnapshot snapshot = await _firestore
          .collection('cars')
          .where('isFeatured', isEqualTo: true)
          .get();
      
      List<Car> allFeaturedCars = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Car.fromMap(data);
      }).toList();
      
      // Randomly select 3 cars
      List<Car> randomFeaturedCars = [];
      if (allFeaturedCars.isNotEmpty) {
        // Shuffle the list to randomize
        allFeaturedCars.shuffle();
        
        // Take up to 3 cars
        randomFeaturedCars = allFeaturedCars.take(3).toList();
      }
      
      print('Found ${allFeaturedCars.length} featured cars, randomly selected ${randomFeaturedCars.length}');
      return randomFeaturedCars;
    } catch (e) {
      print('Error getting featured cars: $e');
      return [];
    }
  }

  // Get trending cars (most popular)
  Future<List<Car>> getTrendingCars() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('cars')
          .orderBy('rentalCount', descending: true)
          .limit(6)
          .get();

      List<Car> cars = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Car.fromMap(data);
      }).toList();

      return cars;
    } catch (e) {
      print('Error getting trending cars: $e');
      return [];
    }
  }

  // Get cars with discounts
  Future<List<Car>> getDealsCars() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('cars')
          .where('hasDiscount', isEqualTo: true)
          .limit(6)
          .get();

      List<Car> cars = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Car.fromMap(data);
      }).toList();

      return cars;
    } catch (e) {
      print('Error getting deals cars: $e');
      return [];
    }
  }

  // Search cars by name, brand, or location
  Future<List<Car>> searchCars(String query) async {
    try {
      // Search by name (case insensitive)
      QuerySnapshot nameSnapshot = await _firestore
          .collection('cars')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + '\uf8ff')
          .get();

      // Search by location (case insensitive)
      QuerySnapshot locationSnapshot = await _firestore
          .collection('cars')
          .where('location', isGreaterThanOrEqualTo: query)
          .where('location', isLessThan: query + '\uf8ff')
          .get();

      Set<String> carIds = {};
      List<Car> cars = [];

      // Process name results
      for (var doc in nameSnapshot.docs) {
        if (!carIds.contains(doc.id)) {
          carIds.add(doc.id);
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          cars.add(Car.fromMap(data));
        }
      }

      // Process location results
      for (var doc in locationSnapshot.docs) {
        if (!carIds.contains(doc.id)) {
          carIds.add(doc.id);
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          cars.add(Car.fromMap(data));
        }
      }

      return cars;
    } catch (e) {
      print('Error searching cars: $e');
      return [];
    }
  }

  // Get cars by price range
  Future<List<Car>> getCarsByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('cars')
          .where('pricePerDay', isGreaterThanOrEqualTo: minPrice)
          .where('pricePerDay', isLessThanOrEqualTo: maxPrice)
          .get();

      List<Car> cars = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Car.fromMap(data);
      }).toList();

      return cars;
    } catch (e) {
      print('Error getting cars by price range: $e');
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

  // Update existing cars with new fields for home page features
  Future<void> updateCarsForHomePage() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cars').get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add new fields if they don't exist
        Map<String, dynamic> updates = {};

        if (!data.containsKey('isFeatured')) {
          updates['isFeatured'] = false;
        }

        if (!data.containsKey('hasDiscount')) {
          updates['hasDiscount'] = false;
        }

        if (!data.containsKey('discountAmount')) {
          updates['discountAmount'] = 0.0;
        }

        if (!data.containsKey('rentalCount')) {
          updates['rentalCount'] = 0;
        }

        if (!data.containsKey('brand')) {
          // Extract brand from car name
          String name = data['name'] ?? '';
          String brand = '';
          if (name.contains('Mahindra'))
            brand = 'Mahindra';
          else if (name.contains('Tata'))
            brand = 'Tata';
          else if (name.contains('BMW'))
            brand = 'BMW';
          else if (name.contains('Audi'))
            brand = 'Audi';
          else if (name.contains('Toyota'))
            brand = 'Toyota';
          else if (name.contains('Nissan'))
            brand = 'Nissan';
          else if (name.contains('Maruti') || name.contains('Suzuki'))
            brand = 'Maruti Suzuki';
          else if (name.contains('Hyundai'))
            brand = 'Hyundai';
          else if (name.contains('Skoda'))
            brand = 'Skoda';
          else
            brand = 'Other';

          updates['brand'] = brand;
        }

        // Set some cars as featured and with discounts for demo
        if (doc.id == snapshot.docs.first.id) {
          updates['isFeatured'] = true;
          updates['hasDiscount'] = true;
          updates['discountAmount'] = 3500.0;
          updates['rentalCount'] = 15;
        } else if (snapshot.docs.length > 1 && doc.id == snapshot.docs[1].id) {
          updates['isFeatured'] = true;
          updates['hasDiscount'] = true;
          updates['discountAmount'] = 4000.0;
          updates['rentalCount'] = 12;
        } else if (snapshot.docs.length > 2 && doc.id == snapshot.docs[2].id) {
          updates['isFeatured'] = true;
          updates['hasDiscount'] = true;
          updates['discountAmount'] = 3000.0;
          updates['rentalCount'] = 18;
        } else if (snapshot.docs.length > 3 && doc.id == snapshot.docs[3].id) {
          updates['isFeatured'] = true;
          updates['hasDiscount'] = false;
          updates['discountAmount'] = 0.0;
          updates['rentalCount'] = 22;
        } else if (snapshot.docs.length > 4 && doc.id == snapshot.docs[4].id) {
          updates['isFeatured'] = true;
          updates['hasDiscount'] = true;
          updates['discountAmount'] = 2500.0;
          updates['rentalCount'] = 16;
        } else if (snapshot.docs.length > 5 && doc.id == snapshot.docs[5].id) {
          updates['isFeatured'] = true;
          updates['hasDiscount'] = false;
          updates['discountAmount'] = 0.0;
          updates['rentalCount'] = 20;
        } else {
          // Random rental count for other cars
          updates['rentalCount'] = (5 + (doc.id.hashCode % 20));
        }

        if (updates.isNotEmpty) {
          await _firestore.collection('cars').doc(doc.id).update(updates);
          print('Updated car ${data['name']} with new fields');
        }
      }

      print('Successfully updated all cars with home page fields');
    } catch (e) {
      print('Error updating cars for home page: $e');
      throw e;
    }
  }
}
