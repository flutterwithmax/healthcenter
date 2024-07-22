import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test3/data/akusherstvo_data.dart';
import 'package:test3/data/ginekologiya_data.dart';
import 'package:test3/models/patient.dart';
import 'package:test3/providers/patients_provider.dart';
import 'package:test3/screens/analizi/ginekologiya/pdf_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class Akushersvto extends ConsumerStatefulWidget {
  final Patient patient;
  const Akushersvto({super.key, required this.patient});

  @override
  ConsumerState<Akushersvto> createState() => _AkushersvtoState();
}

class _AkushersvtoState extends ConsumerState<Akushersvto> {
  var dopolnenieKVivodu = TextEditingController();
  var svdController = TextEditingController();
  var ktrController = TextEditingController();
  var tvpController = TextEditingController();
  var nQController = TextEditingController();
  var sheykaMatkishirinaController = TextEditingController();
  var sheykaMatkiDlinaController = TextEditingController();
  var sheykaMaktitolshinaController = TextEditingController();
  var eggsRighController = TextEditingController();
  var egssLeftController = TextEditingController();
  var diametrController = TextEditingController();
  var okoloPlodnieVal = akusherstvoData.okoloplondieVodi[0];
  var structuraMiometriyVal = akusherstvoData.strukturaMimetriy[0];
  var jeltochniyMeshok = akusherstvoData.vPolosti[0];
  var vivod = ginekologiyaData.vivodi[0];
  var polost = ginekologiyaData.polostList[0];
  var yaichnikisPravo = ginekologiyaData.yaichnikiList[0];
  var yaichnikisLevo = ginekologiyaData.yaichnikiList[0];
  var zadniyDuglas = ginekologiyaData.zadniyDuglasList[0];
  var polojenieMatki = ginekologiyaData.polojenitaMatkiList[0];
  var vPolostiVal = akusherstvoData.vPolosti[0];
  var endrometriya = ginekologiyaData.endrometriyList[0];
  var xorionVal = akusherstvoData.xorion[0];
  var slizistaya = ginekologiyaData.slizistayaList[0];
  var gemotomaVal = akusherstvoData.gemotoma[0];
  var pochkiVal = akusherstvoData.pochkiSostoyanie[0];
  var pochkiChlsVal = akusherstvoData.pochkiCHLS[0];

  File? _imageFile;
  DateTime? perviyDengPMS;
  int indexOfJeltochniyMeshok = 0;
  int indefOfHeartBeat = 1;
  int indexOfMovement = 1;
  int indexOfmiometriy = 0;

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
    svdController.dispose();
    ktrController.dispose();
    nQController.dispose();
    tvpController.dispose();
    sheykaMaktitolshinaController.dispose();
    sheykaMatkishirinaController.dispose();
    sheykaMatkiDlinaController.dispose();

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

