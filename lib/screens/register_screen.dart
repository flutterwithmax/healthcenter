import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test3/models/patient.dart';
import 'package:test3/providers/patients_provider.dart';
import 'package:test3/screens/analyses_screen.dart';
import 'package:test3/models/analyses.dart';

final formater = DateFormat.yMd();

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController surNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  DateTime? selectedDate;
  int _genderIndex = 0;
  List<Analyses> analizi = [];

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 24),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.input,
    );
    setState(() {
      selectedDate = pickedDate!;
    });
  }

  void _resetControllers() {
    surNameController.clear();
    nameController.clear();
    numberController.clear();
    adressController.clear();
    selectedDate = null;
    setState(() {});
  }

  String formatPhoneNumber(String phoneNumber) {
    // Check if the phoneNumber is null or empty

    // Check if the phoneNumber length is less than 7, which is the minimum length required for formatting
    if (phoneNumber.length < 7) {
      return phoneNumber; // Return the phoneNumber as is
    }

    // Extract the operator code and the remaining number
    String operatorCode = phoneNumber.substring(0, 2);
    String remainingNumber = phoneNumber.substring(2);

    // Define the length of each part
    int firstPartLength = 3;
    int secondPartLength = 2;

    // Divide the remaining number into four parts
    String firstPart = remainingNumber.substring(0, firstPartLength);
    String secondPart = remainingNumber.substring(
        firstPartLength, firstPartLength + secondPartLength);
    String thirdPart =
        remainingNumber.substring(firstPartLength + secondPartLength);

    // Join the parts with dashes
    String formattedNumber = '$operatorCode-$firstPart-$secondPart-$thirdPart';

    return formattedNumber;
  }

  @override
  void dispose() {
    surNameController.dispose();
    nameController.dispose();
    numberController.dispose();
    adressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Регистрация',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(0.5), // Color of the shadow
                      spreadRadius: 2, // Spread radius
                      blurRadius: 3, // Blur radius
                      offset: const Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLength: 30,
                          controller: surNameController,
                          decoration: const InputDecoration(
                              labelText: 'Фамилия',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLength: 30,
                          controller: nameController,
                          decoration: const InputDecoration(
                              labelText: 'Имя',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            selectedDate == null
                                ? ' Дата ещё не выбрано'
                                : formater.format(selectedDate!),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: Icon(
                              Icons.calendar_month,
                              color: Colors.blue[900],
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLength: 9,
                          controller: numberController,
                          decoration: const InputDecoration(
                            labelText: 'Номер тел',
                            prefix: Text('+998'),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLength: 80,
                          controller: adressController,
                          decoration: const InputDecoration(
                            labelText: 'Адрес',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _genderIndex = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _genderIndex == 0 ? Colors.blue : Colors.grey,
                            ),
                            child: const Text(
                              'Жен',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _genderIndex = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _genderIndex == 1 ? Colors.blue : Colors.grey,
                            ),
                            child: const Text(
                              'Муж',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _resetControllers();
                    },
                    child: const Text('Очистить'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newPatient = Patient(
                          analyses: analizi,
                          address: adressController.text,
                          birthday: selectedDate!,
                          name: nameController.text,
                          number: formatPhoneNumber(numberController.text),
                          surName: surNameController.text,
                          gender: _genderIndex);
                      ref
                          .read(patientsProvider.notifier)
                          .addNewPatient(newPatient);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                              'Пациент добавлен, вы хотите добавить исследование?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _resetControllers();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Нет'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) =>
                                      AnalysesScreen(patient: newPatient),
                                ));
                              },
                              child: const Text('Да'),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Добавить'),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
