import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppButtonStyles {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );

  static ButtonStyle danger = ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );
}
