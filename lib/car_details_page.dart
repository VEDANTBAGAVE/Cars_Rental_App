import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_page.dart'; // Import your booking page

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
          // Car image and carousel arrows
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
          // Warranty bar (optional, can be "Rental Guarantee" or remove)
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
          // Rental duration selector (demo: static)
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFFD69C39), size: 20),
              SizedBox(width: 6),
              Text(
                "Rental period: 1-30 days",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick Book CTA
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD69C39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingPage(car: car)),
              );
              // TODO: Implement booking functionality
            },
            child: Text(
              "Book Now",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Promotion Details Button (if any)
          if (car['promotion'] != null &&
              car['promotion'].toString().isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2C30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.local_offer, color: Color(0xFFD69C39)),
                title: Text(
                  "Promotion Details",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.expand_more, color: Colors.white),
                onTap: () {
                  // Expand/collapse promotion details
                },
              ),
            ),
          const SizedBox(height: 8),
          // Key Highlights
          Text(
            "Key Highlights:",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text(
                  "Luxury",
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                ),
                backgroundColor: const Color(0xFF48454F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Add more highlights as needed
            ],
          ),
          const SizedBox(height: 14),
          // Services
          Text(
            "Rental Includes",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              _serviceChip("Comprehensive Insurance"),
              _serviceChip("24/7 Roadside Assistance"),
              _serviceChip("Free Cancellation"),
            ],
          ),
          const SizedBox(height: 14),
          // Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Color(0xFFD69C39), size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  car['location'] ?? '',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // Rental Reviews Section (placeholder)
          Text(
            "Reviews",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          _reviewTile(
            user: "Rahul",
            review:
                "Great experience! The car was clean and the pickup was smooth.",
            rating: 5,
          ),
          _reviewTile(
            user: "Ayesha",
            review: "Easy booking and very responsive support.",
            rating: 4,
          ),
          // Add more reviews as needed
        ],
      ),
    );
  }

  Widget _serviceChip(String text) {
    return Chip(
      label: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
      ),
      backgroundColor: const Color(0xFF48454F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _reviewTile({
    required String user,
    required String review,
    required int rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2C30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFD69C39),
            child: Text(
              user[0],
              style: GoogleFonts.poppins(color: Colors.black),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  review,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      size: 16,
                      color: i < rating ? Color(0xFFD69C39) : Colors.white24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
