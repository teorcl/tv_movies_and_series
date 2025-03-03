part of 'http.dart';

void _printLogs(
  Map<String, dynamic> logs,
  StackTrace? stackTrace,
) {
  log(
    '''
          --------------------------------------------
          ${const JsonEncoder.withIndent('  ').convert(logs)}
          --------------------------------------------
          ''',
    stackTrace: stackTrace,
  );
}
