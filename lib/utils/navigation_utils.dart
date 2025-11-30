import 'package:flutter/material.dart';

class NavigationUtils {
  static Route<T> createSlideRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Route<T> createFadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Route<T> createScaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var scaleTween = Tween<double>(begin: 0.0, end: 1.0);
        var opacityTween = Tween<double>(begin: 0.0, end: 1.0);

        var scaleAnimation = animation.drive(scaleTween);
        var opacityAnimation = animation.drive(opacityTween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: opacityAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
