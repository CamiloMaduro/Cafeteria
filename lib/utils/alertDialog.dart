import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String iconPath;
  final Widget content;
  final VoidCallback onTap;
  final String Token;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.content,
    required this.onTap,
    required this.Token,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositivePressed,
    this.onNegativePressed,
  }) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Image.asset(widget.iconPath, width: 24, height: 24), // Icono
          SizedBox(width: 8),
          Text(widget.title),
        ],
      ),
      content: widget.content,
      actions: [
        if (widget.negativeButtonText != null)
          TextButton(
            onPressed: () {
              if (widget.onNegativePressed != null) widget.onNegativePressed!();
              Navigator.of(context).pop();
            },
            child: Text(widget.negativeButtonText!),
          ),
        TextButton(
          onPressed: () {
            widget.onTap();
            if (widget.onPositivePressed != null) widget.onPositivePressed!();
            Navigator.of(context).pop();
          },
          child: Text(widget.positiveButtonText ?? 'OK'),
        ),
      ],
    );
  }
}
