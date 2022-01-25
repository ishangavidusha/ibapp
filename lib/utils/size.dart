
import 'package:flutter/material.dart';

double devWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double devHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget verticalSpace({double value = 8}) {
  return SizedBox(height: value,);
}

Widget horizontalSpace({double value = 8}) {
  return SizedBox(width: value,);
}