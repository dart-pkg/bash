import 'package:bash/bash.dart';
import 'package:file/local.dart';

main() async {
  var fs = const LocalFileSystem();
  var shell = Bash();

  // Pipe results to files, easily.
  var echo = await shell.start('echo hello world');
  await echo.stdout.writeToFile(fs.file('hello.txt'));
  await echo.stderr.drain();

  // You can run a program, and expect a certain exit code.
  //
  // If a valid exit code is returned, stderr is drained, and
  // you don't have to manually.
  //
  // Otherwise, a StateError is thrown.
  var find = await shell.start$(['find', '.', '-name', '"*.dart"']);
  await find.expectExitCode([0]); // Can also call find.expectZeroExit()

  // Dump outputs.
  print(await find.stdout.readAsString());

  // You can also run a process and immediately receive a string.
  var pwd = await shell.runAsString('pwd');
  print('cwd: `$pwd`');

  // Navigation allows you to `cd`.
  //shell.navigate('./lib/src');
  shell.navigate('./lib');
  shell.navigate('./src');
  pwd = await shell.runAsString$(['pwd']);
  print('cwd: `$pwd`');

  // You can use | within command line.
  String find2 = await shell.runAsString(
    'find . -name "*.dart" | wc -l',
    acceptedExitCodes: [0],
  );
  print(find2);

  // You can use | within command line.
  String find3 = await shell.runAsString$(
    ['find', '.', '-name', '"*.dart"', '|', 'wc', '-l'],
    acceptedExitCodes: [0],
  );
  print(find3);
}
