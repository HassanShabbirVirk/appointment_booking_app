import 'package:appointment_booking_1/providers/theme_change_provider.dart';
import 'package:appointment_booking_1/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeChangerButton extends StatelessWidget {
  const ThemeChangerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return IconButton(
        onPressed: () {
          if (themeChanger.themeMode == ThemeMode.light) {
            themeChanger.setTheme(ThemeMode.dark);
          } else {
            themeChanger.setTheme(ThemeMode.light);
          }
        },
        icon: (themeChanger.themeMode == ThemeMode.light)
            ? const Icon(
                Icons.dark_mode,
                color: AppColors.whiteTextColor,
              )
            : const Icon(
                Icons.light_mode,
                color: AppColors.whiteTextColor,
              ));
  }
}
