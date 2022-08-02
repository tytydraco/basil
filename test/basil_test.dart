import 'package:basil/src/basil.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:yamlcfg/yamlcfg.dart';

final exampleYamlCfg = YamlCfg(
  YamlMap.wrap({
    'basil': {
      'first': {
        'cmds': [
          'echo a',
          'echo b',
          'echo c',
        ]
      },
      'second': {
        'cmds': [
          'echo d',
          'echo e',
          'echo f',
        ]
      }
    }
  }),
);

final exampleBasil = Basil(exampleYamlCfg);

void main() {
  group('Basil', () {
    test('Example cfg build all', () async {
      await expectLater(exampleBasil.buildAll(), completes);
    });

    test('Example cfg build one', () async {
      await expectLater(exampleBasil.buildOnly(['first']), completes);
    });

    test('Example cfg build some', () async {
      await expectLater(
        exampleBasil.buildOnly([
          'first',
          'second',
        ]),
        completes,
      );
    });

    test('Example cfg build nonexistent', () async {
      await expectLater(
        exampleBasil.buildOnly(['nonexistent']),
        throwsArgumentError,
      );
    });

    test('Bad cfg build all', () async {
      await expectLater(
        () => Basil(YamlCfg.fromString('bad: 1')).buildAll(),
        throwsArgumentError,
      );
    });

    test('Non-string keys cfg build all', () async {
      await expectLater(
        Basil(
          YamlCfg(
            YamlMap.wrap(
              {
                'basil': {
                  null: {
                    'cmds': [
                      'echo 1',
                      'echo 2',
                    ],
                  },
                  1: {
                    'cmds': [
                      'echo 3',
                      'echo 4',
                    ],
                  },
                  Basil: {
                    'cmds': [
                      'echo 5',
                      'echo 6',
                    ],
                  },
                },
              },
            ),
          ),
        ).buildAll(),
        completes,
      );
    });
  });
}
