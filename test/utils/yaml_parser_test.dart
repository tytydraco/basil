import 'package:basil/utils/yaml_parser.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('Parse yaml from file', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_no_defaults.yaml');
    final yamlMap = await yamlParser.getBasilYamlMap();

    expect(
      yamlMap.toString(),
      '{ex1: {platforms: [windows], enabled: false, '
      'parallel: true, cmds: []}}',
    );
  });

  test('All defaults', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_defaults.yaml');
    expect(yamlParser.getBasilYamlMap(), isA<Future<YamlMap>>());
  });

  test('No basil field', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_no_basil.yaml');
    expect(yamlParser.getBasilYamlMap(), throwsArgumentError);
  });

  test('No cmds field', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_no_cmds.yaml');
    expect(yamlParser.getBasilYamlMap(), throwsArgumentError);
  });

  test('Bad type for basil', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_bad_basil.yaml');
    expect(yamlParser.getBasilYamlMap(), throwsArgumentError);
  });

  test('Bad type for cmds', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_bad_cmds.yaml');
    expect(yamlParser.getBasilYamlMap(), throwsArgumentError);
  });

  test('Bad type for enabled', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_bad_enabled.yaml');
    expect(yamlParser.getBasilYamlMap(), throwsArgumentError);
  });

  test('Bad type for parallel', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_bad_parallel.yaml');
    expect(yamlParser.getBasilYamlMap(), throwsArgumentError);
  });

  test('Bad type for platforms', () async {
    final yamlParser =
        YamlParser(yamlFilePath: 'test/test_config_bad_platforms.yaml');
    expect(yamlParser.getBasilYamlMap(), throwsArgumentError);
  });
}
