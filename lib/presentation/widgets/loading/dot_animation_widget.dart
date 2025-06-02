import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DotAnimationWidget extends HookWidget {
  const DotAnimationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    final animation = useMemoized(
      () => Tween<double>(begin: 0, end: 2.999).animate(controller),
      [controller],
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        int activeIndex = animation.value.floor().clamp(0, 2);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: index == activeIndex ? Colors.black : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
