import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

/// Log messages in colors corresponding to their urgency.
class Log {
  static final _penRed = AnsiPen()..red(bold: true);
  static final _penYellow = AnsiPen()..yellow(bold: true);
  static final _penGreen = AnsiPen()..green(bold: true);
  static final _penBlack = AnsiPen()..black(bold: true);

  /// Output a [message] as a debug log.
  static void debug(String message) =>
      stdout.writeln('DBG ${_penBlack(message)}');

  /// Output a [message] as a regular log.
  static void log(String message) =>
      stdout.writeln('LOG ${_penGreen(message)}');

  /// Output a [message] as a warning.
  static void warn(String message) =>
      stdout.writeln('WRN ${_penYellow(message)}');

  /// Output a [message] as an error.
  static void error(String message) =>
      stdout.writeln('ERR ${_penRed(message)}');
}
