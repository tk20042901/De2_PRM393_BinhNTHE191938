import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  sqfliteFfiInit();
  final db = await databaseFactoryFfi.openDatabase('assets/database/exam.db');
  try {
    final tables = await db.rawQuery(
      "SELECT name, sql FROM sqlite_master WHERE type = 'table' ORDER BY name",
    );
    print(tables);
    print(await db.rawQuery('PRAGMA integrity_check'));
  } finally {
    await db.close();
  }
}
