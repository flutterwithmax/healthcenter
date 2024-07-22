import 'package:flutter/material.dart';
import 'package:test3/models/patient.dart';
import 'package:test3/screens/analizi/akusherstvo/akusherstvo.dart';

import 'package:test3/screens/analizi/ginekologiya/ginekologiya.dart';

enum TipAnaliza {
  ginekologiya,
  akushersto,
}

class AnalysesScreen extends StatefulWidget {
  final Patient patient;
  const AnalysesScreen({super.key, required this.patient});

  @override
  State<AnalysesScreen> createState() => _AnalysesScreenState();
}

class _AnalysesScreenState extends State<AnalysesScreen> {
  TipAnaliza? _character = TipAnaliza.ginekologiya;
  Widget tipAnaliza(Patient patient) {
    Widget main = Ginekologiya(patient: patient);
    if (_character == TipAnaliza.akushersto) {
      main = Akushersvto(patient: patient);
    }
    return main;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите тип Анализа'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Гинекология'),
            leading: Radio<TipAnaliza>(
              value: TipAnaliza.ginekologiya,
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Акушерство'),
            leading: Radio<TipAnaliza>(
              value: TipAnaliza.akushersto,
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              const SizedBox(
                width: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => tipAnaliza(widget.patient),
                  ));
                },
                child: const Text('Далее'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
