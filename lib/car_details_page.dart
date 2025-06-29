import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_page.dart';

class CarDetailsPage extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarDetailsPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 120),
        children: [
          // Search bar
          Container(
            height: 45,
            margin: const EdgeInsets.only(bottom: 18),
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
                      hintText: "Search cars...",
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

          // Car image
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1A20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.network(
                  car['image'],
                  height: 170,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                  onPressed: () {
                    // handle previous image
                  },
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    // handle next image
                  },
                ),
              ),
            ],
          ),

          // Warranty bar
          if (car['warranty'] != null && car['warranty'].toString().isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD69C39),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Text(
                      car['warranty'] ?? '',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                if (car['warrantyDate'] != null &&
                    car['warrantyDate'].toString().isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2C30),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Text(
                      car['warrantyDate'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 16),

          // Car name
          Text(
            car['name'] ?? '',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),

          // Details row
          Row(
            children: [
              Text(
                '${car['km']}',
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
              ),
              const Text('  |  ', style: TextStyle(color: Colors.white24)),
              Text(
                '${car['type']}',
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
              ),
              const Text('  |  ', style: TextStyle(color: Colors.white24)),
              Text(
                '${car['fuel']}',
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rental Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                car['price'] ?? '',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFD69C39),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "per day",
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rental duration selector
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFFD69C39), size: 20),
              SizedBox(width: 6),
              Text(
                "Rental period: 1-30 days",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFD69C39), size: 20),
              SizedBox(width: 8),
              Text(
                car['location'] ?? '',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Badges
          Wrap(
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
                      car['badge'] ?? '',
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
                  color: car['delivery'] == true
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
                      color: car['delivery'] == true
                          ? Colors.black
                          : Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      car['delivery'] == true
                          ? "Home Delivery"
                          : "No Home Delivery",
                      style: GoogleFonts.poppins(
                        color: car['delivery'] == true
                            ? Colors.black
                            : Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Book Now Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(car: car),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD69C39),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Book Now',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
