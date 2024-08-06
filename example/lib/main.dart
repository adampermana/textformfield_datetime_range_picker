import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var dateTtime = DateTime.now();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TextFormField DateTime Range picker',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.fullDateTime,
              initialDate: dateTtime,
              hintTextDate: 'Select Date',
              onChanged: (date) {
                setState(() {
                  dateTtime = date.start;
                  dateTtime = date.end;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
