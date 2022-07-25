import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

final _penRed = AnsiPen()..red(bold: true);
final _penYellow = AnsiPen()..yellow(bold: true);
final _penGreen = AnsiPen()..green(bold: true);
final _penBlack = AnsiPen()..black(bold: true);

/// Output a [message] as a debug log.
void debug(String message) => stdout.writeln('DBG ${_penBlack(message)}');

/// Output a [message] as a regular log.
void log(String message) => stdout.writeln('LOG ${_penGreen(message)}');

/// Output a [message] as a warning.
void warn(String message) => stdout.writeln('WRN ${_penYellow(message)}');

/// Output a [message] as an error.
void error(String message) => stdout.writeln('ERR ${_penRed(message)}');
