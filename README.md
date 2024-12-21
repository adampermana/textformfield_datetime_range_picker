# textformfield_datetime_range_picker

[![pub package](https://img.shields.io/pub/v/textformfield_datetime_range_picker)](https://pub.dartlang.org/packages/textformfield_datetime_range_picker)
[![likes](https://img.shields.io/pub/likes/textformfield_datetime_range_picker)](https://pub.dev/packages/textformfield_datetime_range_picker/score)
[![popularity](https://img.shields.io/pub/popularity/textformfield_datetime_range_picker)](https://pub.dev/packages/textformfield_datetime_range_picker/score)
[![pub points](https://img.shields.io/pub/points/textformfield_datetime_range_picker)](https://pub.dev/packages/textformfield_datetime_range_picker/score)
[![GitHub stars](https://img.shields.io/github/stars/adampermana/textformfield_datetime_range_picker?logo=github)](https://github.com/adampermana/textformfield_datetime_range_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/adampermana/textformfield_datetime_range_picker?logo=github)](https://github.com/adampermana/textformfield_datetime_range_picker/network)

A customizable date and time range picker widget for Flutter applications.

The `TextFormFieldDateTimeRangePicker` allows users to select a range of dates and times. It supports three modes: full date-time, time-only, and date-only selection. This widget is useful for scenarios where you need users to specify a range of dates and/or times, such as booking systems, scheduling apps, or event management.

## 💰 You can help me by Donating
  [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/adampermana)

## Demo

|                                Demo timeonly                                 |                                Demo fullDateTime                                 |                                Demo dateonly                                 |
| :-------------------------------------------------------------------: | :-----------------------------------------------------------------------: | :-----------------------------------------------------------------------: |
| ![Demo timeonly](https://raw.githubusercontent.com/adampermana/textformfield_datetime_range_picker/master/screenshoot/timeonly.gif) | ![Demo fullDateTime](https://raw.githubusercontent.com/adampermana/textformfield_datetime_range_picker/master/screenshoot/fulldatetime.gif) | ![Demo dateonly](https://raw.githubusercontent.com/adampermana/textformfield_datetime_range_picker/master/screenshoot/dateonly.gif) |


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
* Flutter macos

## Installation

1. Add `textformfield_datetime_range_picker.dart: <latest-version>` to your `pubspec.yaml` dependencies. And import it:
   Get the latest version in the 'Installing' tab on pub.dev
```yaml
dependencies:
  textformfield_datetime_range_picker: <latest-version>
```
```yaml
flutter pub add textformfield_datetime_range_picker
```

2. Run pub get.
```yaml
flutter pub get
```
3. Import package.
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

## License

MIT

## Contributing

Pull requests are welcome.
