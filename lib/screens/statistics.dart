import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:test3/providers/patients_provider.dart';

final formater = DateFormat.yMd();

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  var periud = 'all time';
  late DateTime nachala;
  late DateTime konec;

  @override
  void initState() {
    nachala = DateTime(2000);
    konec = DateTime.now();
    super.initState();
  }

  DateTime getStartOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  DateTime getStartOfWeek(DateTime dateTime) {
    // Get the difference in days from the current date to the previous Monday
    int daysToSubtract = dateTime.weekday - DateTime.monday;
    // Subtract the difference to get the previous Monday and set time to 00:00
    DateTime startOfWeek =
        DateTime(dateTime.year, dateTime.month, dateTime.day - daysToSubtract);
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  DateTime getStartOfMonth(DateTime dateTime) {
    // Construct a new DateTime object for the first day of the month at 00:00
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  DateTime getStartOfYear(DateTime dateTime) {
    // Construct a new DateTime object for January 1st of the given year at 00:00
    return DateTime(dateTime.year, 1, 1);
  }

  DateTime getStartOfYesterday(DateTime dateTime) {
    // Subtract one day from the current date
    DateTime yesterday = dateTime.subtract(const Duration(days: 1));
    // Construct a new DateTime object for the beginning of yesterday
    return DateTime(yesterday.year, yesterday.month, yesterday.day);
  }

  @override
  Widget build(BuildContext context) {
    var myList = ref
        .watch(patientsProvider.notifier)
        .getFilteredPatients(nachala, konec);
    var myAnalyses = ref
        .watch(patientsProvider.notifier)
        .getTotalAnalysesCount(nachala, konec);
    //mainBox
    Widget mainBox(String title) {
      return Container(
        width: 380,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF0E1731),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Кол-Пользователей',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {},
              child: const Row(
                children: [
                  Text(
                    'Посмотреть',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
    }

    Widget miniContainer(String title, String data) {
      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  data,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //
    Widget largeContainer(String title, String data, String perioud) {
      return Container(
        width: 380,
        height: 290,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  perioud,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  data,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget piechartGraph() {
      return Container(
        height: 350,
        width: 350,
        child: PieChart(PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.blue[100],
              value: 20,
              title: 'Анализ 2',
              radius: 80,
            ),
            PieChartSectionData(
              color: Colors.blue[200],
              value: 20,
              title: 'Анализ 3',
              titleStyle: const TextStyle(
                color: Colors.white,
              ),
              radius: 80,
            ),
            PieChartSectionData(
              color: Colors.blue[400],
              value: 10,
              title: 'Анализ 4',
              titleStyle: const TextStyle(
                color: Colors.white,
              ),
              radius: 80,
            ),
            PieChartSectionData(
              color: Colors.blue[800],
              value: 30,
              title: 'Анализ 5',
              titleStyle: const TextStyle(
                color: Colors.white,
              ),
              radius: 80,
            ),
            PieChartSectionData(
              color: Colors.blue[900],
              value: 20,
              title: 'Анализ 1 ',
              titleStyle: const TextStyle(
                color: Colors.white,
              ),
              radius: 80,
            ),
          ],
          centerSpaceRadius: 80,
        )),
      );
    }

    //Buttons

    Widget buttons() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        width: 400,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        periud == 'all time' ? Colors.blue[900] : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      periud = 'all time';
                    });
                  },
                  child: const Text(
                    'Всё время',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        periud == 'this year' ? Colors.blue[900] : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      nachala = getStartOfYear(DateTime.now());
                      periud = 'this year';
                    });
                  },
                  child: const Text(
                    'Этот год',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        periud == 'this month' ? Colors.blue[900] : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      nachala = getStartOfMonth(DateTime.now());
                      periud = 'this month';
                    });
                  },
                  child: const Text(
                    'Этот месяц',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        periud == 'this week' ? Colors.blue[900] : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      nachala = getStartOfWeek(DateTime.now());
                      periud = 'this week';
                    });
                  },
                  child: const Text(
                    'Это неделя',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        periud == 'today' ? Colors.blue[900] : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      nachala = getStartOfDay(DateTime.now());
                      periud = 'today';
                    });
                  },
                  child: const Text(
                    'Сегодня',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        periud == 'yesterday' ? Colors.blue[900] : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      nachala = getStartOfYesterday(DateTime.now());
                      periud = 'yesterday';
                    });
                  },
                  child: const Text(
                    'Вчера',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget filter() {
      return Container(
        height: 200,
        width: 500,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Фильтры',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(now.year - 1),
                        firstDate: DateTime(now.year - 100),
                        lastDate: now,
                        initialEntryMode: DatePickerEntryMode.input,
                      );
                      setState(() {
                        nachala = pickedDate!;
                      });
                    },
                    child: Text(
                      'Начала: ${formater.format(nachala)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(now.year - 1),
                        firstDate: DateTime(now.year - 100),
                        lastDate: now,
                        initialEntryMode: DatePickerEntryMode.input,
                      );
                      setState(() {
                        konec = pickedDate!;
                      });
                    },
                    child: Text(
                      'Конец: ${formater.format(konec)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0E1731),
        centerTitle: true,
        title: const Text(
          'Статистика',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                mainBox(myList.length.toString()),
                const SizedBox(
                  width: 50,
                ),
                buttons(),
                const SizedBox(
                  width: 50,
                ),
                filter(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        miniContainer('Пользователи', myList.length.toString()),
                        const SizedBox(
                          width: 20,
                        ),
                        miniContainer('Анализи', myAnalyses.toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    largeContainer(
                        'Заработано',
                        '${ref.watch(patientsProvider.notifier).getTotalCost(nachala, konec)} сум',
                        '22.01.2022 - 22.04.2024'),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    const Text('Графики'),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        piechartGraph(),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20)),
                          height: 350,
                          width: 350,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20)),
                          height: 350,
                          width: 350,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
