import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F24),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _sectionLabel("Personal"),
          _roundedCard(
            child: ListTile(
              leading: const Icon(Icons.person, color: Color(0xFFD69C39)),
              title: Text(
                "Personal Information",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white24,
                size: 18,
              ),
              onTap: () {
                // Navigate to personal info settings
              },
            ),
          ),
          const SizedBox(height: 20),
          _sectionLabel("Language"),
          _roundedCard(
            child: Column(
              children: [
                _languageTile(
                  context,
                  flag: "🇬🇧", // English flag
                  name: "English",
                  onTap: () {},
                ),
                const Divider(
                  color: Colors.white12,
                  height: 1,
                  indent: 18,
                  endIndent: 18,
                ),
                _languageTile(
                  context,
                  flag: "🇮🇳", // Indian flag for Hindi
                  name: "Hindi",
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _roundedCard(
            child: Column(
              children: [
                _menuTile("Term of use", onTap: () {}),
                _divider(),
                _menuTile("Privacy Policy", onTap: () {}),
                _divider(),
                _menuTile("Delete Account", onTap: () {}),
                _divider(),
                _menuTile(
                  "About VAN",
                  trailing: Text(
                    "v1.0.0",
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {},
                ),
                _divider(),
                _menuTile(
                  "Clear Cache",
                  trailing: Text(
                    "1.4MB",
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      label,
      style: GoogleFonts.poppins(
        color: Colors.white60,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.4,
      ),
    ),
  );

  Widget _roundedCard({required Widget child}) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF2D2C30),
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );

  Widget _menuTile(
    String title, {
    Widget? trailing,
    required VoidCallback onTap,
  }) => ListTile(
    title: Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing:
        trailing ??
        const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 18),
    onTap: onTap,
    dense: true,
    visualDensity: VisualDensity.compact,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
  );

  Widget _divider() => const Divider(
    color: Colors.white12,
    height: 1,
    indent: 18,
    endIndent: 18,
  );

  Widget _languageTile(
    BuildContext context, {
    required String flag,
    required String name,
    String? version,
    String? cache,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(
        name,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white24,
        size: 18,
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
    );
  }
}
