import 'package:control_ganadero/utils/text_styles.dart';
import 'package:flutter/material.dart';

class DevicesBox extends StatelessWidget {
  final String name;
  final String iconPath;
  final VoidCallback onTap;

  const DevicesBox({
    super.key,
    required this.name,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Usa AspectRatio para mantener la proporción 3:2 (ancho:alto)
            return AspectRatio(
              aspectRatio: 3 / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Image.asset(
                        iconPath,
                        fit: BoxFit
                            .contain, // Asegúrate de que la imagen se ajuste
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextStyles.bodyLarge(context, name),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
