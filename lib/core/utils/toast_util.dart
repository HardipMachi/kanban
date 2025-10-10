import 'package:flutter/material.dart';
import '../../app/app_constants/app_colors.dart';
import '../../app/app_constants/app_textStyles.dart';

void showToast(BuildContext context, String message, {bool isSuccess = true}) {
  final color = isSuccess ? AppColors.success.shade600 : AppColors.error.shade600;
  final icon = isSuccess ? Icons.check_circle : Icons.error;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      content: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: AppTextStyles.toastText)),
          ],
        ),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
