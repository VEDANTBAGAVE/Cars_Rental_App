import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'car_details_page.dart';

class BrowseCarsPage extends StatefulWidget {
  const BrowseCarsPage({super.key});

  @override
  State<BrowseCarsPage> createState() => _BrowseCarsPageState();
}

class _BrowseCarsPageState extends State<BrowseCarsPage> {
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

  // Replace this with actual user location logic (use geolocator package)
  String userCity = "Mumbai"; // Default/fallback city

  // Dummy car list
  final List<Map<String, dynamic>> cars = [
    {
      'image':
          'https://imgd.aeplcdn.com/664x374/n/cw/ec/40432/scorpio-n-exterior-right-front-three-quarter-77.avif?auto=compress&w=400',
      'warranty': '3-Year Warranty',
      'warrantyDate': 'Till 31 May',
      'name': 'Mahindra Scorpio N',
      'isFav': false,
      'km': '87,744km',
      'type': 'Automatic',
      'location': 'Mumbai',
      'badge': 'National Daily Drive',
      'delivery': true,
      'fuel': 'Petrol',
      'price': '₹40,800',
      'monthly': '₹490/mo',
    },
    {
      'image':
          'https://imgd.aeplcdn.com/664x374/n/cw/ec/131825/be-6e-exterior-right-front-three-quarter-5.jpeg?auto=compress&w=400',
      'warranty': '3-Year Warranty',
      'warrantyDate': 'Till 31 May',
      'name': 'Mahindra BE 6',
      'isFav': false,
      'km': '87,744km',
      'type': 'Automatic',
      'location': 'Pune',
      'badge': 'National Daily Drive',
      'delivery': true,
      'fuel': 'EV',
      'price': '₹50,800',
      'monthly': '₹490/mo',
    },
    // ... more cars
  ];

  int get carCount => cars.length;

  void showCitySelector() async {
    String? selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        // Constrain the height to at most half the screen (adjust as needed)
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

  @override
  Widget build(BuildContext context) {
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
                'Showing $carCount cars in',
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
                        decorationColor: Color(
                          0xFFD69C39,
                        ), // This adds underline
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Car List
              ...cars
                  .where((car) => car['location'] == userCity)
                  .map((car) => carCard(car))
                  .toList(),
              const SizedBox(height: 90),
            ],
          ),
          // Floating Filter/Sort Bar (as before)
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
                      onTap: () {
                        /* open filter sheet */
                      },
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
                      onTap: () {
                        /* open sort sheet */
                      },
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

  Widget carCard(Map<String, dynamic> car) {
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
                    car['image'],
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                if (car['warranty'] != null) ...[
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
                        car['warranty'],
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
                        car['warrantyDate'],
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
                      car['name'],
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
                        car['isFav'] = !(car['isFav'] ?? false);
                      });
                    },
                    child: Icon(
                      car['isFav'] ? Icons.favorite : Icons.favorite_border,
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
                    car['km'],
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text('  •  ', style: TextStyle(color: Colors.white24)),
                  Text(
                    car['type'],
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text('  •  ', style: TextStyle(color: Colors.white24)),
                  Text(
                    car['location'],
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
            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8, // space between badges horizontally
                runSpacing: 8, // space between lines when wrapping
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
                          car['badge'],
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
                      color: car['delivery']
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
                          color: car['delivery'] ? Colors.black : Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          car['delivery']
                              ? "Home Delivery"
                              : "No Home Delivery",
                          style: GoogleFonts.poppins(
                            color: car['delivery']
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
                          car['fuel'] == 'EV'
                              ? Icons.electric_car
                              : car['fuel'] == 'Diesel'
                              ? Icons.local_gas_station
                              : Icons.local_gas_station,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          car['fuel'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // You can add more badges here if needed
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
                    car['price'],
                    style: GoogleFonts.poppins(
                      color: Color(0xFFD69C39),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Text(
                    car['monthly'],
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
