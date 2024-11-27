// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class FanMenuItem {
  final IconData icon;
  final VoidCallback action;

  FanMenuItem({required this.icon, required this.action});
}

class StyledFanFAB extends StatefulWidget {
  final List<FanMenuItem> items;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const StyledFanFAB({
    required this.items,
    super.key,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.icon = Icons.add,
  });

  @override
  State<StyledFanFAB> createState() => _StyledFanFABState();
}

class _StyledFanFABState extends State<StyledFanFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isModalOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust duration as needed
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _openFanModal() async {
    if (_isModalOpen) return; // Prevent multiple opens
    setState(() {
      _isModalOpen = true;
    });

    await _animationController.forward();

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.1),
      builder: (context) {
        return FanModal(
          backgroundColor: widget.backgroundColor,
          items: widget.items,
          onClose: _closeModal,
        );
      },
    );

    setState(() {
      _isModalOpen = false;
    });
  }

  Future<void> _closeModal() async {
    if (!mounted) return;
    Navigator.of(context).pop();
    await _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurStyle: BlurStyle.outer,
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: widget.backgroundColor.withOpacity(0.4),
            blurStyle: BlurStyle.outer,
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: FloatingActionButton(
        highlightElevation: 20,
        hoverElevation: 10,
        elevation: 5,
        backgroundColor: widget.backgroundColor,
        shape: const CircleBorder(),
        onPressed: _openFanModal,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * math.pi,
              child: child,
            );
          },
          child: Icon(
            widget.icon,
            color: widget.iconColor,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class FanModal extends StatefulWidget {
  final List<FanMenuItem> items;
  final VoidCallback onClose;
  final Color backgroundColor;

  const FanModal({
    required this.items,
    required this.onClose,
    required this.backgroundColor,
    super.key,
  });

  @override
  State<FanModal> createState() => _FanModalState();
}

class _FanModalState extends State<FanModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _overlayAnimation;

  _FanModalState();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjusted duration
    );

    // Overlay animation from 0 (transparent) to 1 (opaque)
    _overlayAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth in and out
      ),
    );

    // Button animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((value) {
      widget.onClose(); // Call the onClose callback
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Semi-transparent overlay
          FadeTransition(
            opacity: _overlayAnimation,
            child: GestureDetector(
              onTap: _close,
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),

          // Fan-like buttons at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: SizedBox(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: List.generate(widget.items.length, (index) {
                    return _buildFanButton(widget.items[index], index);
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFanButton(FanMenuItem item, int index) {
    final itemCount = widget.items.length;
    const fanAngle = 230; // Total spread angle
    final startAngle = itemCount == 1
        ? fanAngle / 2.5
        : -25; // Leftmost maximum angle position

    final angleStep = itemCount == 1 ? 230.w : fanAngle / (itemCount - 1);

    final angle = startAngle + index * angleStep;

    final rad = angle * (math.pi / 180); // Convert to radians
    final distance = itemCount == 1 ? 40.w : 80.w; // Adjust distance as needed

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = _animation.value;
        final dx = progress * distance * math.cos(rad);
        final dy = progress * distance * math.sin(rad);

        return Positioned(
          bottom: 80 + dy, // Adjust to align the fan vertically
          left: MediaQuery.of(context).size.width / 2 - 28 + dx,
          child: Transform.scale(
            scale: progress,
            child: GestureDetector(
              onTap: () {
                item.action();
                _close();
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    width: 3.r,
                    color: context.appColors.secondaryColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: widget.backgroundColor.withOpacity(0.4),
                      blurStyle: BlurStyle.inner,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  color: context.appColors.primaryColor,
                ),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.r,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/* 
floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FanFAB(
        backgroundColor: context.appColors.primaryColor,
        items: [
          FanMenuItem(
            icon: Icons.account_circle_outlined,
            action: _messageAction,
          ),
          FanMenuItem(icon: Icons.access_time, action: _callAction),
          FanMenuItem(
            icon: Icons.add_home_outlined,
            action: _emailAction,
          ),
          // Add more items if needed
        ],
      ), */
