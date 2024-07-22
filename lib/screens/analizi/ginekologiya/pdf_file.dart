import 'dart:io';
import 'dart:typed_data';
/* import 'package:path_provider/path_provider.dart'; */
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:test3/models/analyses.dart';
/* import 'package:open_document/open_document.dart'; */
import 'package:test3/models/patient.dart';
import 'package:intl/intl.dart';
import 'package:test3/providers/money_provider.dart';

final formater = DateFormat('dd/MM/yyyy');
const blue = PdfColor.fromInt(0xFF0000FF);
const red = PdfColor.fromInt(0xFFFF0000);

class PdfInvoiceService {
  final WidgetRef ref;
  final File? imageFile;
  final Patient patient;
  final Map<String, String> data;
  final String vivod;
  final String dlina;
  final String shirina;
  final String tolshina;
  final String sheykadlina;
  final String sheykashirina;
  final String sheykatolshina;
  final String dopolnenie;
  final DateTime perviyDengPMS;

  PdfInvoiceService(
      {required this.patient,
      required this.ref,
      required this.perviyDengPMS,
      required this.dopolnenie,
      required this.imageFile,
      required this.sheykadlina,
      required this.sheykatolshina,
      required this.sheykashirina,
      required this.data,
      required this.vivod,
      required this.dlina,
      required this.shirina,
      required this.tolshina});

  late Analyses analyses;

  double get obyom1 {
    var number =
        (double.parse(dlina) * double.parse(shirina) * double.parse(tolshina));
    return number.floorToDouble();
  }

  double get obyom2 {
    var number = (double.parse(sheykadlina) *
        double.parse(sheykashirina) *
        double.parse(sheykatolshina));
    return number.floorToDouble();
  }

