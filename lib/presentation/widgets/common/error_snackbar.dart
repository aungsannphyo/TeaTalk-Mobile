import 'package:flutter/material.dart';
import '../../../style/theme/color.dart'; // Adjust path if needed

class SnackbarUtil {
  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      backgroundColor: AppColors.dangerSoft,
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.dangerDark,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.dangerDark,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccess(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      backgroundColor: AppColors.successSoft,
      content: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.successDark,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.successDark,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
