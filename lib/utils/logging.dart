import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

final _penRed = AnsiPen()..red(bold: true);
final _penGreen = AnsiPen()..green(bold: true);
final _penYellow = AnsiPen()..yellow(bold: true);

/// Output a [message] as a regular log.
void log(String message) => stdout.writeln('LOG ${_penGreen(message)}');

/// Output a [message] as an error.
void error(String message) => stdout.writeln('ERR ${_penRed(message)}');

/// Output a [message] as an echoed command.
void echoCommand(String message) =>
    stdout.writeln('ECH ${_penYellow(message)}');
