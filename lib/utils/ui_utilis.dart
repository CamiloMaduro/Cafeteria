import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class ShowLogo extends StatefulWidget {
  final bool isActive; // Agrega un argumento para indicar si está activa

  const ShowLogo({Key? key, this.isActive = false}) : super(key: key);

  @override
  _ShowLogoState createState() => _ShowLogoState();
}

class _ShowLogoState extends State<ShowLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repite la animación

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _positionAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.1)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isActive
        ? SlideTransition(
            position: _positionAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/Tipyk.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/images/Tipyk.png',
              height: 250,
              fit: BoxFit.contain,
            ),
          );
  }
}
