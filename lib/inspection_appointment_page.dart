import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InspectionAppointmentPage extends StatelessWidget {
  const InspectionAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 24),
            Text(
              "Sell to Us for\na better price",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Inspect at Our centers or anywhere from INDIA.",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Car image with people (replace with actual asset in real app)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Image.network(
                  "https://www.bmw.in/content/dam/bmw/marketIN/bmw_in/Images/Topics/BPS/360%20check.jpg", // replace with your asset path
                  fit: BoxFit.fill,

                  height: 180,
                ),
              ),
            ),
            const SizedBox(height: 26),
            Text(
              "Your Car Selling Journey Made Hassle-free",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _stepTile("1. Book an Inspection", Icons.calendar_today),
            _stepTile("2. Get Your Car Inspected", Icons.car_repair),
            _stepTile("3. Sell Your Car", Icons.sell),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFD69C39),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: Navigate to actual appointment booking form/page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Proceeding to appointment booking...'),
                    ),
                  );
                },
                child: Text(
                  "Get Your Car’s Price",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF211F24),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  Widget _stepTile(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2C30),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD69C39), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    // Example, should be replaced with your actual MainScaffold navigation
    return BottomNavigationBar(
      currentIndex: 2, // Sell Car tab index
      backgroundColor: const Color(0xFF2D2C30),
      selectedItemColor: const Color(0xFFD69C39),
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (idx) {
        // Handle navigation
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Browse cars',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell Car'),
        BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'Inbox'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}