  Future<void> createAndOpenPdf() async {
    final pdf = pw.Document();

    // Load the image from assets
    final Uint8List imageAsset =
        (await rootBundle.load('assets/images/top2.png')).buffer.asUint8List();

    // Load Gilroy font from assets
    final Uint8List fontData =
        (await rootBundle.load('assets/fonts/Gilroy.ttf')).buffer.asUint8List();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final ttfRegular =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Gilroy.ttf'));
    final ttfBold =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Gilroy-Bold.ttf'));

    // Function to add the image to the PDF
    void addImageToPdf() {
      final defaultFont = pw.TextStyle(font: ttf);
      final defaultBoldfont = pw.TextStyle(font: ttfBold);
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: pw.Column(
              children: [
                pw.Image(pw.MemoryImage(imageAsset)),
                pw.SizedBox(height: 2), // Space between image and line
                pw.Container(
                  width: double.infinity,
                  height: 1, // Line height
                  color: const PdfColor.fromInt(0xFF000000), // black Line color
                ),
                pw.SizedBox(height: 3),

                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text('Ф.И: ${patient.name} ${patient.surName} ',
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 16,
                            color: red,
                          )),
                    ]),
                pw.SizedBox(height: 2),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                          'Дата Рождения:  ${formater.format(patient.birthday)} ',
                          style: pw.TextStyle(
                            font: ttf,
                          )),
                      pw.Spacer(),
                      pw.Text('ID Пациента: ${patient.id} ',
                          style: pw.TextStyle(
                            font: ttf,
                          )),
                    ]),
                pw.SizedBox(height: 2),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                          'Первый день П.М.Ц:  ${formater.format(perviyDengPMS)} ',
                          style: pw.TextStyle(
                            font: ttf,
                          )),
                      pw.Spacer(),
                      pw.Text(
                          'Время исследование: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())} ',
                          style: defaultBoldfont)
                    ]),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Результаты ультразвукового исследования',
                  style: pw.TextStyle(
                      font: ttf, color: const PdfColor.fromInt(0xFF0000FF)),
                ),
                pw.SizedBox(height: 10),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Column(children: [
                      for (var entry in data.entries)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            right: 1,
                          ),
                          child: _Block(
                            title: entry.key,
                            subtitle: entry.value,
                            ttfBold: ttfBold,
                            ttfRegular: ttfRegular,
                          ),
                        ),
                    ]),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Container(
                      child: pw.Column(children: [
                        pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1),
                                borderRadius: pw.BorderRadius.circular(12)),
                            child: pw.Column(children: [
                              pw.Center(
                                child:
                                    pw.Text('Размеры', style: defaultBoldfont),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceAround,
                                children: [
                                  pw.Text('Длина: $dlina mm',
                                      style: defaultFont),
                                  pw.Text('Ширина: $shirina mm',
                                      style: defaultFont),
                                  pw.Text('Тольшина: $tolshina mm',
                                      style: defaultFont),
                                  pw.Text('Объём: $obyom1 mm',
                                      style: defaultBoldfont),
                                ],
                              ),
                            ])),
                        pw.SizedBox(height: 20),
                        pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1),
                                borderRadius: pw.BorderRadius.circular(12)),
                            child: pw.Column(children: [
                              pw.Center(
                                child: pw.Text('Шейка Матки',
                                    style: defaultBoldfont),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceAround,
                                children: [
                                  pw.Text('Длина: $sheykadlina mm',
                                      style: defaultFont),
                                  pw.Text('Ширина: $sheykashirina mm',
                                      style: defaultFont),
                                  pw.Text('Тольшина: $sheykatolshina mm',
                                      style: defaultFont),
                                  pw.Text('Объём: $obyom2 mm ',
                                      style: defaultBoldfont),
                                ],
                              )
                            ])),
                        pw.SizedBox(height: 10),
                        pw.Container(
                          height: 380,
                          child: pw.Column(children: [
                            pw.Center(
                              child:
                                  pw.Text('Снимок №1', style: defaultBoldfont),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Image(
                              pw.MemoryImage(
                                imageFile!.readAsBytesSync(),
                              ),
                              fit: pw.BoxFit.cover,
                              width: 350,
                              height: 350,
                            ),
                          ]),
                        ),
                        pw.SizedBox(height: 10),
                      ]),
                    ),
                  ),
                ]),
                pw.Text(
                  'Вывод',
                  style: pw.TextStyle(font: ttfBold),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text('$vivod. $dopolnenie',
                          style: pw.TextStyle(font: ttf)),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Text(
                    'врач Хосилова Ш.А',
                    style: defaultBoldfont,
                  ),
                ])
              ],
            ),
          ),
        ),
      ));
    }

    // Add the image to the PDF
    addImageToPdf();

    // Save the PDF to a temporary file
    /* final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file with the default PDF viewer
    await OpenDocument.openDocument(filePath: file.path); */
    const destination = 'D:\\analizi\\ginekologiya';

    // Create the destination directory if it doesn't exist
    final directory = Directory(destination);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Save the PDF file to the predefined folder
    var datetime = formater.format(DateTime.now());
    final file = File('$destination/${patient.name}.pdf');
    await file.writeAsBytes(await pdf.save());
    analyses = Analyses(
        cost: ref.watch(moneyProvider)['ginekologiya']!,
        type: 'Гинекология',
        name: '${patient.surName}${patient.name}/ginekologiyaa/$datetime.pdf',
        path: file.path,
        registrDate: DateTime.now());

    // Open the saved PDF file
    await Process.run('cmd', ['/c', 'start', file.path]);
  }
}

class _Block extends pw.StatelessWidget {
  _Block({
    required this.ttfRegular,
    required this.ttfBold,
    required this.title,
    required this.subtitle,
    this.icon,
  });
  final pw.Font ttfRegular;
  final pw.Font ttfBold;
  final String subtitle;
  final String title;

  final pw.IconData? icon;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
                  decoration: const pw.BoxDecoration(
                    color: blue,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Text(title, style: pw.TextStyle(font: ttfBold)),
                pw.Spacer(),
                if (icon != null) pw.Icon(icon!, color: blue, size: 18),
              ]),
          pw.Container(
            decoration: const pw.BoxDecoration(
                border: pw.Border(left: pw.BorderSide(color: blue, width: 2))),
            padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const pw.EdgeInsets.only(left: 5),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(subtitle,
                      style: pw.TextStyle(
                        font: ttfRegular,
                      )),
                ]),
          ),
        ]);
  }
}
