import 'dart:async';

import 'package:flutter/material.dart';

class PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color? color;

  const PulsingIcon({super.key, required this.icon, this.color});

  @override
  State<PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startAnimationLoop();
  }

  void _startAnimationLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      _controller.repeat(reverse: true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      _controller.stop();
      await _controller.animateTo(
        0.5,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Icon(widget.icon, color: widget.color),
    );
  }
}
