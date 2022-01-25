// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:ibapp/utils/keys.dart';


class AppSnackBar {

  static void info(String msg) {
    AdvanceSnackBar(
      message: msg,
      type: AdvanceSnackBarType.INFO,
      bgColor: const Color(0xFF6678FF),
      textColor: const Color(0xFF171C26),
    ).show();
  }
  
  static void warning(String msg) {
    AdvanceSnackBar(
      message: msg,
      type: AdvanceSnackBarType.WARNING,
      bgColor: const Color(0xFFFF8800),
      textColor: const Color(0xFF171C26),
    ).show();
  }
  
  static void error(String msg) {
    AdvanceSnackBar(
      message: msg,
      type: AdvanceSnackBarType.ERROR,
      bgColor: const Color(0xFFFF5555),
      textColor: const Color(0xFF171C26),
    ).show();
  }
  
  static void success(String msg) {
    AdvanceSnackBar(
      message: msg,
      type: AdvanceSnackBarType.SUCCESS,
      bgColor: const Color(0xFF00C569),
      textColor: const Color(0xFF171C26),
    ).show();
  }
}

enum AdvanceSnackBarType {
  SUCCESS,
  INFO,
  WARNING,
  ERROR,
}

enum AdvanceSnackBarMode {
  BASIC,
  ADVANCE,
  MODERN
}

class AdvanceSnackBar {
  final String message;
  final Duration duration;
  final AdvanceSnackBarType type;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;

  const AdvanceSnackBar({
    this.message = "",
    this.bgColor = const Color(0xFF323232),
    this.textColor = const Color(0xFFffffff),
    this.iconColor = const Color(0xFFffffff),
    this.duration = const Duration(seconds: 3),
    this.type = AdvanceSnackBarType.SUCCESS,
  });

  show() {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        padding: const EdgeInsets.all(0),
        duration: duration,
        backgroundColor: Colors.transparent,
        content: __body(),
        elevation: 0,
      ),
    ).closed.then((value) => scaffoldMessengerKey.currentState?.clearSnackBars());
  }

  Widget __body() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(5),
          constraints: const BoxConstraints(
            minHeight: 20,
            maxHeight: 40,
          ),
          decoration: BoxDecoration(
            color: bgColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: __icon(),
                        ),
                        Flexible(
                          child: Text(
                            message,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                      },
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 18,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget __icon() {
    IconData iconData = Icons.warning;
    switch (type) {
      case AdvanceSnackBarType.WARNING:
        iconData = Icons.warning;
        break;
      case AdvanceSnackBarType.INFO:
        iconData = Icons.info;
        break;
      case AdvanceSnackBarType.ERROR:
        iconData = Icons.error;
        break;
      case AdvanceSnackBarType.SUCCESS:
        iconData = Icons.donut_large_rounded;
        break;
      default:
        break;
    }
    return Icon(
      iconData,
      size: 18,
      color: textColor,
    );
  }
}
