import 'package:get/get.dart';

class Dimension {
  final double? topLeft, topRight, bottomRight, bottomLeft, radius;

  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

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

  double radiusFx(double rad) {
    return screenHeight / (screenHeight / rad);
  }
  //Radius
}
