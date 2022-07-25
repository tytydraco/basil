import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

final _penRed = AnsiPen()..red(bold: true);
final _penGreen = AnsiPen()..green(bold: true);
final _penBlueBg = AnsiPen()..blue(bg: true);
final _penYellowBg = AnsiPen()..yellow(bg: true);

/// Output a [message] as a regular log.
void log(String message) => stdout.writeln('LOG ${_penGreen(message)}');

/// Output a [message] as an error.
void error(String message) => stdout.writeln('ERR ${_penRed(message)}');

/// Output a [message] as a shell stdout.
void logStdout(String message) => stdout.writeln(_penBlueBg(message));

/// Output a [message] as a shell stderr.
void logStderr(String message) => stdout.writeln(_penYellowBg(message));
