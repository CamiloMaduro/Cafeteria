import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<DropdownMenuItem<String>> especies;
  final String? selectedEspecie;
  final void Function(String?) onChanged;
  final String hintText;

  const CustomDropdown({
    Key? key,
    required this.especies,
    required this.selectedEspecie,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:
              selectedEspecie, // No usaremos null checks aquí, solo usaremos el valor directamente
          onChanged: onChanged,
          items: especies.isNotEmpty
              ? especies
              : [
                  DropdownMenuItem(
                    value: '',
                    child: Text(
                      'No items available',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.red),
                    ),
                  ),
                ], // Maneja el caso cuando `especies` está vacío
          hint: Text(
            hintText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          dropdownColor: Theme.of(context).colorScheme.background,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
