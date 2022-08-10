import 'dart:io';

import 'package:args/args.dart';
import 'package:basil/src/basil.dart';
import 'package:stdlog/stdlog.dart' as std;
import 'package:yamlcfg/yamlcfg.dart';

Future<void> main(List<String> args) async {
  final argParser = ArgParser();
  argParser
    ..addFlag(
      'help',
      help: 'Show the program usage.',
      abbr: 'h',
      negatable: false,
      callback: (value) {
        if (value) {
          stdout.writeln(argParser.usage);
          exit(0);
        }
      },
    )
    ..addOption(
      'config',
      help: 'The path to the configuration file to process.',
      abbr: 'c',
      defaultsTo: 'basil.yaml',
    )
    ..addFlag(
      'echo',
      help: 'Log all commands before executing them.',
      abbr: 'e',
    )
    ..addFlag(
      'bail',
      help: 'End all execution if a non-zero exit code was returned.',
      abbr: 'b',
      defaultsTo: true,
    )
    ..addFlag(
      'pipe-stdio',
      help: 'Attach stdin, stdout, and stderr to each subprocess.',
      abbr: 'p',
      defaultsTo: true,
    );

  try {
    final results = argParser.parse(args);
    final buildTypes = results.rest;

    final configFilePath = results['config'] as String;
    final echo = results['echo'] as bool;
    final bailOnError = results['bail'] as bool;
    final pipeStdio = results['pipe-stdio'] as bool;

    final yamlCfg = YamlCfg.fromFile(File(configFilePath));

    final basil = Basil(
      yamlCfg,
      echo: echo,
      bailOnError: bailOnError,
      pipeStdio: pipeStdio,
    );

    if (buildTypes.isEmpty) {
      await basil.buildAll();
    } else {
      await basil.buildOnly(buildTypes);
    }
  } catch (e) {
    std.error(e.toString());
    exit(1);
  }
}
