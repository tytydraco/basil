import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

class Log {
  static final _penRed = AnsiPen()..red(bold: true);
  static final _penYellow = AnsiPen()..yellow(bold: true);
  static final _penGreen = AnsiPen()..green(bold: true);
  static final _penBlack = AnsiPen()..black(bold: true);

  static void debug(String message) =>
      stdout.writeln('DBG ${_penBlack(message)}');

  static void log(String message) =>
      stdout.writeln('LOG ${_penGreen(message)}');

  static void warn(String message) =>
      stdout.writeln('WRN ${_penYellow(message)}');

  static void error(String message) =>
      stdout.writeln('ERR ${_penRed(message)}');
}
