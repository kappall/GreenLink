import 'package:flutter/material.dart';

class UiCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;

  const UiCarousel({super.key, required this.items, this.height = 200});

  @override
  State<UiCarousel> createState() => _UiCarouselState();
}

class _UiCarouselState extends State<UiCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        padEnds: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: widget.items[index],
          );
        },
      ),
    );
  }
}