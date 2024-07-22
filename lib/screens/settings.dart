import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test3/providers/money_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final myDate = ref.watch(moneyProvider);
    print(myDate);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0E1731),
        centerTitle: true,
        title: const Text(
          'Настройки',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Center(
              child: Text(
            'Цены',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )),
          const SizedBox(
            height: 10,
          ),
          for (var data in myDate.entries)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Card(
                elevation: 2.0,
                child: ListTile(
                  leading: SizedBox(
                    width: 300,
                    child: Text(
                      '${data.key[0].toUpperCase()}${data.key.substring(1)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    data.value.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        final controller = TextEditingController();
                        controller.text = data.value.toString();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SizedBox(
                              height: 200,
                              width: 400,
                              child: Center(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      label: Text('цена')),
                                  controller: controller,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton.icon(
                                onPressed: () {
                                  if (int.tryParse(controller.text) == null ||
                                      int.parse(controller.text) < 0) {
                                    return;
                                  }

                                  ref.read(moneyProvider.notifier).updatePrice(
                                      data.key, int.parse(controller.text));
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.save),
                                label: const Text('Сохранить'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
