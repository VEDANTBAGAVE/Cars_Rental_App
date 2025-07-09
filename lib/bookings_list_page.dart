import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/booking.dart';
import 'services/firebase_service.dart';
import 'services/auth_service.dart';
import 'booking_details_page.dart';

class BookingsListPage extends StatefulWidget {
  const BookingsListPage({super.key});

  @override
  State<BookingsListPage> createState() => _BookingsListPageState();
}

class _BookingsListPageState extends State<BookingsListPage>
    with SingleTickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  
  List<Booking> _bookings = [];
  bool _isLoading = true;
  String _selectedStatus = 'all';
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    if (_authService.currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bookings = await _firebaseService.getUserBookings(_authService.currentUser!.uid);
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading bookings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Booking> get _filteredBookings {
    switch (_selectedStatus) {
      case 'upcoming':
        return _bookings.where((booking) => booking.isUpcoming && booking.status != 'cancelled').toList();
      case 'active':
        return _bookings.where((booking) => booking.isActive && booking.status == 'confirmed').toList();
      case 'completed':
        return _bookings.where((booking) => booking.isCompleted || booking.status == 'completed').toList();
      case 'cancelled':
        return _bookings.where((booking) => booking.status == 'cancelled').toList();
      default:
        return _bookings;
    }
  }

  String _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'confirmed':
        return '#4CAF50'; // Green
      case 'active':
        return '#2196F3'; // Blue
      case 'completed':
        return '#9C27B0'; // Purple
      case 'cancelled':
        return '#F44336'; // Red
      default:
        return '#757575'; // Grey
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F24),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "My Bookings",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadBookings,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFD69C39),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400),
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _selectedStatus = 'all';
                  break;
                case 1:
                  _selectedStatus = 'upcoming';
                  break;
                case 2:
                  _selectedStatus = 'active';
                  break;
                case 3:
                  _selectedStatus = 'completed';
                  break;
              }
            });
          },
        ),
      ),
      body: _authService.currentUser == null
          ? _buildLoginPrompt()
          : _isLoading
              ? _buildLoadingState()
              : _filteredBookings.isEmpty
                  ? _buildEmptyState()
                  : _buildBookingsList(),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            size: 64,
            color: Colors.white38,
          ),
          SizedBox(height: 16),
          Text(
            'Please login to view your bookings',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Login to see all your car rental bookings',
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFD69C39)),
          SizedBox(height: 16),
          Text(
            'Loading your bookings...',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.car_rental,
            size: 64,
            color: Colors.white38,
          ),
          SizedBox(height: 16),
          Text(
            'No bookings found',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _selectedStatus == 'all'
                ? 'You haven\'t made any bookings yet'
                : 'No ${_selectedStatus} bookings found',
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD69C39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Browse Cars',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return RefreshIndicator(
      onRefresh: _loadBookings,
      color: Color(0xFFD69C39),
      backgroundColor: Color(0xFF2D2C30),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = _filteredBookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF26242B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsPage(booking: booking),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with car info and status
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      booking.carImageUrl,
                      width: 60,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 40,
                          color: Colors.grey[800],
                          child: Icon(Icons.directions_car, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.carName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          booking.carBrand,
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(int.parse(_getStatusColor(booking.status).replaceAll('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(booking.status),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Booking details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pick-up',
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${booking.formattedPickUpDate} at ${booking.formattedPickUpTime}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Drop-off',
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${booking.formattedDropOffDate} at ${booking.formattedDropOffTime}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              
              // Price and duration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${booking.rentalDays} days',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '₹${booking.totalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          color: Color(0xFFD69C39),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              
              // Booking ID
              Text(
                'Booking ID: ${booking.id}',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 