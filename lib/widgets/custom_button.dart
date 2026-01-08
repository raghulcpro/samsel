
import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Remove default padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Ink( // InkWell provides ripple effect
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          gradient: const LinearGradient(
            colors: [
              AppConstants.accentColorLight,
              AppConstants.accentColorDark,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minWidth: 88.0, // Minimum width for a button
            minHeight: 48.0, // Minimum height for a button
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
