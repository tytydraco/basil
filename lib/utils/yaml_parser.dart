import 'dart:io';

import 'package:yaml/yaml.dart';

/// A class to handle the parsing and checking of [yamlFilePath].
class YamlParser {
  /// Create a new [YamlParser] given a [yamlFilePath].
  YamlParser([
    this.yamlFilePath = 'pubspec.yaml',
  ]);

  /// Location of the YAML file.
  final String yamlFilePath;

  late final _yamlFile = File(yamlFilePath);

  /// Throws an [ArgumentError] if it [_yamlFile] is missing.
  void _assertYamlFileExists() {
    if (!_yamlFile.existsSync()) {
      throw ArgumentError('YAML file does not exist at path', yamlFilePath);
    }
  }

  /// Throws an [ArgumentError] if it [yamlMap] is missing core fields.
  Future<void> _assertYamlBasilValid(YamlMap? yamlMap) async {
    // Check contents
    if (yamlMap == null) {
      throw ArgumentError('Invalid YAML file', yamlFilePath);
    }

    // Check top-level declaration of basil
    if (!yamlMap.containsKey('basil')) {
      throw ArgumentError('Field does not exist', 'basil');
    }

    final yamlMapBasil = yamlMap['basil'];

    if (yamlMapBasil == null) {
      throw ArgumentError('Field contains no build types', 'basil');
    }

    if (yamlMapBasil is! YamlMap) {
      throw ArgumentError('Field is not of type YamlMap', 'basil');
    }

    // Check individual build type fields
    for (final buildType in yamlMapBasil.keys) {
      final yamlBuildType = yamlMapBasil[buildType];

      if (yamlBuildType is! YamlMap) {
        throw ArgumentError(
          'Field is not of type YamlMap',
          buildType.toString(),
        );
      }

      if (yamlBuildType['cmds'] == null) {
        throw ArgumentError('Field in "$buildType" does not exist', 'cmds');
      }

      if (yamlBuildType['cmds'] is! YamlList) {
        throw ArgumentError(
          'Field in "$buildType" is not of type YamlList',
          'cmds',
        );
      }

      if (yamlBuildType['enabled'] != null &&
          yamlBuildType['enabled'] is! bool) {
        throw ArgumentError(
          'Field in "$buildType" is not of type bool',
          'enabled',
        );
      }

      if (yamlBuildType['parallel'] != null &&
          yamlBuildType['parallel'] is! bool) {
        throw ArgumentError(
          'Field in "$buildType" is not of type bool',
          'parallel',
        );
      }

      if (yamlBuildType['platforms'] != null &&
          yamlBuildType['platforms'] is! YamlList) {
        throw ArgumentError(
          'Field in "$buildType" is not of type YamlList',
          'platforms',
        );
      }
    }
  }

  /// Return the contents of [_yamlFile] as a string.
  Future<String> _getYamlString() {
    _assertYamlFileExists();
    return _yamlFile.readAsString();
  }

  /// Return the contents of [_yamlFile] as a [YamlMap]. Check to make
  /// sure that it contains the necessary basil fields.
  Future<YamlMap> getBasilYamlMap() async {
    final yamlString = await _getYamlString();
    final yamlMap = await loadYaml(yamlString) as YamlMap?;
    await _assertYamlBasilValid(yamlMap);
    return yamlMap?['basil'] as YamlMap;
  }
}
