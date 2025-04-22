import 'package:test/test.dart';
import 'package:bash/bash.dart';
import 'package:file/local.dart';

main() {
  group('Run', () {
    test('run1', () async {
      var fs = const LocalFileSystem();
      var shell = Bash();

      // Pipe results to files, easily.
      var echo = await shell.start$([
        'echo',
        ...['hello world'],
      ]);
      await echo.stdout.writeToFile(fs.file('hello.txt'));
      await echo.stderr.drain();

      // You can run a program, and expect a certain exit code.
      //
      // If a valid exit code is returned, stderr is drained, and
      // you don't have to manually.
      //
      // Otherwise, a StateError is thrown.
      var find = await shell.start$([
        'find',
        ...['.', '-name', '"*.dart"'],
      ]);
      await find.expectExitCode([0]); // Can also call find.expectZeroExit()

      // Dump outputs.
      print((await find.stdout.readAsString()));

      // You can also run a process and immediately receive a string.
      var pwd = await shell.runAsString$(['pwd']);
      print('cwd: `$pwd`');

      // Navigation allows you to `cd`.
      //shell.navigate('./lib/src');
      shell.navigate('./lib');
      shell.navigate('./src');
      pwd = await shell.runAsString$(['pwd']);
      print('cwd: `$pwd`');

      var forked = shell;

      // Say hi, as an admin!
      var superEcho = await forked.start$([
        'echo',
        ...['hello, admin!'],
      ]);
      await superEcho.expectExitCode([0, 1]);
      await superEcho.stdout.writeToFile(fs.file('hello_sudo.txt'));

      String find2 = await shell.runAsString(
        'find . -name "*.dart" | wc -l',
        acceptedExitCodes: [0],
      );
      print(find2);

      String find3 = await shell.runAsString$(
        ['find', '.', '-name', '"*.dart"', '|', 'wc', '-l'],
        acceptedExitCodes: [0],
      );
      print(find3);

      String ls = await shell.runAsString$(
        ['ls', '-l', r'D:\home11\pub\bash'],
        acceptedExitCodes: [0],
      );
      print(ls);
    });
  });
}
