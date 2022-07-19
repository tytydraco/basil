import 'dart:io';

import 'package:logging/logging.dart';
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

class Basil {
  final YamlMap yamlMap;

  Basil(this.yamlMap);

  final _log = Logger((Basil).toString());

  /// Run all build types in descending order from the YAML file.
  Future<void> buildAll() async {
    for (String buildType in yamlMap.keys) {
      await _runBuildType(yamlMap, buildType);
    }
  }

  /// Run some particular [buildType]s from the YAML file.
  Future<void> buildOnly(List<String> buildTypes) async {
    for (String buildType in buildTypes) {
      await _runBuildType(yamlMap, buildType);
    }
  }

  /// Run commands for a specific [buildType].
  Future<void> _runBuildType(YamlMap yamlMap, String buildType) async {
    final buildTypeMap = yamlMap[buildType];

    if (buildTypeMap == null) {
      throw ArgumentError('Build type does not exist', buildType);
    }

    final cmds = (buildTypeMap['cmds'] as YamlList)
        .map((cmd) => cmd.toString())
        .toList();
    final enabled = buildTypeMap['enabled'] ?? true;
    final parallel = buildTypeMap['parallel'] ?? false;
    final platforms = (buildTypeMap['platforms'] as YamlList?)
        ?.map((platform) => platform.toString())
        .toList();

    final onSupportedPlatform =
        platforms?.contains(Platform.operatingSystem) ?? true;

    // Proceed if:
    // - Build type is enabled
    // - Executing on a supported platform
    if (enabled && onSupportedPlatform) {
      _log.info('Running steps for build type: $buildType');
      await _runCommands(cmds, parallel: parallel);
    }
  }

  /// Execute the [commands] sequentially or in [parallel] if specified.
  ///
  /// New [Shell] instances will be created for each command if [parallel] mode
  /// is enabled.
  Future<void> _runCommands(List<String> commands,
      {bool parallel = false}) async {
    if (parallel) {
      _log.finest('Executing in parallel');
      await Future.wait(commands.map((command) => Shell().run(command)));
    } else {
      _log.finest('Executing in sequence');
      final shell = Shell();
      for (String command in commands) {
        await shell.run(command);
      }
    }
  }
}
