import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'services/firebase_service.dart';
import 'models/car.dart';
import 'car_details_page.dart';
import 'browse_cars_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firebase service
  final FirebaseService _firebaseService = FirebaseService();

  // Data from Firebase
  List<Car> featuredCars = [];
  List<Car> dealsCars = [];
  List<Car> trendingCars = [];
  List<Car> filteredCars = [];

  // Loading states
  bool isLoadingFeatured = true;
  bool isLoadingDeals = true;
  bool isLoadingTrending = true;

  @override
  void initState() {
    super.initState();
    // Load data from Firebase
    _loadHomeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Load all home page data
  Future<void> _loadHomeData() async {
    // Reset loading states
    setState(() {
      isLoadingFeatured = true;
      isLoadingDeals = true;
      isLoadingTrending = true;
    });

    await Future.wait([
      _loadFeaturedCars(),
      _loadDealsCars(),
      _loadTrendingCars(),
    ]);

    // Show success message for pull-to-refresh
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Home page refreshed!'),
        backgroundColor: Color(0xFFD69C39),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Load featured cars for carousel
  Future<void> _loadFeaturedCars() async {
    try {
      final cars = await _firebaseService.getFeaturedCars();
      setState(() {
        featuredCars = cars;
        isLoadingFeatured = false;
      });
    } catch (e) {
      print('Error loading featured cars: $e');
      setState(() {
        isLoadingFeatured = false;
      });
    }
  }

  // Load deals cars
  Future<void> _loadDealsCars() async {
    try {
      final cars = await _firebaseService.getDealsCars();
      setState(() {
        dealsCars = cars;
        isLoadingDeals = false;
      });
    } catch (e) {
      print('Error loading deals cars: $e');
      setState(() {
        isLoadingDeals = false;
      });
    }
  }

  // Load trending cars
  Future<void> _loadTrendingCars() async {
    try {
      final cars = await _firebaseService.getTrendingCars();
      setState(() {
        trendingCars = cars;
        isLoadingTrending = false;
      });
    } catch (e) {
      print('Error loading trending cars: $e');
      setState(() {
        isLoadingTrending = false;
      });
    }
  }

  // Filter cars by price range
  Future<void> _filterCarsByPrice(int filterIndex) async {
    double minPrice = 0;
    double maxPrice = double.infinity;

    switch (filterIndex) {
      case 0: // Under RS 30,000
        maxPrice = 30000;
        break;
      case 1: // RS 30,000 - 50,000
        minPrice = 30000;
        maxPrice = 50000;
        break;
      case 2: // RS 50,000 - 100,000
        minPrice = 50000;
        maxPrice = 100000;
        break;
      case 3: // Over RS 100,000
        minPrice = 100000;
        break;
    }

    try {
      final cars = await _firebaseService.getCarsByPriceRange(
        minPrice,
        maxPrice,
      );
      setState(() {
        filteredCars = cars;
      });
    } catch (e) {
      print('Error filtering cars: $e');
    }
  }

  final int _currentIndex = 0;

  final List<Map<String, String>> brands = const [
    {
      'image':
          'https://imgd.aeplcdn.com/0X0/n/cw/ec/9/brands/logos/mahindra.jpg',
      'name': 'Mahindra',
    },
    {
      'image': 'https://imgd.aeplcdn.com/0X0/n/cw/ec/16/brands/logos/tata.jpg',
      'name': 'Tata',
    },
    {
      'image': 'https://imgd.aeplcdn.com/0X0/n/cw/ec/1/brands/logos/bmw.jpg',
      'name': 'BMW',
    },
    {
      'image': 'https://imgd.aeplcdn.com/0X0/n/cw/ec/18/brands/logos/audi.jpg',
      'name': 'Audi',
    },
    {
      'image':
          'https://imgd.aeplcdn.com/0X0/n/cw/ec/17/brands/logos/toyota.jpg',
      'name': 'Toyota',
    },
    {
      'image':
          'https://imgd.aeplcdn.com/0X0/n/cw/ec/21/brands/logos/nissan.jpg',
      'name': 'Nissan',
    },
    {
      'image':
          'https://imgd.aeplcdn.com/0X0/n/cw/ec/10/brands/logos/maruti-suzuki1647009823420.jpg',
      'name': 'Maruti Suzuki',
    },
  ];

  int selectedFilterIndex = 0;
  final List<String> filters = [
    'Under RS 30,000',
    'RS 30,000 - 50,000',
    'RS 50,000 - 100,000',
    'Over RS 100,000',
  ];

  final List<Map<String, String>> topOffers = [
    {
      'image':
          'https://imgd.aeplcdn.com/664x374/n/cw/ec/40432/scorpio-n-exterior-right-front-three-quarter-77.avif?auto=compress&w=400',
      'title': 'Mahindra Scorpio N',
      'discount': 'Rs 3,500 OFF',
    },
    //aur add kar le dalle
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'VAN',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD69C39),
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                letterSpacing: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: 'TURE',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD69C39),
                                fontWeight: FontWeight.normal,
                                fontSize: 22,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Simple search icon that redirects to browse cars page
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFD69C39),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrowseCarsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        color: Color(0xFFD69C39),
        backgroundColor: Color(0xFF2D2C30),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            15,
            20,
            12,
            80,
          ), // enough padding for nav bar
          children: [
            // Featured Cars Carousel
            if (!isLoadingFeatured)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 900),
                  enableInfiniteScroll: true,
                ),
                items: featuredCars.map((car) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailsPage(car: car),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 10,
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
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(car.imageUrl, fit: BoxFit.cover),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car.name,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (car.hasDiscount)
                                          Text(
                                            'Rs ${car.discountAmount.toStringAsFixed(0)} OFF',
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFFD69C39),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

            if (isLoadingFeatured)
              SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFD69C39)),
                ),
              ),

            const SizedBox(height: 18),

            // Deals Section
            Row(
              children: [
                Icon(
                  Icons.local_offer_rounded,
                  size: 30,
                  color: Color(0xFFD69C39),
                ),
                SizedBox(width: 5),
                sectionTitle('Deals'),
              ],
            ),
            const SizedBox(height: 10),

            if (!isLoadingDeals)
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dealsCars.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return carCard(dealsCars[index]);
                  },
                ),
              ),

            if (isLoadingDeals)
              SizedBox(
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFD69C39)),
                ),
              ),

            const SizedBox(height: 18),

            // Explore Cars Section
            Row(
              children: [
                Icon(Icons.explore_rounded, size: 30, color: Color(0xFFD69C39)),
                SizedBox(width: 5),
                sectionTitle('Explore Cars for You'),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(filters.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                      _filterCarsByPrice(index);
                    },
                    child: filterChip(
                      filters[index],
                      selectedFilterIndex == index,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: brands
                    .map(
                      (brand) => brandButton(brand['image']!, brand['name']!),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Trending Cars Section
            Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 30,
                  color: Color(0xFFD69C39),
                ),
                SizedBox(width: 5),
                sectionTitle('Trending Cars in India'),
              ],
            ),
            const SizedBox(height: 8),

            if (!isLoadingTrending)
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingCars.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return carCard(trendingCars[index]);
                  },
                ),
              ),

            if (isLoadingTrending)
              SizedBox(
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFD69C39)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget carCard(Car car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF26242B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    car.imageUrl,
                    width: 200,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 100,
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                if (car.hasDiscount)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${car.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                car.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (car.hasDiscount) ...[
                        Text(
                          '₹${car.pricePerDay.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Text(
                        car.hasDiscount
                            ? '₹${car.discountedPrice.toStringAsFixed(0)}/day'
                            : '₹${car.pricePerDay.toStringAsFixed(0)}/day',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD69C39),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  if (car.hasDiscount)
                    Text(
                      '${car.discountPercentage.toStringAsFixed(0)}% OFF',
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
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

  Widget filterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD69C39) : const Color(0xFF26242B),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget brandButton(String imagePath, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Image.network(imagePath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 5),
          Text(
            name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

//in contuaniation
