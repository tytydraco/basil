import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

class Output {
  /// Current log [Level] for the logger.
  static const logLevel = Level.INFO;

  static final _penSevere = AnsiPen()..red(bg: true, bold: true);
  static final _penWarning = AnsiPen()..yellow(bg: true, bold: true);
  static final _penInfo = AnsiPen()..green(bg: true, bold: true);
  static final _penElse = AnsiPen()..black(bg: true, bold: true);

  /// Log colored text to the console depending on the [level].
  static void log(Level level, String message) {
    if (level == Level.SEVERE) {
      stdout.writeln(_penSevere(message));
    } else if (level == Level.WARNING) {
      stdout.writeln(_penWarning(message));
    } else if (level == Level.INFO) {
      stdout.writeln(_penInfo(message));
    } else {
      stdout.writeln(_penElse(message));
    }
  }

  /// Listen for new log records and print them to the console.
  static void setupLogging() {
    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((event) {
      final message = '[${event.level.name}] ${event.message}';
      Output.log(event.level, message);
    });
  }
}
