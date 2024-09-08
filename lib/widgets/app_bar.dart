import 'package:control_ganadero/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onLogout;
  final bool showLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final String? route;
  final Map<String, dynamic>? arguments;

  CustomAppBar({
    required this.title,
    this.actions,
    this.onLogout,
    this.showLeading = false,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.route,
    this.arguments,
  }) : assert(!showLeading || (showLeading && route != null),
            'route must be provided if showLeading is true');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: TextStyles.headlineMedium(context, title), // Aplica el estilo aquí
      centerTitle: centerTitle,
      leading: showLeading
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (route != null) {
                  Navigator.of(context).popAndPushNamed(
                    route!,
                    arguments: arguments,
                  );
                }
              },
            )
          : null,
      actions: [
        if (onLogout != null)
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: onLogout,
          ),
        if (actions != null) ...actions!,
      ],
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
