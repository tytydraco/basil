import 'package:basil/basil.dart';
import 'package:basil/utils/output.dart';
import 'package:basil/utils/yaml_parser.dart';

Future<void> main(List<String> args) async {
  Output.setupLogging();

  final yamlParser = YamlParser();
  final yamlMap = await yamlParser.getBasilYamlMap();
  final basil = Basil(yamlMap);

  if (args.isEmpty) {
    await basil.buildAll();
  } else {
    await basil.buildOnly(args);
  }
}
