import 'package:basil/utils/output.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  test('Logging', () {
    Output.setupLogging();
    Output.log(Level.SEVERE, 'Severe message');
    Output.log(Level.WARNING, 'Warning message');
    Output.log(Level.INFO, 'Info message');
    Output.log(Level.SHOUT, 'Shout message');
  });
}