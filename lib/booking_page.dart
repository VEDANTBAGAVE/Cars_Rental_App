import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> car;

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
    // Example: parse '₹40,800' to 40800.0
    final rateString =
        widget.car['price']?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0';
    return double.tryParse(rateString) ?? 0.0;
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
          if (dropOffTime == null) dropOffTime = time;
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
                  widget.car['image'],
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
                      widget.car['name'] ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.car['type'] ?? "",
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
              hintText: "Enter your address for delivery",
              hintStyle: GoogleFonts.poppins(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF2D2C30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.location_on, color: Color(0xFFD69C39)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          // User details
          _sectionTitle("Contact Details"),
          TextField(
            controller: _nameController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Full Name",
              hintStyle: GoogleFonts.poppins(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF2D2C30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.person, color: Color(0xFFD69C39)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            style: GoogleFonts.poppins(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone Number",
              hintStyle: GoogleFonts.poppins(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF2D2C30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.phone, color: Color(0xFFD69C39)),
            ),
          ),
          const SizedBox(height: 20),
          // Summary
          _sectionTitle("Summary"),
          _summaryRow(
            "Rental Duration",
            rentalDuration == Duration.zero
                ? "--"
                : "${rentalDuration.inHours ~/ 24} days ${(rentalDuration.inHours % 24)} hrs",
          ),
          _summaryRow("Daily Rate", "₹${dailyRate.toStringAsFixed(0)}"),
          _summaryRow("Total", "₹${totalPrice.toStringAsFixed(0)}"),
          const SizedBox(height: 24),
          // Confirm Booking Button
          ElevatedButton.icon(
            icon: Icon(Icons.check_circle_outline, color: Colors.black),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD69C39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 18),
            ),
            onPressed: () {
              // Validation
              if (pickUpDate == null ||
                  pickUpTime == null ||
                  dropOffDate == null ||
                  dropOffTime == null ||
                  _addressController.text.trim().isEmpty ||
                  _nameController.text.trim().isEmpty ||
                  _phoneController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please complete all fields!")),
                );
                return;
              }
              // TODO: Booking logic
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Color(0xFF211F24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    "Booking Confirmed!",
                    style: GoogleFonts.poppins(
                      color: Color(0xFFD69C39),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "Thank you, ${_nameController.text.trim()}!\n"
                    "Your car will be delivered to:\n${_addressController.text}\n"
                    "on ${formatDate(pickUpDate)} at ${formatTime(pickUpTime)}.",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "OK",
                        style: GoogleFonts.poppins(color: Color(0xFFD69C39)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context); // Go back to details/list
                      },
                    ),
                  ],
                ),
              );
            },
            label: Text(
              "Confirm Booking",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  );

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
        Icon(icon, color: Color(0xFFD69C39)),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onDateTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFF2D2C30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white38, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    date == null ? "Choose Date" : formatDate(date),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onTimeTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFF2D2C30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white38, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    time == null ? "Choose Time" : formatTime(time),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Color(0xFFD69C39),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
