import 'package:flutter/material.dart';
import 'package:flutter_calculator/src/bindings/my_bindings.dart';
import 'package:flutter_calculator/src/controller/theme_controller.dart';
import 'package:flutter_calculator/src/screen/main_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class Calculator extends StatelessWidget {
  final double? initial;
  final CalculatorTheme? theme;
  final Function(double)? onClickDone;

  const Calculator({
    Key? key,
    this.initial,
    this.theme,
    this.onClickDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBindings(),
      title: "Flutter Calculator",
      home: MainScreen(
        initial: initial,
        theme: theme,
        onClickDone: onClickDone,
      ),
    );
  }
}
