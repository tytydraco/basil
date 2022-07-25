import 'dart:io';

import 'package:basil/utils/logging.dart';
import 'package:io/io.dart';
import 'package:yaml/yaml.dart';

/// A linear build system using YAML configuration.
class Basil {
  /// Create a new [Basil] object given a [yamlMap].
  Basil(this.yamlMap);

  /// The configuration YAML to use.
  final YamlMap yamlMap;

  /// Run all build types in descending order from the YAML file.
  Future<void> buildAll() async {
    for (final buildType in yamlMap.keys) {
      await _runBuildType(yamlMap, buildType as String);
    }
  }

  /// Run some particular build types from the YAML file.
  Future<void> buildOnly(List<String> buildTypes) async {
    for (final buildType in buildTypes) {
      await _runBuildType(yamlMap, buildType);
    }
  }

  /// Run commands for a specific [buildType].
  Future<void> _runBuildType(YamlMap yamlMap, String buildType) async {
    final buildTypeMap = yamlMap[buildType] as YamlMap?;

    if (buildTypeMap == null) {
      throw ArgumentError('Build type does not exist', buildType);
    }

    final cmds = (buildTypeMap['cmds'] as YamlList)
        .map((cmd) => cmd.toString())
        .toList();
    final enabled = buildTypeMap['enabled'] as bool? ?? true;
    final parallel = buildTypeMap['parallel'] as bool? ?? false;
    final platforms = (buildTypeMap['platforms'] as YamlList?)
        ?.map((platform) => platform.toString())
        .toList();

    final onSupportedPlatform =
        platforms?.contains(Platform.operatingSystem) ?? true;

    // Proceed if:
    // - Build type is enabled
    // - Executing on a supported platform
    if (enabled && onSupportedPlatform) {
      log('Running steps for build type: $buildType');
      await _runCommands(cmds, parallel: parallel);
    }
  }

  /// Execute a shell [command] and log the output.
  Future<void> _runCommand(String command) async {
    final shellParts = shellSplit(command);
    final executable = shellParts[0];
    final arguments = shellParts.sublist(1);

    final process = await Process.run(
      executable,
      arguments,
      runInShell: true,
    );

    final trimmedStdout = (process.stdout as String).trim();
    final trimmedStderr = (process.stderr as String).trim();

    if (trimmedStdout.isNotEmpty) logStdout(trimmedStdout);
    if (trimmedStderr.isNotEmpty) logStderr(trimmedStderr);
  }

  /// Execute the [commands] sequentially or in [parallel] if specified.
  Future<void> _runCommands(
    List<String> commands, {
    bool parallel = false,
  }) async {
    if (parallel) {
      await Future.wait(commands.map(_runCommand));
    } else {
      for (final command in commands) {
        await _runCommand(command);
      }
    }
  }
}
