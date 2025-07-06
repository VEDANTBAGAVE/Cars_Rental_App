import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'car_details_page.dart';
import '../models/car.dart';
import '../services/firebase_service.dart';
import 'package:intl/intl.dart';

class BrowseCarsPage extends StatefulWidget {
  const BrowseCarsPage({super.key});

  @override
  State<BrowseCarsPage> createState() => _BrowseCarsPageState();
}

class _BrowseCarsPageState extends State<BrowseCarsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<String> popularCities = [
    "Mumbai",
    "Hyderabad",
    "Pune",
    "Delhi",
    "Bangalore",
    "Chennai",
    "Jaipur",
    "Kolkata",
    "Goa",
    "Chandigarh",
  ];

  String userCity = "Mumbai";
  List<Car> cars = [];
  bool isLoading = true;
  List<Car> filteredCars = [];
  String? selectedBrand;
  String? selectedFuel;
  RangeValues? selectedPriceRange;
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Car> fetchedCars = await _firebaseService.getCars();
      print('Fetched ${fetchedCars.length} cars from Firebase'); // Debug print

      print(
        'Cars in Mumbai: ${fetchedCars.where((car) => car.location == 'Mumbai').length}',
      ); // Debug print

      setState(() {
        cars = fetchedCars;
        filteredCars = fetchedCars;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cars: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int get carCount => cars.length;

  void showCitySelector() async {
    String? selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 1,
        ),
        child: ListView(
          shrinkWrap: true,
          children: popularCities
              .map(
                (city) => ListTile(
                  title: Text(
                    city,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, city),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected != null && selected != userCity) {
      setState(() {
        userCity = selected;
      });
    }
  }

  void _openFilterSheet() async {
    final brands = cars.map((c) => c.brand).toSet().toList();
    final fuels = cars.map((c) => c.fuelType).toSet().toList();
    double minPrice = cars.isEmpty
        ? 0
        : cars.map((c) => c.pricePerDay).reduce((a, b) => a < b ? a : b);
    double maxPrice = cars.isEmpty
        ? 100000
        : cars.map((c) => c.pricePerDay).reduce((a, b) => a > b ? a : b);
    RangeValues priceRange =
        selectedPriceRange ?? RangeValues(minPrice, maxPrice);
    await showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF211F24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Brand',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  Wrap(
                    spacing: 15,
                    children: brands
                        .map(
                          (brand) => ChoiceChip(
                            label: Text(
                              brand,
                              style: GoogleFonts.poppins(
                                color: selectedBrand == brand
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            selected: selectedBrand == brand,
                            selectedColor: Color(0xFFD69C39),
                            backgroundColor: Color(0xFF26242B),
                            onSelected: (_) =>
                                setModalState(() => selectedBrand = brand),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Fuel Type',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  Wrap(
                    spacing: 8,
                    children: fuels
                        .map(
                          (fuel) => ChoiceChip(
                            label: Text(
                              fuel,
                              style: GoogleFonts.poppins(
                                color: selectedFuel == fuel
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            selected: selectedFuel == fuel,
                            selectedColor: Color(0xFFD69C39),
                            backgroundColor: Color(0xFF26242B),
                            onSelected: (_) =>
                                setModalState(() => selectedFuel = fuel),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Price Range',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  RangeSlider(
                    values: priceRange,
                    min: minPrice,
                    max: maxPrice,
                    divisions: 10,
                    activeColor: Color(0xFFD69C39),
                    inactiveColor: Colors.white24,
                    labels: RangeLabels(
                      '₹${priceRange.start.toInt()}',
                      '₹${priceRange.end.toInt()}',
                    ),
                    onChanged: (range) =>
                        setModalState(() => priceRange = range),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD69C39),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedBrand = null;
                            selectedFuel = null;
                            selectedPriceRange = null;
                            filteredCars = List.from(cars);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Clear'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD69C39),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedPriceRange = priceRange;
                              filteredCars = cars.where((car) {
                                final brandMatch =
                                    selectedBrand == null ||
                                    car.brand == selectedBrand;
                                final fuelMatch =
                                    selectedFuel == null ||
                                    car.fuelType == selectedFuel;
                                final priceMatch =
                                    (car.pricePerDay >= priceRange.start &&
                                    car.pricePerDay <= priceRange.end);
                                return brandMatch && fuelMatch && priceMatch;
                              }).toList();
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openSortSheet() async {
    final sorts = ['Price: Low to High', 'Price: High to Low', 'Most Popular'];
    await showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF211F24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              ...sorts.map(
                (sort) => ListTile(
                  title: Text(
                    sort,
                    style: GoogleFonts.poppins(
                      color: selectedSort == sort
                          ? Color(0xFFD69C39)
                          : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedSort = sort;
                      if (sort == 'Price: Low to High') {
                        filteredCars.sort(
                          (a, b) => a.pricePerDay.compareTo(b.pricePerDay),
                        );
                      } else if (sort == 'Price: High to Low') {
                        filteredCars.sort(
                          (a, b) => b.pricePerDay.compareTo(a.pricePerDay),
                        );
                      } else if (sort == 'Most Popular') {
                        filteredCars.sort(
                          (a, b) => b.rentalCount.compareTo(a.rentalCount),
                        );
                      }
                    });
                    Navigator.pop(context);
                  },
                  trailing: selectedSort == sort
                      ? Icon(Icons.check, color: Color(0xFFD69C39))
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF211F24),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFD69C39)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 120),
            children: [
              // Simple Search Bar
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: Colors.white60),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: GoogleFonts.poppins(color: Colors.white38),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 2),
                        ),
                        cursorColor: Colors.white12,
                      ),
                    ),
                  ],
                ),
              ),
              // Showing X cars in
              Text(
                'Showing ${filteredCars.where((car) => car.location == userCity).length} cars in',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // User location and Change option
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFD69C39),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        userCity,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: showCitySelector,
                    child: Text(
                      "Change",
                      style: GoogleFonts.poppins(
                        color: Color(0xFFD69C39),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFD69C39),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Car List
              ...filteredCars
                  .where((car) => car.location == userCity)
                  .map((car) => carCard(car)),
              const SizedBox(height: 90),
            ],
          ),
          // Floating Filter/Sort Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 70,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _openFilterSheet,
                      child: Row(
                        children: [
                          Icon(Icons.tune, color: Colors.black, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Filter",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: _openSortSheet,
                      child: Row(
                        children: [
                          Icon(Icons.sort, color: Colors.black, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Sort by",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget carCard(Car car) {
    // Convert Car to Map for UI display
    Map<String, dynamic> carMap = {
      'image': car.imageUrl,
      'warranty': '${car.warrantyYear} Year Warranty',
      'warrantyDate': car.warrantyDate != null
          ? 'Till ${DateFormat('dd MMM').format(car.warrantyDate!.toDate())}'
          : 'Till 31 May',
      'name': car.name,
      'isFav': false,
      'km': '${car.meter} Km',
      'type': car.transmissionType,
      'location': car.location,
      'badge': 'National Daily Drive',
      'delivery': car.delivery,
      'fuel': car.fuelType,
      'price': '₹${car.pricePerDay.toStringAsFixed(0)}',
      'monthly': '₹${(car.pricePerDay / 12).toStringAsFixed(0)} / month ',
    };

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CarDetailsPage(car: car)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: Color(0xFF26242B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car image and warranty
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    carMap['image'],
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                if (carMap['warranty'] != null) ...[
                  Positioned(
                    left: 0,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFD69C39),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        carMap['warranty'],
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        carMap['warrantyDate'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            // Car name and fav
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      carMap['name'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        carMap['isFav'] = !(carMap['isFav'] ?? false);
                      });
                    },
                    child: Icon(
                      carMap['isFav'] ? Icons.favorite : Icons.favorite_border,
                      color: Color(0xFFD69C39),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(
                    carMap['km'],
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text('  •  ', style: TextStyle(color: Colors.white24)),
                  Text(
                    carMap['type'],
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text('  •  ', style: TextStyle(color: Colors.white24)),
                  Text(
                    carMap['location'],
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          carMap['badge'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: carMap['delivery']
                          ? Color(0xFFD69C39)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_shipping,
                          size: 16,
                          color: carMap['delivery']
                              ? Colors.black
                              : Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          carMap['delivery']
                              ? "Home Delivery"
                              : "No Home Delivery",
                          style: GoogleFonts.poppins(
                            color: carMap['delivery']
                                ? Colors.black
                                : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          carMap['fuel'] == 'EV'
                              ? Icons.electric_car
                              : carMap['fuel'] == 'Diesel'
                              ? Icons.local_gas_station
                              : Icons.local_gas_station,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          carMap['fuel'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11),
            // Price and monthly
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Row(
                children: [
                  Text(
                    carMap['price'],
                    style: GoogleFonts.poppins(
                      color: Color(0xFFD69C39),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Text(
                    carMap['monthly'],
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
