import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_page.dart';
import 'models/car.dart';

class CarDetailsPage extends StatefulWidget {
  final Car car;

  const CarDetailsPage({super.key, required this.car});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  int currentImageIndex = 0;
  late List<String> imageUrls;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Use car.imageUrls (List<String>) for carousel
    imageUrls = widget.car.imageUrls;
    _pageController = PageController(
      initialPage: currentImageIndex,
      viewportFraction: 0.92,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Helper for safe field extraction
    T safe<T>(dynamic value, T fallback) {
      if (value == null) return fallback;

      // Handle int type
      if (T == int) {
        if (value is int) return value as T;
        if (value is double) return value.toInt() as T;
        if (value is String) {
          int? parsed = int.tryParse(value);
          return (parsed ?? fallback) as T;
        }
        return fallback;
      }

      // Handle double type
      if (T == double) {
        if (value is double) return value as T;
        if (value is int) return value.toDouble() as T;
        if (value is String) {
          double? parsed = double.tryParse(value);
          return (parsed ?? fallback) as T;
        }
        return fallback;
      }

      // Handle other types
      if (value is T) return value;
      return fallback;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
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
                      contentPadding: const EdgeInsets.only(bottom: 2),
                    ),
                    cursorColor: Colors.white12,
                  ),
                ),
              ],
            ),
          ),

          // Image carousel
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.zero,
            child: imageUrls.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: imageUrls.length,
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            double scale = 1.0;
                            if (_pageController.hasClients) {
                              double page =
                                  _pageController.page ??
                                  _pageController.initialPage.toDouble();
                              double diff = (page - index).abs();
                              // Use a curve for smoothness
                              double curved = Curves.easeOut.transform(
                                (1 - (diff * 0.8)).clamp(0.0, 1.0),
                              );
                              scale = 0.92 + (curved * 0.08); // 0.92 to 1.0
                            }
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Color(0xFF26242B),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 255, 183, 0),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    imageUrls[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[800],
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.white54,
                                                size: 60,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (imageUrls.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              imageUrls.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentImageIndex == index
                                      ? const Color(0xFFD69C39)
                                      : Colors.white24,
                                  boxShadow: currentImageIndex == index
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFD69C39,
                                            ).withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : Container(
                    height: 220,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                      size: 60,
                    ),
                  ),
          ),

          // Car name
          Text(
            safe(widget.car.name, ''),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),

          // Details row
          Row(
            children: [
              Text(
                '${safe(widget.car.meter, 0.0).toInt()} km',
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
              ),
              const Text('  |  ', style: TextStyle(color: Colors.white24)),
              Text(
                safe(widget.car.transmissionType, ''),
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
              ),
              const Text('  |  ', style: TextStyle(color: Colors.white24)),
              Text(
                safe(widget.car.fuelType, ''),
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rental Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.car.hasDiscount) ...[
                    Text(
                      '₹${safe(widget.car.pricePerDay, 0.0)}',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                  Text(
                    widget.car.hasDiscount 
                        ? '₹${safe(widget.car.discountedPrice, 0.0)}'
                        : '₹${safe(widget.car.pricePerDay, 0.0)}',
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
              if (widget.car.hasDiscount) ...[
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${widget.car.discountPercentage.toStringAsFixed(0)}% OFF',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Rental duration selector
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFFD69C39),
                size: 20,
              ),
              const SizedBox(width: 6),
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
              const Icon(Icons.location_on, color: Color(0xFFD69C39), size: 20),
              const SizedBox(width: 8),
              Text(
                safe(widget.car.location, ''),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${safe(widget.car.seats, 0.0).toInt()} Seats',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.car.delivery == true
                      ? const Color(0xFFD69C39)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: widget.car.delivery == true
                          ? Colors.black
                          : Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.car.delivery == true
                          ? "Home Delivery"
                          : "No Home Delivery",
                      style: GoogleFonts.poppins(
                        color: widget.car.delivery == true
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
                    builder: (context) => BookingPage(car: widget.car),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD69C39),
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