    Widget jeltochniyMeshok() {
      return Column(
        children: [
          const Text('Желточный мешок', style: TextStyle(fontSize: 16)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indexOfJeltochniyMeshok = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indexOfJeltochniyMeshok == 0 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Нет',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indexOfJeltochniyMeshok = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indexOfJeltochniyMeshok == 1 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Да',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget diametrMeshka() {
      return Visibility(
        visible: indexOfJeltochniyMeshok == 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: TextField(
            controller: diametrController,
            decoration: const InputDecoration(
                label: Text(
                  'Диаметр',
                ),
                prefix:
                    Text('мм ', style: TextStyle(fontStyle: FontStyle.italic))),
          ),
        ),
      );
    }

    Widget razmeri() {
      return Column(
        children: [
          const Text(
            'Размеры Плода',
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
                  controller: svdController,
                  decoration: const InputDecoration(
                    labelText: 'СВД',
                    prefix: Text('мм'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ktrController,
                  decoration: const InputDecoration(
                    labelText: 'КТР',
                    prefix: Text('мм'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tvpController,
                  decoration: const InputDecoration(
                    labelText: 'ТВП',
                    prefix: Text('мм'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nQController,
                  decoration: const InputDecoration(
                    labelText: 'НК',
                    prefix: Text('мм'),
                  ),
                ),
              ),
            ),
          ]),
        ],
      );
    }

    Widget vPolosti() {
      return Row(
        children: [
          const Text(
            'В полости',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: vPolostiVal,
              items: akusherstvoData.vPolosti
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
                  vPolostiVal = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    //second Container

    Widget heartBeat() {
      return Column(
        children: [
          const Text('Сердцебиение', style: TextStyle(fontSize: 16)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indefOfHeartBeat = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indefOfHeartBeat == 0 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Нет',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indefOfHeartBeat = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indefOfHeartBeat == 1 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Да',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget movement() {
      return Column(
        children: [
          const Text('Движения', style: TextStyle(fontSize: 16)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indexOfMovement = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indexOfMovement == 0 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Нет',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indexOfMovement = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indexOfMovement == 1 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Да',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget hypertonusMiometriy() {
      return Column(
        children: [
          const Text('Гипертонус миометрий', style: TextStyle(fontSize: 16)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indexOfmiometriy = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indexOfmiometriy == 0 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Нет',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    indexOfmiometriy = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      indexOfmiometriy == 1 ? Colors.blue : Colors.grey,
                ),
                child: const Text(
                  'Да',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget struktukaMiometriy() {
      return Row(
        children: [
          const Text(
            'Стр-миометрия',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: structuraMiometriyVal,
              items: akusherstvoData.strukturaMimetriy
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
                  structuraMiometriyVal = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget okPlodnieVodi() {
      return Row(
        children: [
          const Text(
            'Ок-плодные воды',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: okoloPlodnieVal,
              items: akusherstvoData.okoloplondieVodi
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
                  okoloPlodnieVal = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget xorion() {
      return Row(
        children: [
          const Text(
            'Хорион',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: xorionVal,
              items: akusherstvoData.xorion
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
                  xorionVal = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    Widget gemotoma() {
      return Row(
        children: [
          const Text(
            'Гемотома',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: gemotomaVal,
              items: akusherstvoData.gemotoma
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
                  gemotomaVal = value!;
                });
              },
            ),
          ),
        ],
      );
    }

    //third containet

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
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextField(
                    controller: sheykaMatkiDlinaController,
                    decoration: const InputDecoration(
                      labelText: 'Длина',
                      prefix: Text('мм'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
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
                  padding: const EdgeInsets.only(right: 8),
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

    Widget pochkiRow() {
      return Column(
        children: [
          const Text(
            'Почки',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Text(
                'ЧЛС',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
                  value: pochkiChlsVal,
                  items: akusherstvoData.pochkiCHLS
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
                      pochkiChlsVal = value!;
                    });
                  },
                ),
              ),
              const Text(
                'Состояния',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
                  value: pochkiVal,
                  items: akusherstvoData.pochkiSostoyanie
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
                      pochkiVal = value!;
                    });
                  },
                ),
              ),
            ],
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
                'Справо',
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
                            style: const TextStyle(fontSize: 14),
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
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 23),
                width: 60,
                child: TextField(
                  controller: eggsRighController,
                  decoration: const InputDecoration(labelText: 'Размер'),
                ),
              ),
              const SizedBox(width: 20),
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
                            style: const TextStyle(fontSize: 14),
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
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 23),
                width: 60,
                child: TextField(
                  controller: egssLeftController,
                  decoration: const InputDecoration(labelText: 'Размер'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    //contain 4

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
      appBar: AppBar(
        title: const Text('Акушерство'),
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
                    style: TextStyle(fontSize: 16),
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: matkaVpolojenie()),
                  Expanded(child: vPolosti()),
                  Expanded(child: jeltochniyMeshok()),
                  Expanded(
                    child: diametrMeshka(),
                  ),
                  /*  Expanded(child: konturiRow()), */
                  Expanded(child: razmeri()),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: heartBeat(),
                  ),
                  Expanded(
                    child: movement(),
                  ),
                  Expanded(child: xorion()),
                  Expanded(child: hypertonusMiometriy()),
                  Expanded(child: gemotoma()),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: struktukaMiometriy(),
                  ),
                  Expanded(
                    flex: 3,
                    child: slizistayaRow(),
                  ),
                  Expanded(
                    flex: 2,
                    child: okPlodnieVodi(),
                  ),
                  Expanded(
                    flex: 1,
                    child: sheykoMatkirazmeri(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: pochkiRow(),
                  ),
                  Container(
                    child: yaichnikiRow(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: vivodRow(),
                  ),
                  Expanded(
                    child: dopolneniyekVivodu(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            Row(
              children: [
                GestureDetector(
                  onTap: _pickImageFromWindows,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
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
                      sheykadlina: sheykaMatkiDlinaController.text,
                      sheykashirina: sheykaMaktitolshinaController.text,
                      sheykatolshina: sheykaMaktitolshinaController.text,
                      dlina: svdController.text,
                      shirina: nQController.text,
                      tolshina: ktrController.text,
                      patient: widget.patient,
                      data: {
                        'Матка в положение': polojenieMatki,
                        'Форма': vPolostiVal,
                        'Контуры': '',
                        'Эндрометрий': endrometriya,
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
                    ref
                        .watch(patientsProvider.notifier)
                        .addAnalyses(widget.patient.id, analiz);
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
