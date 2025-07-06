import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/car.dart';

class BookingPage extends StatefulWidget {
  final Car car;

  const BookingPage({super.key, required this.car});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? pickUpDate;
  TimeOfDay? pickUpTime;
  DateTime? dropOffDate;
  TimeOfDay? dropOffTime;

  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  double get dailyRate {
    return widget.car.hasDiscount ? widget.car.discountedPrice : widget.car.pricePerDay;
  }

  Duration get rentalDuration {
    if (pickUpDate == null ||
        pickUpTime == null ||
        dropOffDate == null ||
        dropOffTime == null) {
      return Duration.zero;
    }
    final pick = DateTime(
      pickUpDate!.year,
      pickUpDate!.month,
      pickUpDate!.day,
      pickUpTime!.hour,
      pickUpTime!.minute,
    );
    final drop = DateTime(
      dropOffDate!.year,
      dropOffDate!.month,
      dropOffDate!.day,
      dropOffTime!.hour,
      dropOffTime!.minute,
    );
    return drop.isAfter(pick) ? drop.difference(pick) : Duration.zero;
  }

  double get totalPrice {
    if (dailyRate == 0 || rentalDuration.inMinutes == 0) return 0;
    final days = rentalDuration.inHours / 24;
    final roundedDays = days.ceil(); // charge by day
    return roundedDays * dailyRate;
  }

  String formatDate(DateTime? date) =>
      date == null ? "--/--/----" : DateFormat('MMM dd, yyyy').format(date);

  String formatTime(TimeOfDay? time) =>
      time == null ? "--:--" : time.format(context);

  Future<void> pickDate({required bool isPickUp}) async {
    final now = DateTime.now();
    final initial = isPickUp
        ? pickUpDate ?? now
        : dropOffDate ?? pickUpDate ?? now;
    final firstDate = isPickUp ? now : (pickUpDate ?? now);
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1),
    );
    if (date != null) {
      setState(() {
        if (isPickUp) {
          pickUpDate = date;
          if (dropOffDate == null || dropOffDate!.isBefore(date)) {
            dropOffDate = date;
          }
        } else {
          dropOffDate = date;
        }
      });
    }
  }

  Future<void> pickTime({required bool isPickUp}) async {
    final initial = TimeOfDay.now();
    final time = await showTimePicker(context: context, initialTime: initial);
    if (time != null) {
      setState(() {
        if (isPickUp) {
          pickUpTime = time;
          dropOffTime ??= time;
        } else {
          dropOffTime = time;
        }
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
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
          "Book Your Car",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        children: [
          // Car summary
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.car.imageUrl,
                  width: 90,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.car.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${widget.car.brand} - ${widget.car.transmissionType}',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Pick-up and Drop-off
          _sectionTitle("Pick-up & Drop-off"),
          _dateTimeRow(
            label: "Pick-up",
            date: pickUpDate,
            time: pickUpTime,
            onDateTap: () => pickDate(isPickUp: true),
            onTimeTap: () => pickTime(isPickUp: true),
            icon: Icons.event_available,
          ),
          const SizedBox(height: 8),
          _dateTimeRow(
            label: "Drop-off",
            date: dropOffDate,
            time: dropOffTime,
            onDateTap: () => pickDate(isPickUp: false),
            onTimeTap: () => pickTime(isPickUp: false),
            icon: Icons.event_busy,
          ),
          const SizedBox(height: 16),

          // Address
          _sectionTitle("Delivery Address"),
          TextField(
            controller: _addressController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter your delivery address",
              hintStyle: GoogleFonts.poppins(color: Colors.white38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD69C39)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Personal Information
          _sectionTitle("Personal Information"),
          TextField(
            controller: _nameController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Full Name",
              hintStyle: GoogleFonts.poppins(color: Colors.white38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD69C39)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Phone Number",
              hintStyle: GoogleFonts.poppins(color: Colors.white38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD69C39)),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Price Summary
          _sectionTitle("Price Summary"),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (widget.car.hasDiscount) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Original Price:",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "₹${widget.car.pricePerDay.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount:",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "-₹${widget.car.discountAmount.toStringAsFixed(0)} (${widget.car.discountPercentage.toStringAsFixed(0)}%)",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daily Rate:",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "₹${dailyRate.toStringAsFixed(0)}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Duration:",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${rentalDuration.inDays} days",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:",
                      style: GoogleFonts.poppins(
                        color: Color(0xFFD69C39),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "₹${totalPrice.toStringAsFixed(0)}",
                      style: GoogleFonts.poppins(
                        color: Color(0xFFD69C39),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Confirm Booking Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed:
                  (pickUpDate != null &&
                      dropOffDate != null &&
                      _nameController.text.isNotEmpty &&
                      _phoneController.text.isNotEmpty)
                  ? () {
                      // Handle booking confirmation
                      _showBookingConfirmation();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD69C39),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Confirm Booking",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _dateTimeRow({
    required String label,
    required DateTime? date,
    required TimeOfDay? time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD69C39), size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              formatDate(date),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTimeTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              formatTime(time),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D2C30),
        title: Text(
          "Booking Confirmed!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Your booking for ${widget.car.name} has been confirmed. You will receive a confirmation email shortly.",
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                color: Color(0xFFD69C39),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
