import 'package:get/get.dart';

class Dimension {
  final double? topLeft, topRight, bottomRight, bottomLeft, radius;

  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;
  static double buttonWidth = screenWidth - 20;

  Dimension(
      {this.topLeft,
      this.topRight,
      this.bottomRight,
      this.bottomLeft,
      this.radius});

  snackbarPosition(double fraction, String position) {
    if (position == "Height") {
      return screenHeight / (screenHeight / fraction);
    } else if (position == "Width") {
      return screenWidth / (screenWidth / fraction);
    }
  }

  static double radiusFx(double rad) {
    return screenHeight / (screenHeight / rad);
  }
  static double fontSize(double fraction)  {
    return screenHeight / (screenHeight / fraction);
  }
  //Radius
}
