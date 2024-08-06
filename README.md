# textformfield_datetime_range_picker

A customizable date and time range picker widget for Flutter applications.

The `TextFormFieldDateTimeRangePicker` allows users to select a range of dates and times. It supports three modes: full date-time, time-only, and date-only selection. This widget is useful for scenarios where you need users to specify a range of dates and/or times, such as booking systems, scheduling apps, or event management.

## Features

- Three selection modes: full date-time, time only, and date only
- Customizable time range (minimum and maximum hours)
- Customizable icon, title, and hint text
- Automatic validation to ensure end date/time is always after start date/time
- Callback for range changes

## Supported platforms

* Flutter Android
* Flutter iOS
* Flutter web
* Flutter desktop

## Installation

Add `textformfield_datetime_range_picker.dart: ^0.0.1` to your `pubspec.yaml` dependencies. And import it:

```dart
import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker.dart';
```

## Example
```dart
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

```
## Example Use Bloc
```dart
   TextFormFieldDateTimeRangePicker(
     selectedOption: DateTimeOption.fullDateTime
     initialDate: state.dateTime ?? DateTime.now(),
     hintTextDate: 'Select Date',
     onChanged: (date) {
       context.read<SecurityFormBloc>().add(
             SecurityFormEvent.dateTimeChanged(
               dateTime: date.start,
               endTime: date.end,
             ),
           );
     },
   ),

```


## Screenshot
Demo fullDateTime:

<div align="left">
  <img src="https://raw.githubusercontent.com/adampermana/textformfield_datetime_range_picker/master/screenshoot/timeonly.gif" width="200" />
</div>
Demo timeonly:

<div align="left">
  <img src="https://raw.githubusercontent.com/adampermana/textformfield_datetime_range_picker/master/screenshoot/fulldatetime.gif" width="200" />
</div>
Demo dateonly:

<div align="left">
  <img src="https://raw.githubusercontent.com/adampermana/textformfield_datetime_range_picker/master/screenshoot/dateonly.gif" width="200" />
</div>


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  textformfield_datetime_range_picker: ^1.0.0
```

## License

MIT