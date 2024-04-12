import 'package:flutter/material.dart';
import 'package:orange_card/ui/auth/constants.dart';

class AnimatedGradientBorder extends StatefulWidget {
  final String imageUrl;
  final double radius;

  const AnimatedGradientBorder(
      {super.key, required this.imageUrl, required this.radius});

  @override
  _AnimatedGradientBorderState createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _colorTween = ColorTween(begin: Colors.yellow, end: Colors.green)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 4,
              color: _colorTween.value!,
            ),
          ),
          child: CircleAvatar(
            radius: widget.radius,
            backgroundImage: NetworkImage(widget.imageUrl),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
