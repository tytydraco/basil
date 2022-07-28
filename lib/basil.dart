import 'dart:io';

import 'package:basil/utils/logging.dart';
import 'package:io/io.dart';
import 'package:yaml/yaml.dart';
import 'package:yamlcfg/yamlcfg.dart';

/// A linear build system using YAML configuration.
class Basil {
  /// Create a new [Basil] object given a [yamlCfg].
  Basil(
    this.yamlCfg, {
    this.echo = false,
    this.bailOnError = false,
    this.pipeStdio = true,
  });

  /// The type-safe configuration [YamlCfg] to use.
  final YamlCfg yamlCfg;

  /// Log all commands before executing them.
  final bool echo;

  /// End all execution if a non-zero exit code was returned.
  final bool bailOnError;

  /// Attach stdin, stdout, and stderr to each subprocess.
  final bool pipeStdio;

  /// The type-safe configuration [YamlCfg] of the basil field from the original
  /// config.
  ///
  /// Throws an [ArgumentError] if the `basil` field is missing from the root.
  late YamlCfg basilCfg = yamlCfg.into(
    'basil',
    () => throw ArgumentError('Missing basil field', 'yamlCfg'),
  );

  /// Run all build types in descending order from the configuration file.
  Future<void> buildAll() => buildOnly(basilCfg.yamlMap.keys);

  /// Run some particular build types from the configuration file.
  Future<void> buildOnly(Iterable<Object?> buildTypeKeys) async {
    for (final buildTypeKey in buildTypeKeys) {
      final buildTypeCfg = basilCfg.into(
        buildTypeKey,
        () => throw ArgumentError(
          'Build type does not exist',
          buildTypeKey.toString(),
        ),
      );

      log('Running steps for: $buildTypeKey');
      await _runBuildType(buildTypeCfg);
    }
  }

  /// Run commands for a specific [buildTypeCfg].
  Future<void> _runBuildType(YamlCfg buildTypeCfg) async {
    final cmds = buildTypeCfg.get<YamlList>('cmds').map((e) => e.toString());
    final enabled = buildTypeCfg.get<bool>('enabled', () => true);
    final parallel = buildTypeCfg.get<bool>('parallel', () => false);
    final platforms = buildTypeCfg.get<YamlList?>('platforms', () => null);
    final platformSupported =
        platforms?.contains(Platform.operatingSystem) ?? true;

    // Proceed if:
    // - Build type is enabled
    // - Executing on a supported platform
    if (enabled && platformSupported) {
      await _runCommands(cmds, parallel: parallel);
    }
  }

  /// Execute a shell [command] and log the output.
  Future<void> _runCommand(String command) async {
    // Echo command to output first.
    if (echo) echoCommand(command);

    final shellParts = shellSplit(command);
    final executable = shellParts[0];
    final arguments = shellParts.sublist(1);

    final process = await Process.start(
      executable,
      arguments,
      runInShell: true,
      mode: pipeStdio ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );

    final errorCode = await process.exitCode;

    // Bail if something went wrong.
    if (bailOnError && errorCode != 0) {
      throw OSError('Exit code is not zero, bailing', errorCode);
    }
  }

  /// Execute the [commands] sequentially or in [parallel] if specified.
  Future<void> _runCommands(
    Iterable<String> commands, {
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
