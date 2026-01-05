import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FloatingNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _barController;
  late Animation<double> _barAnimation;
  double _tiltAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Animation curve: goes from 0 to 1
    _barAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _barController, curve: Curves.easeOutBack),
    );

    _barController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _barController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  void _triggerBarTilt(int index) {
    // Determine tilt angle based on index (left or right)
    // Left items (0, 1) tilt left (negative)
    // Right items (2, 3) tilt right (positive)
    // Outer items (0, 3) have stronger tilt than inner items (1, 2)
    double target = 0.0;
    if (index == 0) {
      target = -0.05; // Strong left tilt
    } else if (index == 1)
      target = -0.025; // Slight left tilt
    else if (index == 2)
      target = 0.025; // Slight right tilt
    else if (index == 3)
      target = 0.05; // Strong right tilt

    setState(() {
      _tiltAngle = target;
    });

    _barController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: AnimatedBuilder(
        animation: _barAnimation,
        builder: (context, child) {
          // Apply rotation: current value * target angle
          return Transform.rotate(
            angle: _tiltAngle * _barAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 70, // Height of the floating pill
          decoration: BoxDecoration(
            color: const Color(0xff0D0D0D), // Dark background as requested
            borderRadius: BorderRadius.circular(35), // Pill shape
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarItem(
                icon: Icons.home_outlined,
                isSelected: widget.currentIndex == 0,
                onTap: () {
                  _triggerBarTilt(0);
                  widget.onTap(0);
                },
              ),
              _NavBarItem(
                icon: Icons.dashboard_outlined,
                isSelected: widget.currentIndex == 1,
                onTap: () {
                  _triggerBarTilt(1);
                  widget.onTap(1);
                },
              ),
              _NavBarItem(
                icon: Icons.search,
                isSelected: widget.currentIndex == 2,
                onTap: () {
                  _triggerBarTilt(2);
                  widget.onTap(2);
                },
              ),
              _NavBarItem(
                icon: Icons.person_outlined,
                isSelected: widget.currentIndex == 3,
                onTap: () {
                  _triggerBarTilt(3);
                  widget.onTap(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    // Tilt animation: Rotate lightly (-0.2 radians to 0.2 radians)
    _animation = Tween<double>(
      begin: 0,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Trigger heavy impact haptic feedback
    HapticFeedback.heavyImpact();

    // Start individual icon tilting animation
    _controller.forward();

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Individual icon ping-pong tilt
          return Transform.rotate(
            angle:
                _controller.isAnimating
                    ? (_controller.value > 0.5
                        ? 0.2 - (_controller.value - 0.5) * 0.4
                        : _controller.value * 0.4)
                    : 0,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            widget.icon,
            size: 28,
            color: widget.isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
