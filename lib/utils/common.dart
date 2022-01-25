import 'dart:math';

import 'package:flutter/material.dart';

TimeOfDay toTimeOfDay(String value) {
  try {
    final time = value.split(":");
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  } catch (e) {
    return const TimeOfDay(hour: 8, minute: 00);
  }
}

String fromTimeOfDay(TimeOfDay value) {
  return "${value.hour}:${value.minute}:00";
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  String hour = (timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour).toStringAsFixed(0);
  String minute = timeOfDay.minute.toStringAsFixed(0);
  minute = minute.length == 1 ? "0$minute" : minute;
  String ampm = timeOfDay.hour > 12 ? "PM" : "AM";
  return "$hour:$minute $ampm";
}

extension DuToDouble on Duration {
  double toDouble() {
    return (inMinutes / 60).truncateToDecimalPlaces(2);
  }
}

extension DoToDuration on double {
  Duration toDuration() {
     return Duration(minutes: (this * 60).toInt());
  }
}

extension TruncateDoubles on double {
   double truncateToDecimalPlaces(int fractionalDigits) => (this * pow(10, 
     fractionalDigits)).truncate() / pow(10, fractionalDigits);
}