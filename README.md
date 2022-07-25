# basil

A linear build system for Dart projects, designed to be lightweight and extensible.

## Features

* Easily configurable
* Highly flexible
* Fast performance
* Supports parallel execution
* Supports platform-specific build types

## Details

Basil parses a YAML file (by default, the project `pubspec.yaml` file) and looks for a top-level field named `basil`.
Other fields under the `basil` tag are called build types. Each build type must specify a field named `cmds` containing
a list of shell commands. Build types are executed in descending order, by default. Build types can be also specified
manually.

## Install

There are two ways to install `basil`. It can be installed to a project locally, such that others who clone your source
code will fetch `basil` automatically as part of the developer dependencies. It can also be installed globally so
that `basil` does not need to live in your source code, but instead lives on your system.

### For a specific project

Simply add basil to your developer dependencies for your project: `dart pub add --dev basil`.

### Global

If you already have Dart installed, simply activate the package globally:

```shell
dart pub global activate basil
```

## Configuration

The configuration for basil lives in the root `pubspec.yaml` file by default. The format is as follows:

```yaml
# Main basil tag specifying ordered build tags.
basil:
  # Build type names are arbitrary.
  ex1:
    # (Required) list of shell commands to execute.
    cmds: [ 'cmd1', 'cmd2', ... ]
    # (Optional) toggle the execution of this build tag.
    enabled: true
    # (Optional) execute the shell commands concurrently. Wait for completion before proceeding
    # to the next build tag.
    parallel: false
    # (Optional) list of platforms to execute this build tag on. Platform is determined via
    # [Platform.operatingSystem]. Example: platforms: [ 'linux', 'macos' ].
    platforms: null
  ex2:
    ...
  ex3:
    ...
```

## Usage

Once configured, you can start a build via: `dart run basil:main` if you installed it to your project, or just
run `basil` if you installed it globally. This will process all the build steps in descending order.

A specific configuration file can be specified using the `--config` or `-c` option. For
example: `dart run basil:main -c custom.yaml` or `basil -c custom.yaml`.

Build steps can also be specified individually: `dart run basil:main [type...]` or `basil [type...]`. For
example: `dart run basil:main build cleanup` or `basil build cleanup` will execute exclusively the `build` step and
the `cleanup` step.
