import 'package:flutter/material.dart';
import 'package:test3/screens/search_screen.dart';

class SearchPanel extends StatelessWidget {
  const SearchPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SearchScreen(),
        ));
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 66,
        child: Container(
          margin: const EdgeInsets.only(
            right: 10,
            left: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          width: double.infinity,
          height: 40,
          child: const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                'Искать Пациента',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 123, 123, 123),
                ),
              ),
              Spacer(),
              Icon(
                Icons.search,
                color: Color.fromARGB(255, 123, 123, 123),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
