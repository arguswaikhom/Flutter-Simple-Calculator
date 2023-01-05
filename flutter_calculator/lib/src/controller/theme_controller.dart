import 'package:flutter_calculator/src/model/calculator_theme.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  CalculatorTheme theme = CalculatorTheme.dark;

  bool get isDark => theme == CalculatorTheme.dark;

  onThemeChange(CalculatorTheme theme) {
    this.theme = theme;
    update();
  }
}
