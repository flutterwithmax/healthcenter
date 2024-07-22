import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test3/models/analyses.dart';
import '../models/patient.dart';

import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;
import 'package:sqflite_common/sqlite_api.dart';

void _initializeDatabaseFactory() {
  sql.sqfliteFfiInit();
  sql.databaseFactory = sql.databaseFactoryFfi;
}

Future<Database> _getDatabase() async {
  // Call the initialization function before using getDatabasesPath
  _initializeDatabaseFactory();

  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'newpatients2.db'), // Corrected the database name
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE patients(id TEXT PRIMARY KEY, birthday TEXT, registredTime TEXT, name TEXT, surName TEXT, address TEXT, number TEXT, gender INTEGER)');
      await db.execute(
          'CREATE TABLE analyses(id INTEGER PRIMARY KEY AUTOINCREMENT, patient_id TEXT, type TEXT, name TEXT, path TEXT, registrDate TEXT,cost INTEGER, FOREIGN KEY(patient_id) REFERENCES patients(id))');
    },
    version: 1,
  );

  return db;
}

class PatientsProviderNotifier extends StateNotifier<List<Patient>> {
  PatientsProviderNotifier() : super([]);

  Future<void> loadDb() async {
    final db = await _getDatabase();
    final patientsData = await db.query('patients');
    final patients = <Patient>[];
    for (final patientData in patientsData) {
      final patientId = patientData['id'] as String;
      final patientAnalysesData = await db
          .query('analyses', where: 'patient_id = ?', whereArgs: [patientId]);
      final analyses = patientAnalysesData
          .map((row) => Analyses(
                cost: row['cost'] as int,
                type: row['type'] as String,
                name: row['name'] as String,
                path: row['path'] as String,
                registrDate: DateTime.parse(row['registrDate'] as String),
              ))
          .toList();
      final task = Patient(
        id: patientId,
        address: patientData['address'] as String,
        analyses: analyses,
        birthday: DateTime.parse(patientData['birthday'] as String),
        gender: patientData['gender'] as int,
        name: patientData['name'] as String,
        surName: patientData['surName'] as String,
        registredTime: DateTime.parse(patientData['registredTime'] as String),
        number: patientData['number'] as String,
      );
      patients.add(task);
    }
    state = patients;
  }

  void addNewPatient(Patient patient) async {
    state = [...state, patient];
    final db = await _getDatabase();
    db.insert('patients', {
      'id': patient.id,
      'address': patient.address,
      'birthday': patient.birthday.toIso8601String(),
      'gender': patient.gender,
      'name': patient.name,
      'surName': patient.surName,
      'registredTime': patient.registredTime.toIso8601String(),
      'number': patient.number,
    });
  }

  Future<void> deletePatient(String patientId) async {
    state = state.where((patient) => patient.id != patientId).toList();
    final db = await _getDatabase();
    await db.delete(
      'patients',
      where: 'id = ?',
      whereArgs: [patientId],
    );
  }

  Future<void> addAnalyses(String patientId, Analyses analyses) async {
    final db = await _getDatabase();

    await db.insert('analyses', {
      'patient_id': patientId,
      'type': analyses.type,
      'name': analyses.name,
      'path': analyses.path,
      'registrDate': analyses.registrDate.toIso8601String(),
      'cost ': analyses.cost,
    });
    // Reload tasks to reflect the changes
    await loadDb();
  }

  List<Patient> getFilteredPatients(DateTime startDate, DateTime endDate) {
    return state.where((patient) {
      return patient.registredTime.isAfter(startDate) &&
          patient.registredTime.isBefore(endDate);
    }).toList();
  }

  int getTotalAnalysesCount(DateTime startDate, DateTime endDate) {
    int totalCount = 0;
    for (final patient in state) {
      for (final analysis in patient.analyses) {
        if (analysis.registrDate.isAfter(startDate) &&
            analysis.registrDate.isBefore(endDate)) {
          totalCount++;
        }
      }
    }
    return totalCount;
  }

  int getTotalCost(DateTime startDate, DateTime endDate) {
    int totalCost = 0;
    for (final patient in state) {
      for (final analysis in patient.analyses) {
        if (analysis.registrDate.isAfter(startDate) &&
            analysis.registrDate.isBefore(endDate)) {
          totalCost += analysis.cost;
        }
      }
    }
    return totalCost;
  }
}

final patientsProvider =
    StateNotifierProvider<PatientsProviderNotifier, List<Patient>>(
        (ref) => PatientsProviderNotifier());
