import 'package:uuid/uuid.dart';
import './analyses.dart';

class Patient {
  final String id;
  final DateTime birthday;
  final DateTime registredTime;
  final String name;
  final String surName;
  final String address;
  final String number;
  final List<Analyses> analyses;
  final int gender;

  Patient({
    required this.birthday,
    required this.name,
    required this.surName,
    required this.address,
    required this.number,
    required this.analyses,
    required this.gender,
    DateTime? registredTime,
    String? id,
  })  : registredTime = registredTime ?? DateTime.now(),
        id = id ?? const Uuid().v4();

  // Generate UUID for id

  // You can add other methods or properties as needed

  int get totalSum {
    var total = 0;

    for (var analyse in analyses) {
      total += analyse.cost;
    }

    return total;
  }
}
