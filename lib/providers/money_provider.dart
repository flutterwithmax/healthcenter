import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;
import 'package:sqflite_common/sqlite_api.dart';

// Initial money data
const initialMoney = {
  'ginekologiya': 25000,
  'akushersvto': 35000,
  'trimestr': 40000,
};

// Initialize the database factory only once
final Future<void> _initialization = (() async {
  sql.sqfliteFfiInit();
  sql.databaseFactory = sql.databaseFactoryFfi;
  print('Database factory initialized');
})();

Future<Database> _getDatabase() async {
  await _initialization;

  final dbPath = await sql.getDatabasesPath();
  final dbFilePath = path.join(dbPath, 'medical_costs.db');

  // Ensure the database file is writable
  final db = await sql.databaseFactory.openDatabase(
    dbFilePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE money(id TEXT PRIMARY KEY, ginekologiya INTEGER, akushersvto INTEGER, trimestr INTEGER)',
        );
        await db.insert('money', {
          'id': '1',
          'ginekologiya': initialMoney['ginekologiya'] as int, // Cast to int
          'akushersvto': initialMoney['akushersvto'] as int,
          'trimestr': initialMoney['trimestr'] as int,
        });
        print('Database and table created, initial data inserted');
      },
      readOnly: false, // Ensure the database is opened in read-write mode
    ),
  );

  print('Database opened at path: $dbFilePath');
  return db;
}

class MoneyProviderNotifier extends StateNotifier<Map<String, int>> {
  MoneyProviderNotifier() : super(initialMoney);

  Future<void> loadFromDb() async {
    try {
      final db = await _getDatabase();
      final maps = await db.query('money');
      if (maps.isNotEmpty) {
        final fetchedData = Map<String, int>.from({
          'ginekologiya': int.parse(maps.first['ginekologiya'].toString()),
          'akushersvto': int.parse(maps.first['akushersvto'].toString()),
          'trimestr': int.parse(maps.first['trimestr'].toString()),
        });
        state = fetchedData; // Update state with the modified copy
        print('Money data loaded: $state');
      } else {
        print('No data found in money table');
      }
    } catch (e) {
      print('Error loading money from DB: $e');
    }
  }

  Future<void> updatePrice(String service, int newPrice) async {
    try {
      final db = await _getDatabase();
      await db.update(
        'money',
        {service: newPrice},
        where: 'id = ?',
        whereArgs: ['1'],
      );
      state = {...state, service: newPrice};
      print('Price updated: $state'); // Update state in memory
    } catch (e) {
      print('Error updating price in DB: $e');
    }
  }
}

final moneyProvider =
    StateNotifierProvider<MoneyProviderNotifier, Map<String, int>>(
        (ref) => MoneyProviderNotifier());
