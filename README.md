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

## Getting started

Simply add basil to your developer dependencies for your project: `dart pub add --dev basil`.

## Configuration

The configuration for basil lives in the root `pubspec.yaml` file. The format is as follows:

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

Once configured, you can start a build via: `dart run basil:main`. This will process all the build steps in descending
order.

A specific configuration file can be specified using the `--config` or `-c` option. For
example: `dart run basil:main -c custom.yaml`.

Build steps can also be specified individually: `dart run basil:main [type...]`. For
example: `dart run basil:main build cleanup` will execute exclusively the `build` step and the `cleanup` step.
