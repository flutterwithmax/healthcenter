import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test3/models/patient.dart';
import 'package:test3/providers/patients_provider.dart';
import 'package:test3/screens/analyses_screen.dart';
import 'package:test3/widgets/custom_divider.dart';
import 'package:intl/intl.dart';

final formater = DateFormat.yMd();

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider);

    List<Patient> filteredPatients = patients.where((patient) {
      final fullName = '${patient.surName} ${patient.name}'.toLowerCase();
      return fullName.contains(_searchQuery.toLowerCase());
    }).toList();

    var activePatients = _searchQuery.isEmpty ? patients : filteredPatients;

    void removePatient(String patientId) {
      ref.read(patientsProvider.notifier).deletePatient(patientId);
      setState(() {});
    }

    Widget searchPanel = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Искать Пациента...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

    Widget divider() {
      return const CustomDivider();
    }

    void openPatientDetails(Patient patient) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              width: 800.0,
              height: 700.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/patient_w.png',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 200,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${patient.surName}  ${patient.name}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const Text('Год-рождение:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                width: 80,
                              ),
                              Text(
                                  '${formater.format(patient.birthday)} (${DateTime.now().year - patient.birthday.year} лет)'),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              const Text('Аддресс:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                width: 120,
                              ),
                              Text(patient.address),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              const Text('Тел-Номер:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                width: 99,
                              ),
                              Text('+998 ${patient.number}'),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              const Text('Дата-Регистратции:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                width: 45,
                              ),
                              Text(DateFormat('dd/MM/yyyy HH:mm')
                                  .format(patient.registredTime)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const Center(
                    child: Text(
                      'Список Исследование',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.white,
                    child: patient.analyses.isEmpty
                        ? const Center(child: Text('нету анализов'))
                        : Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    '№',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text(
                                    'Файл',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                  ),
                                  Text(
                                    'Дата Регистратции',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue[200],
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Process.run('cmd', [
                                          '/c',
                                          'start',
                                          patient.analyses[index].path
                                        ]);
                                      },
                                      leading: Text(
                                        '#${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(patient.analyses[index].name),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Text(DateFormat('dd/MM/yyyy HH:mm')
                                              .format(patient.analyses[index]
                                                  .registrDate)),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  itemCount: patient.analyses.length,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            searchPanel,
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '№',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  Text(
                    'Фамилия',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Имя',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                  ),
                  Text(
                    'Тел-номер',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                  ),
                  Text(
                    'Адресс',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 280,
                  ),
                  Text(
                    'Возраст',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Text(
                    'Кол-Исследование',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    'Действие',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                  ),
                  color: activePatients[index].gender == 0
                      ? Colors.pink[100]
                      : Colors.blue[100],
                  child: ListTile(
                    onTap: () {
                      openPatientDetails(activePatients[index]);
                    },
                    leading: Text(
                      '#${activePatients.indexOf(patients[index]) + 1}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    title: Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                            height: 50,
                            width: 150,
                            child: FittedBox(
                              child: Text(
                                  '${activePatients[index].surName}  ${activePatients[index].name}'),
                            )),
                        const Spacer(),
                        divider(),
                        const Spacer(),
                        Text('+998 ${activePatients[index].number}'),
                        const Spacer(),
                        divider(),
                        const Spacer(),
                        SizedBox(
                            height: 50,
                            width: 300,
                            child: FittedBox(
                                child: Text(activePatients[index].address))),
                        const Spacer(),
                        divider(),
                        const Spacer(),
                        Text(
                            '${DateTime.now().year - activePatients[index].birthday.year}'),
                        const Spacer(),
                        divider(),
                        const Spacer(),
                        Text(
                            '${activePatients[index].analyses.length}'), // kolichestvo-Issledovanie
                        const Spacer(),
                        divider(),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AnalysesScreen(
                                      patient: activePatients[index]),
                                ));
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                removePatient(activePatients[index].id);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                itemCount: activePatients.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
