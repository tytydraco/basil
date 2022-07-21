import 'dart:io';

import 'package:args/args.dart';
import 'package:basil/basil.dart';
import 'package:basil/utils/log.dart';
import 'package:basil/utils/yaml_parser.dart';

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
      defaultsTo: 'pubspec.yaml',
    );

  try {
    final results = argParser.parse(args);
    final buildTypes = results.rest;
    final configFilePath = results['config'] as String;

    final yamlParser = YamlParser(yamlFilePath: configFilePath);

    final yamlMap = await yamlParser.getBasilYamlMap();
    final basil = Basil(yamlMap);

    if (buildTypes.isEmpty) {
      await basil.buildAll();
    } else {
      await basil.buildOnly(buildTypes);
    }
  } catch (e) {
    Log.error(e.toString());
    exit(1);
  }
}
