import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:std/misc.dart' as misc;
import 'package:path/path.dart' as p;
import 'package:process/process.dart';
import 'wrapped_process.dart';

/// Wrapper over `package:process` [Process] API's that supports features like environment management, user switches, and more.
class Bash {
  final ProcessManager processManager;
  final Map<String, String> environment = {};
  bool includeParentEnvironment;
  String? workingDirectory;
  bool runInShell;

  Bash({
    this.processManager = const LocalProcessManager(),
    this.includeParentEnvironment = true,
    this.workingDirectory,
    this.runInShell = false,
    Map<String, String> environment = const {},
  }) {
    this.environment.addAll(environment);
    workingDirectory ??= p.absolute(p.current);
  }

  String navigate(String path, [bool? changeCurrentDirectory]) {
    print('\$ cd $path');
    if (workingDirectory == null) {
      workingDirectory = path;
    } else {
      workingDirectory = p.join(workingDirectory!, path);
    }
    workingDirectory = p.canonicalize(p.absolute(workingDirectory!));
    bool change = changeCurrentDirectory ?? false;
    if (change) {
      Directory.current = workingDirectory!;
    }
    return workingDirectory!;
  }

  Future<ProcessResult> run(String command) {
    print('\$ $command');
    var bashCommand = ['bash', '-c', command];
    return processManager.run(
      bashCommand,
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
      includeParentEnvironment: includeParentEnvironment,
    );
  }

  Future<ProcessResult> run$(List<String> command) {
    return run(misc.joinCommandLine(command));
  }

  Future<WrappedProcess> start(String command) async {
    print('\$ $command');
    var bashCommand = ['bash', '-c', command];
    var p = await processManager.start(
      bashCommand,
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
      includeParentEnvironment: includeParentEnvironment,
    );
    return WrappedProcess(bashCommand.first, bashCommand.skip(1), p);
  }

  Future<WrappedProcess> start$(List<String> commandList) async {
    return start(misc.joinCommandLine(commandList));
  }

  Future<String> runAsString(
    String command, {
    Encoding encoding = utf8,
    List<int> acceptedExitCodes = const [0],
  }) async {
    var p = await start(command);
    await p.expectExitCode(acceptedExitCodes);
    return await p.stdout.readAsString(encoding: encoding);
  }

  Future<String> runAsString$(
    List<String> commandList, {
    Encoding encoding = utf8,
    List<int> acceptedExitCodes = const [0],
  }) async {
    return runAsString(misc.joinCommandLine(commandList));
  }
}
