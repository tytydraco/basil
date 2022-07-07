import 'dart:io';

import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

/// A class to handle the parsing and checking of `pubspec.yaml`.
class YamlParser {
  /// Location of the project main pubspec.yaml file.
  static final pubspecYamlFile = File('pubspec.yaml');

  final _log = Logger((YamlParser).toString());

  /// Exit if [pubspecYamlFile] is missing.
  Future<void> _assertPubspecExists() async {
    _log.finer('Checking if pubspec.yaml file exists');
    if (!await pubspecYamlFile.exists()) {
      _log.severe('Cannot locate pubspec.yaml file');
      exit(1);
    }
  }

  /// Exit if [pubspecYamlFile] is missing core basil fields.
  Future<void> _assertPubspecYamlBasilValid(YamlMap yamlMap) async {
    _log.finer('Checking if YamlMap contains invalid basil fields');

    // Check top-level declaration of basil
    if (!yamlMap.containsKey('basil')) {
      _log.severe('Cannot locate basil field in YamlMap');
      exit(1);
    }

    final yamlMapBasil = yamlMap['basil'];

    if (yamlMapBasil == null) {
      _log.severe('Basil field contains no build types');
      exit(1);
    }

    if (yamlMapBasil is! YamlMap) {
      _log.severe('Basil field is not of type YamlMap');
      exit(1);
    }

    // Check individual build type fields
    for (String buildType in yamlMapBasil.keys) {
      final yamlBuildType = yamlMapBasil[buildType];

      if (yamlBuildType is! YamlMap) {
        _log.severe('Build type "$buildType" is not of type YamlMap');
        exit(1);
      }

      if (yamlBuildType['cmds'] == null) {
        _log.severe('Build type "$buildType" field "cmds" does not exist');
        exit(1);
      }

      if (yamlBuildType['cmds'] is! YamlList) {
        _log.severe('Build type "$buildType" field "cmds" '
            'not of type YamlList');
        exit(1);
      }

      if (yamlBuildType['enabled'] != null &&
          yamlBuildType['enabled'] is! bool) {
        _log.severe('Build type "$buildType" field "enabled" not of type bool');
        exit(1);
      }

      if (yamlBuildType['parallel'] != null &&
          yamlBuildType['parallel'] is! bool) {
        _log.severe('Build type "$buildType" field "parallel" '
            'not of type bool');
        exit(1);
      }

      if (yamlBuildType['platforms'] != null &&
          yamlBuildType['platforms'] is! YamlList) {
        _log.severe('Build type "$buildType" field "platforms" '
            'not of type YamlList: $buildType');
        exit(1);
      }
    }
  }

  /// Return the contents of [pubspecYamlFile] as a string.
  Future<String> _getPubspecYamlString() async {
    await _assertPubspecExists();
    return await pubspecYamlFile.readAsString();
  }

  /// Return the contents of [pubspecYamlFile] as a [YamlMap].
  Future<YamlMap> _getPubspecYamlMap() async {
    final pubspecYamlString = await _getPubspecYamlString();
    return loadYaml(pubspecYamlString);
  }

  /// Return the contents of [pubspecYamlFile] as a [YamlMap]. Check to make
  /// sure that it contains the necessary basil fields.
  Future<YamlMap> getBasilYamlMap() async {
    final yamlMap = await _getPubspecYamlMap();
    await _assertPubspecYamlBasilValid(yamlMap);
    return yamlMap['basil'];
  }
}
