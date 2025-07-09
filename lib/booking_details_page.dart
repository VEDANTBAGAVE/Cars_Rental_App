import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/booking.dart';
import 'services/firebase_service.dart';

class BookingDetailsPage extends StatefulWidget {
  final Booking booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

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

  Future<void> _cancelBooking() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D2C30),
        title: Text(
          'Cancel Booking',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _firebaseService.cancelBooking(widget.booking.id);
        setState(() {
          _isLoading = false;
        });
        
        // Show success message and pop back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel booking'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          "Booking Details",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Color(0xFFD69C39)),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Information Card
                  _buildInfoCard(
                    title: "Car Information",
                    icon: Icons.directions_car,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.booking.carImageUrl,
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 60,
                                  color: Colors.grey[800],
                                  child: Icon(Icons.directions_car, color: Colors.grey[600]),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.booking.carName,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  widget.booking.carBrand,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Booking Status Card
                  _buildInfoCard(
                    title: "Booking Status",
                    icon: Icons.info_outline,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(int.parse(_getStatusColor(widget.booking.status).replaceAll('#', '0xFF'))),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _getStatusText(widget.booking.status),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Booking ID",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            widget.booking.id,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Created",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(widget.booking.createdAt),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Rental Details Card
                  _buildInfoCard(
                    title: "Rental Details",
                    icon: Icons.schedule,
                    children: [
                      _buildDetailRow("Pick-up Date", widget.booking.formattedPickUpDate),
                      _buildDetailRow("Pick-up Time", widget.booking.formattedPickUpTime),
                      _buildDetailRow("Drop-off Date", widget.booking.formattedDropOffDate),
                      _buildDetailRow("Drop-off Time", widget.booking.formattedDropOffTime),
                      _buildDetailRow("Duration", "${widget.booking.rentalDays} days"),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Customer Information Card
                  _buildInfoCard(
                    title: "Customer Information",
                    icon: Icons.person,
                    children: [
                      _buildDetailRow("Name", widget.booking.customerName),
                      _buildDetailRow("Phone", widget.booking.customerPhone),
                      _buildDetailRow("Delivery Address", widget.booking.deliveryAddress),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Payment Information Card
                  _buildInfoCard(
                    title: "Payment Information",
                    icon: Icons.payment,
                    children: [
                      _buildDetailRow("Daily Rate", "₹${widget.booking.dailyRate.toStringAsFixed(0)}"),
                      _buildDetailRow("Total Amount", "₹${widget.booking.totalPrice.toStringAsFixed(0)}"),
                      _buildDetailRow("Payment Status", widget.booking.paymentStatus ?? 'Pending'),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Action Buttons
                  if (widget.booking.status == 'pending' || widget.booking.status == 'confirmed')
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _cancelBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel Booking",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF26242B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFFD69C39), size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
} 