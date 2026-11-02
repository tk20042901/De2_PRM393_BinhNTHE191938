import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class AppDatabase {
  Future<Database> open() async {
    late final DatabaseFactory factory;
    if (kIsWeb) {
      factory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      factory = databaseFactoryFfi;
    } else {
      factory = mobile.databaseFactory;
    }

    final databasePath = kIsWeb
        ? 'exam.db'
        : path.join(await factory.getDatabasesPath(), 'exam.db');

    if (!await factory.databaseExists(databasePath)) {
      final asset = await rootBundle.load('assets/database/exam.db');
      final bytes = asset.buffer.asUint8List(
        asset.offsetInBytes,
        asset.lengthInBytes,
      );
      if (kIsWeb) {
        await factory.writeDatabaseBytes(databasePath, bytes);
      } else {
        await Directory(path.dirname(databasePath)).create(recursive: true);
        await File(databasePath).writeAsBytes(bytes, flush: true);
      }
    }

    return factory.openDatabase(
      databasePath,
    );
  }
}
