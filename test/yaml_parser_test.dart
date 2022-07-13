import 'package:basil/utils/yaml_parser.dart';
import 'package:test/test.dart';

void main() {
  test('Parse yaml from file', () async {
    const testFileLocation = 'test/basil_test_pubspec.yaml';

    final yamlParser = YamlParser(pubspecYamlFilePath: testFileLocation);
    final yamlMap = await yamlParser.getBasilYamlMap();

    expect(yamlMap.toString(),
        '{ex1: {cmds: [echo 1, echo 2, echo 3]}, '
        'ex2: {cmds: [echo 4, echo 5, echo 6]}}');
  });
}