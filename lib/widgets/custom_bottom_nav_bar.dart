import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CustomBottomNavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _selectedIndex = widget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.directions_car, 'label': 'Browse cars'},
      {'icon': Icons.sell, 'label': 'Sell Car'},
      {'icon': Icons.mail_outline, 'label': 'Inbox'},
      {'icon': Icons.person, 'label': 'Account'},
    ];

    final double pillWidth = MediaQuery.of(context).size.width - 20;
    final double itemWidth = pillWidth / tabs.length;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
        child: SizedBox(
          height: 88, // 64 for nav bar + 24 for highlight circle
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Pill-shaped background
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2C30),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(tabs.length, (i) {
                      final isActive = i == _selectedIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = i;
                          });
                          if (widget.onTap != null) {
                            widget.onTap!(i);
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: isActive ? 24 : 0),
                              Icon(
                                tabs[i]['icon'] as IconData,
                                size: 28,
                                color: isActive
                                    ? const Color(0xFFD69C39)
                                    : Colors.white,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                tabs[i]['label'] as String,
                                style: GoogleFonts.poppins(
                                  color: isActive
                                      ? const Color(0xFFD69C39)
                                      : Colors.white,
                                  fontSize: 12,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // White circle highlight for the active tab
              Positioned(
                left: _selectedIndex * itemWidth + (itemWidth / 2) - 28,
                bottom: 40, // 64 - 24
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      tabs[_selectedIndex]['icon'] as IconData,
                      size: 32,
                      color: const Color(0xFFD69C39),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
