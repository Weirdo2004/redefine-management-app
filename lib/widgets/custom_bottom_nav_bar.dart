import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int? _pressedIndex;

  void _handleTap(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _pressedIndex = index;
    });
    widget.onTap(index);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _pressedIndex = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate tilt direction based on pressed index
    double getTiltAngle() {
      if (_pressedIndex == null) return 0.0;
      // Left side (0, 1) tilts left (negative), right side (2, 3) tilts right (positive)
      if (_pressedIndex == 0) return -0.015;
      if (_pressedIndex == 1) return -0.008;
      if (_pressedIndex == 2) return 0.008;
      if (_pressedIndex == 3) return 0.015;
      return 0.0;
    }

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform:
            Matrix4.identity()..rotateZ(getTiltAngle()), // Tilt entire nav bar
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Sliding indicator background
            AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: _getAlignment(widget.currentIndex),
              child: FractionallySizedBox(
                widthFactor: 0.25, // 1/4 of the width since we have 4 items
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C9F6E).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Nav items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded),
                _buildNavItem(1, Icons.bar_chart_outlined),
                _buildNavItem(2, Icons.wallet_outlined),
                _buildNavItem(3, Icons.person_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Alignment _getAlignment(int index) {
    switch (index) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return const Alignment(-0.33, 0);
      case 2:
        return const Alignment(0.33, 0);
      case 3:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.transparent, // Ensure tap area is clear
        child: TweenAnimationBuilder<Color?>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          tween: ColorTween(
            begin: isSelected ? const Color(0xFF2C9F6E) : Colors.grey.shade600,
            end: isSelected ? const Color(0xFF2C9F6E) : Colors.grey.shade600,
          ),
          builder: (context, color, child) {
            return Icon(icon, color: color, size: 22);
          },
        ),
      ),
    );
  }
}
