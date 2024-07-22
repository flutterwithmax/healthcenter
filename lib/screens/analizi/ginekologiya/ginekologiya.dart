import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test3/data/ginekologiya_data.dart';
import 'package:test3/models/patient.dart';
import 'package:test3/providers/patients_provider.dart';
import 'package:test3/screens/analizi/ginekologiya/pdf_file.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:test3/screens/main_screen.dart';

class Ginekologiya extends ConsumerStatefulWidget {
  final Patient patient;
  const Ginekologiya({super.key, required this.patient});

  @override
  ConsumerState<Ginekologiya> createState() => _GinekologiyaState();
}

class _GinekologiyaState extends ConsumerState<Ginekologiya> {
  var dopolnenieKVivodu = TextEditingController();
  var dlinaController = TextEditingController();
  var shirinaController = TextEditingController();
  var tolshinaController = TextEditingController();
  var sheykamatkiDlinaController = TextEditingController();
  var sheykaMatkishirinaController = TextEditingController();
  var sheykaMaktitolshinaController = TextEditingController();
  var vivod = ginekologiyaData.vivodi[0];
  var polost = ginekologiyaData.polostList[0];
  var yaichnikisPravo = ginekologiyaData.yaichnikiList[0];
  var yaichnikisLevo = ginekologiyaData.yaichnikiList[0];
  var zadniyDuglas = ginekologiyaData.zadniyDuglasList[0];
  var polojenieMatki = ginekologiyaData.polojenitaMatkiList[0];
  var forma = ginekologiyaData.formaListt[0];
  var konturi = ginekologiyaData.konturi[0];
  var endrometriya = ginekologiyaData.endrometriyList[0];
  var miometriy = ginekologiyaData.miometriyList[0];
  var slizistaya = ginekologiyaData.slizistayaList[0];
  File? _imageFile;
  DateTime? perviyDengPMS;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month - 2),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    setState(() {
      perviyDengPMS = pickedDate!;
    });
  }

  Future<void> _pickImageFromWindows() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      initialDirectory: 'D:\\photos\\patients\\',
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    dopolnenieKVivodu.dispose();
    dlinaController.dispose();
    shirinaController.dispose();
    tolshinaController.dispose();
    sheykaMaktitolshinaController.dispose();
    sheykaMatkishirinaController.dispose();
    sheykamatkiDlinaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //1
    Widget matkaVpolojenie() {
      return Row(
        children: [
          const Text(
            'Матка в Положении',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: polojenieMatki,
              items: ginekologiyaData.polojenitaMatkiList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  polojenieMatki = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget razmeri() {
      return Column(
        children: [
          const Text(
            'Размеры',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: dlinaController,
                  decoration: const InputDecoration(
                    labelText: 'Длина',
                    prefix: Text('мм'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: shirinaController,
                  decoration: const InputDecoration(
                    labelText: 'Ширина',
                    prefix: Text('мм'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tolshinaController,
                  decoration: const InputDecoration(
                    labelText: 'Толшина',
                    prefix: Text('мм'),
                  ),
                ),
              ),
            ),
          ]),
        ],
      );
    }

    Widget formaRow() {
      return Row(
        children: [
          const Text(
            'Форма',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: forma,
              items: ginekologiyaData.formaListt
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  forma = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget konturiRow() {
      return Row(
        children: [
          const Text(
            'Контуры',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: konturi,
              items: ginekologiyaData.konturi
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  konturi = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    //second Container

    Widget endrometriyRow() {
      return Row(
        children: [
          const Text(
            'Эндрометрий',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: endrometriya,
              items: ginekologiyaData.endrometriyList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  endrometriya = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget miometriyRow() {
      return Row(
        children: [
          const Text(
            'Миометрий',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: miometriy,
              items: ginekologiyaData.miometriyList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  miometriy = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget slizistayaRow() {
      return Row(
        children: [
          const Text(
            'Слизистая',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: slizistaya,
              items: ginekologiyaData.slizistayaList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  slizistaya = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget sheykoMatkirazmeri() {
      return Column(
        children: [
          const Text(
            'Шейка Матки',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: sheykamatkiDlinaController,
                    decoration: const InputDecoration(
                      labelText: 'Длина',
                      prefix: Text('мм'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: sheykaMatkishirinaController,
                    decoration: const InputDecoration(
                      labelText: 'Ширина',
                      prefix: Text('мм'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: sheykaMaktitolshinaController,
                    decoration: const InputDecoration(
                      labelText: 'Толшина',
                      prefix: Text('мм'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    //3 container

    Widget polostRow() {
      return Column(
        children: [
          const Text(
            'Полость',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: polost,
              items: ginekologiyaData.polostList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  polost = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget yaichnikiRow() {
      return Column(
        children: [
          const Text(
            'Яичники',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Text(
                'Сппаво',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
                  value: yaichnikisPravo,
                  items: ginekologiyaData.yaichnikiList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      yaichnikisPravo = value!;
                    });
                  },
                ),
              ),
              const Text(
                'Слево',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
                  value: yaichnikisLevo,
                  items: ginekologiyaData.yaichnikiList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      yaichnikisLevo = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    //contain 4
    Widget zadniyDuglasRow() {
      return Column(
        children: [
          const Text(
            'Задный дуглас',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: zadniyDuglas,
              items: ginekologiyaData.zadniyDuglasList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  zadniyDuglas = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget vivodRow() {
      return Column(
        children: [
          const Text(
            'Вывод',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: vivod,
              items: ginekologiyaData.vivodi
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  vivod = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget dopolneniyekVivodu() {
      return Column(
        children: [
          const Text('Дополнение к выводу'),
          TextField(
            controller: dopolnenieKVivodu,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Гинекология'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Первый день П.М.Ц',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    perviyDengPMS == null
                        ? ' Дата ещё не выбрано'
                        : formater.format(perviyDengPMS!),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color of the shadow
                    spreadRadius: 2, // Spread radius
                    blurRadius: 3, // Blur radius
                    offset: const Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: matkaVpolojenie()),
                  Expanded(child: formaRow()),
                  Expanded(child: konturiRow()),
                  Expanded(child: razmeri()),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color of the shadow
                    spreadRadius: 2, // Spread radius
                    blurRadius: 3, // Blur radius
                    offset: const Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: endrometriyRow(),
                  ),
                  Expanded(child: miometriyRow()),
                  Expanded(
                    child: slizistayaRow(),
                    flex: 2,
                  ),
                  Expanded(child: sheykoMatkirazmeri()),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color of the shadow
                    spreadRadius: 2, // Spread radius
                    blurRadius: 3, // Blur radius
                    offset: const Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: polostRow(),
                  ),
                  Expanded(
                    child: yaichnikiRow(),
                    flex: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color of the shadow
                    spreadRadius: 2, // Spread radius
                    blurRadius: 3, // Blur radius
                    offset: const Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: zadniyDuglasRow(),
                  ),
                  Expanded(
                    child: vivodRow(),
                    flex: 2,
                  ),
                  Expanded(
                    child: dopolneniyekVivodu(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Row(
              children: [
                InkWell(
                  onTap: _pickImageFromWindows,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color of the shadow
                          spreadRadius: 2, // Spread radius
                          blurRadius: 3, // Blur radius
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : const Center(child: Text('Добавить изображение')),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final pdfService = PdfInvoiceService(
                      ref: ref,
                      perviyDengPMS: perviyDengPMS!,
                      dopolnenie: dopolnenieKVivodu.text,
                      imageFile: _imageFile,
                      sheykadlina: sheykamatkiDlinaController.text,
                      sheykashirina: sheykaMaktitolshinaController.text,
                      sheykatolshina: sheykaMaktitolshinaController.text,
                      dlina: dlinaController.text,
                      shirina: shirinaController.text,
                      tolshina: tolshinaController.text,
                      patient: widget.patient,
                      data: {
                        'Матка в положение': polojenieMatki,
                        'Форма': forma,
                        'Контуры': konturi,
                        'Эндрометрий': endrometriya,
                        'Миометрий': miometriy,
                        'Слизистая': slizistaya,
                        'Полость': polost,
                        'Задный дуглас': zadniyDuglas,
                        'Яичники справо': yaichnikisPravo,
                        'Яичники слево': yaichnikisLevo,
                      },
                      vivod: vivod,
                    );
                    await pdfService.createAndOpenPdf();
                    final analiz = pdfService.analyses;
                    await ref
                        .watch(patientsProvider.notifier)
                        .addAnalyses(widget.patient.id, analiz);

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TabsScreen(),
                    ));
                  },
                  child: const Text('Сохранить'),
                ),
                const SizedBox(
                  width: 50,
                )
              ],
            ),

            //add here a table container with the text of ADd image here, and by tapping here I should be able to pick an image and view it inside this container(width 300, height 300) and use it later in my pdfgeretaservice
          ]),
        ),
      ),
    );
  }
}
