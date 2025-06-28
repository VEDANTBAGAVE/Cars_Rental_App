import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'inspection_appointment_page.dart';

class SellCarPage extends StatefulWidget {
  const SellCarPage({super.key});

  @override
  State<SellCarPage> createState() => _SellCarPageState();
}

class _SellCarPageState extends State<SellCarPage> {
  // Example dropdown lists. In a real app, these could be fetched from APIs.
  final List<String> carBrands = ['Toyota', 'Honda', 'Suzuki', 'Ford', 'BMW'];
  final List<String> carModels = ['Model A', 'Model B', 'Model C'];
  final List<String> carYears = List.generate(25, (i) => (2000 + i).toString());
  final List<String> carVariants = ['Base', 'Sport', 'Luxury'];
  final List<String> carEngines = ['Petrol', 'Diesel', 'Hybrid', 'Electric'];
  final List<String> carTransmissions = ['Manual', 'Automatic', 'CVT', 'DCT'];

  String? selectedBrand;
  String? selectedModel;
  String? selectedYear;
  String? selectedVariant;
  String? selectedEngine;
  String? selectedTransmission;

  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _mileageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

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
          "Sell Car",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        children: [
          Text(
            "Enter Your Details & Get Your Car’s Price Instantly",
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.88),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _sectionLabel("Car Brand"),
          _customDropdown<String>(
            hint: "Select Car Brand",
            value: selectedBrand,
            items: carBrands,
            onChanged: (v) => setState(() => selectedBrand = v),
          ),
          _sectionLabel("Car Model"),
          _customDropdown<String>(
            hint: "Select Car Model",
            value: selectedModel,
            items: carModels,
            onChanged: (v) => setState(() => selectedModel = v),
          ),
          _sectionLabel("Car Year"),
          _customDropdown<String>(
            hint: "Select Car Year",
            value: selectedYear,
            items: carYears,
            onChanged: (v) => setState(() => selectedYear = v),
          ),
          _sectionLabel("Car Variant"),
          _customDropdown<String>(
            hint: "Select Car Variant",
            value: selectedVariant,
            items: carVariants,
            onChanged: (v) => setState(() => selectedVariant = v),
          ),
          _sectionLabel("Engine"),
          _customDropdown<String>(
            hint: "Select Car Engine",
            value: selectedEngine,
            items: carEngines,
            onChanged: (v) => setState(() => selectedEngine = v),
          ),
          _sectionLabel("Transmission"),
          _customDropdown<String>(
            hint: "Select Car Transmission",
            value: selectedTransmission,
            items: carTransmissions,
            onChanged: (v) => setState(() => selectedTransmission = v),
          ),
          _sectionLabel("Mileage (km)"),
          _customTextField(
            controller: _mileageController,
            hint: "Enter car mileage",
            keyboardType: TextInputType.number,
            icon: Icons.speed,
          ),
          _sectionLabel("Contact Number"),
          _customTextField(
            controller: _contactController,
            hint: "Enter your contact number",
            keyboardType: TextInputType.phone,
            icon: Icons.phone,
          ),
          const SizedBox(height: 22),
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
                _calculatePrice();
                // ...validation code
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InspectionAppointmentPage(),
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
          const SizedBox(height: 18),
          // Optionally, add tips or a call-to-action for faster selling
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD69C39).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFFD69C39)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Tip: Adding accurate details helps you get the best estimated price for your car!",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _onGetPricePressed() {
    // Validate input and show a dialog/snackbar
    if (selectedBrand == null ||
        selectedModel == null ||
        selectedYear == null ||
        selectedVariant == null ||
        selectedEngine == null ||
        selectedTransmission == null ||
        _mileageController.text.isEmpty ||
        _contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all details to get your car’s price."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    // Simulate price calculation
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Estimated Car Price"),
        content: Text(
          "Congratulations!\nYour ${selectedBrand!} ${selectedModel!} ($selectedYear) is estimated at \$${_calculatePrice()}",
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  int _calculatePrice() {
    // Simple mock price calculation based on year and mileage
    final year = int.tryParse(selectedYear ?? '') ?? 2020;
    final mileage = int.tryParse(_mileageController.text) ?? 50000;
    int basePrice = 30000 - ((2025 - year) * 1000) - (mileage ~/ 20);
    if (basePrice < 2000) basePrice = 2000;
    return basePrice;
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 7, top: 18),
    child: Text(
      label,
      style: GoogleFonts.poppins(
        color: Colors.white60,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ),
  );

  Widget _customDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2C30),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<T>(
        isExpanded: true,
        dropdownColor: const Color(0xFF2D2C30),
        hint: Text(
          hint,
          style: GoogleFonts.poppins(color: Colors.white38, fontSize: 15),
        ),
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
        underline: const SizedBox(),
        items: items
            .map(
              (e) => DropdownMenuItem<T>(
                value: e,
                child: Text(
                  e.toString(),
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2C30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: icon != null
              ? Icon(icon, color: Color(0xFFD69C39))
              : null,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
