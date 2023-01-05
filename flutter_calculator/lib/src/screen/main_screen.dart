import 'package:flutter/material.dart';
import 'package:flutter_calculator/src/model/calculator_theme.dart';
import 'package:get/get.dart';

import '../controller/calculate_controller.dart';

///
import '../controller/theme_controller.dart';
import '../utils/colors.dart';
import '../widget/button.dart';

class MainScreen extends StatefulWidget {
  final double? initial;
  final CalculatorTheme? theme;
  final Function(double)? onClickDone;

  const MainScreen({
    Key? key,
    this.initial,
    this.theme,
    this.onClickDone,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isInitialAdded = false;
  late final controller = Get.find<CalculateController>();
  late final themeController = Get.find<ThemeController>();

  final List<String> buttons = [
    "C",
    "DEL",
    "%",
    "/",
    "9",
    "8",
    "7",
    "x",
    "6",
    "5",
    "4",
    "-",
    "3",
    "2",
    "1",
    "+",
    "0",
    ".",
    "Done",
    "=",
  ];

  @override
  void dispose() {
    controller.clearInputAndOutput();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initial != null && !isInitialAdded) {
      controller.resetInput(widget.initial!);
      isInitialAdded = true;
    }

    return GetBuilder<ThemeController>(
      builder: (context) {
        final isDarkTheme = widget.theme == null
            ? themeController.isDark
            : widget.theme == CalculatorTheme.dark;
        return Scaffold(
          backgroundColor: isDarkTheme
              ? DarkColors.scaffoldBgColor
              : LightColors.scaffoldBgColor,
          body: Column(
            children: [
              GetBuilder<CalculateController>(
                builder: (context) {
                  return outPutSection(
                    isDarkTheme,
                    widget.theme == null,
                    controller,
                    (theme) {
                      themeController.onThemeChange(theme);
                    },
                  );
                },
              ),
              inPutSection(isDarkTheme, controller),
            ],
          ),
        );
      },
    );
  }

  /// In put Section - Enter Numbers
  Expanded inPutSection(bool isDarkTheme, CalculateController controller) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color:
              isDarkTheme ? DarkColors.sheetBgColor : LightColors.sheetBgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemBuilder: (contex, index) {
            switch (index) {

              /// CLEAR BTN
              case 0:
                return CustomButton(
                    buttonTapped: () => controller.clearInputAndOutput(),
                    color: isDarkTheme
                        ? DarkColors.btnBgColor
                        : LightColors.btnBgColor,
                    textColor: isDarkTheme
                        ? DarkColors.leftOperatorColor
                        : LightColors.leftOperatorColor,
                    text: buttons[index]);

              /// DELETE BTN
              case 1:
                return CustomButton(
                    buttonTapped: () => controller.deleteBtnAction(),
                    color: isDarkTheme
                        ? DarkColors.btnBgColor
                        : LightColors.btnBgColor,
                    textColor: isDarkTheme
                        ? DarkColors.leftOperatorColor
                        : LightColors.leftOperatorColor,
                    text: buttons[index]);

              /// EQUAL BTN
              case 18:
              case 19:
                return CustomButton(
                    buttonTapped: () {
                      controller.equalPressed();
                      if (index == 18) {
                        String output = controller.userOutput;
                        if (double.tryParse(output) != null) {
                          widget.onClickDone?.call(double.parse(output));
                          controller.clearInputAndOutput();
                        }
                      }
                    },
                    color: isDarkTheme
                        ? DarkColors.btnBgColor
                        : LightColors.btnBgColor,
                    textColor: isDarkTheme
                        ? DarkColors.leftOperatorColor
                        : LightColors.leftOperatorColor,
                    text: buttons[index]);

              default:
                return CustomButton(
                    buttonTapped: () => controller.onBtnTapped(buttons, index),
                    color: isDarkTheme
                        ? DarkColors.btnBgColor
                        : LightColors.btnBgColor,
                    textColor: isOperator(buttons[index])
                        ? LightColors.operatorColor
                        : isDarkTheme
                            ? Colors.white
                            : Colors.black,
                    text: buttons[index]);
            }
          },
        ),
      ),
    );
  }

  /// Out put Section - Show Result
  Expanded outPutSection(
    bool isDarkTheme,
    bool allowThemeChange,
    CalculateController controller,
    Function(CalculatorTheme) onThemeChange,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (allowThemeChange)
            Container(
              alignment: Alignment.topCenter,
              width: 100,
              height: 45,
              decoration: BoxDecoration(
                  color: isDarkTheme
                      ? DarkColors.sheetBgColor
                      : LightColors.sheetBgColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => onThemeChange(CalculatorTheme.light),
                      child: Icon(
                        Icons.light_mode_outlined,
                        color: isDarkTheme ? Colors.grey : Colors.black,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => onThemeChange(CalculatorTheme.dark),
                      child: Icon(
                        Icons.dark_mode_outlined,
                        color: isDarkTheme ? Colors.white : Colors.grey,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 70),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    controller.userInput,
                    style: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    controller.userOutput,
                    style: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  bool isOperator(String y) {
    if (y == "%" || y == "/" || y == "x" || y == "-" || y == "+" || y == "=") {
      return true;
    }
    return false;
  }
}
