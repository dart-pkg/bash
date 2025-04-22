import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file/file.dart';

class WrappedProcess {
  final Process process;
  final String executable;
  final Iterable<String> arguments;
  late WrappedProcessOutput _stdout, _stderr;

  WrappedProcess(this.executable, this.arguments, this.process) {
    _stdout = WrappedProcessOutput(process, process.stdout);
    _stderr = WrappedProcessOutput(process, process.stderr);
  }

  Future<int> get exitCode => process.exitCode;

  String get invocation =>
      arguments.isEmpty ? executable : '$executable ${arguments.join(' ')}';

  Future expectZeroExit() => expectExitCode(const [0]);

  Future expectExitCode(Iterable<int> acceptedCodes) async {
    var code = await exitCode;
    if (!acceptedCodes.contains(code)) {
      throw StateError(
        '$invocation terminated with unexpected exit code $code.',
      );
    } else {
      await stderr.drain();
    }
  }

  int get pid => process.pid;

  IOSink get stdin => process.stdin;

  WrappedProcessOutput get stdout => _stdout;

  WrappedProcessOutput get stderr => _stderr;
}

class WrappedProcessOutput extends Stream<List<int>> {
  final Process _process;
  final Stream<List<int>> _stream;

  WrappedProcessOutput(this._process, this._stream);

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<String> readAsString({Encoding encoding = utf8}) async {
    //return transform(encoding.decoder).join();
    String result = await transform(encoding.decoder).join();
    if (result.endsWith('\r\n')) {
      result = result.substring(0, result.length - 2);
    } else if (result.endsWith('\n')) {
      result = result.substring(0, result.length - 1);
    } else if (result.endsWith('\r')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  Future writeToFile(File file) {
    return _process.exitCode.then((_) => _stream.pipe(file.openWrite()));
  }
}
