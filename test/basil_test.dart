import 'package:basil/basil.dart';
import 'package:basil/utils/yaml_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Basil builds', () {
    final yamlParser =
        YamlParser(pubspecYamlFilePath: 'test/basil_test_pubspec.yaml');

    test('Build all', () async {
      final yamlMap = await yamlParser.getBasilYamlMap();
      final basil = Basil(yamlMap);
      await basil.buildAll();
    });

    test('Build some', () async {
      final yamlMap = await yamlParser.getBasilYamlMap();
      final basil = Basil(yamlMap);
      await basil.buildOnly(['ex2', 'ex1']);
    });
  });
}
