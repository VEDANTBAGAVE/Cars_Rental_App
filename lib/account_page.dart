import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F24),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Account",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        children: [
          const SizedBox(height: 8),
          Text(
            "Log in for the Best Experience!",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          // Quick actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickAction(
                icon: Icons.calendar_today,
                label: "My Appointments",
                onTap: () {},
              ),
              _quickAction(
                icon: Icons.directions_car,
                label: "My Orders",
                onTap: () {},
              ),
              _quickAction(
                icon: Icons.card_giftcard,
                label: "My Vouchers",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Main account functions
          _accountTile(
            icon: Icons.favorite_border,
            label: "My Favorites",
            onTap: () {},
          ),
          _accountTile(
            icon: Icons.history,
            label: "Browsing History",
            onTap: () {},
          ),
          _accountTile(
            icon: Icons.settings_sharp,
            label: "Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          _accountTile(icon: Icons.help_outline, label: "FAQ", onTap: () {}),
          _accountTile(
            icon: Icons.thumb_up_alt_outlined,
            label: "Rate Our App",
            onTap: () {
              // Open rating
            },
          ),
          _accountTile(
            icon: Icons.phone,
            label: "Contact Us",
            trailing: Text(
              "0000000000",
              style: GoogleFonts.poppins(
                color: Color(0xFFD69C39),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Call or contact
            },
          ),
          const SizedBox(height: 18),
          // Feedback card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD69C39).withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: Color(0xFFD69C39)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Share Your Feedback",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Tell us about your thoughts or ideas. It helps us serve you better.",
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
          ),
          const SizedBox(height: 18),
          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFD69C39),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Navigate to login
              },
              child: Text(
                "Login",
                style: GoogleFonts.poppins(
                  color: Color(0xFF211F24),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
      // Bottom Navigation Bar Example
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2D2C30),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: Color(0xFFD69C39), size: 28),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountTile({
    required IconData icon,
    required String label,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFD69C39)),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          trailing ??
          Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }
}
