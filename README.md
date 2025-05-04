# textformfield_datetime_range_picker

[![pub package](https://img.shields.io/pub/v/textformfield_datetime_range_picker)](https://pub.dartlang.org/packages/textformfield_datetime_range_picker)
[![likes](https://img.shields.io/pub/likes/textformfield_datetime_range_picker)](https://pub.dev/packages/textformfield_datetime_range_picker/score)
[![pub points](https://img.shields.io/pub/points/textformfield_datetime_range_picker)](https://pub.dev/packages/textformfield_datetime_range_picker/score)
[![GitHub stars](https://img.shields.io/github/stars/adampermana/textformfield_datetime_range_picker?logo=github)](https://github.com/adampermana/textformfield_datetime_range_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/adampermana/textformfield_datetime_range_picker?logo=github)](https://github.com/adampermana/textformfield_datetime_range_picker/network)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A customizable date and time range picker widget for Flutter applications.

The `TextFormFieldDateTimeRangePicker` allows users to select a range of dates and times with different modes of selection: full date-time, time-only, and date-only. This widget is useful for scenarios where you need users to specify a range of dates and/or times, such as booking systems, scheduling apps, or event management.

## ☕ Support My Work
If you find my work valuable, your support means the world to me! It helps me focus on creating more, learning, and growing.
Thank you for your generosity and support! ☕

[![Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/adampermana)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/adampermana)

## Demo

<h3>
<a href="https://adampermana.github.io/textformfield_datetime_range_picker/" target="_blank">
  Click here to experience the demo in a Web App
</a>
</h3>

## Features

- **Multiple Selection Modes**: Full date-time, time-only, and date-only selection
- **Flexible Time Picker Styles**: 
  - Dropdown (classic material style)
  - Spinner (wheel-based selection)
  - SpinnerDropdown (hybrid approach)
- **24/12 Hour Format Support**: Choose between 24-hour or 12-hour (AM/PM) time format
- **Customizable Range Limits**: Define minimum and maximum hours
- **Automatic Validation**: Ensures end date/time is always after start date/time
- **Highly Customizable UI**:
  - Custom icons, titles, and hint text
  - Customizable field appearance (borders, colors, etc.)
  - Customizable button text
- **Formatting Options**: Control date and time display format
- **Comprehensive Callbacks**: Get notified when selections change

## Supported Platforms

* Flutter Android
* Flutter iOS
* Flutter web
* Flutter desktop
* Flutter macOS
* Flutter Linux

## Installation

1. Add `textformfield_datetime_range_picker: <latest-version>` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  textformfield_datetime_range_picker: ^0.0.3
```

2. Run pub get:
```bash
flutter pub get
```

3. Import the package:
```dart
import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker.dart';
```

## Basic Usage

```dart
import 'package:flutter/material.dart';
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
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now().add(const Duration(hours: 2));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TextFormField DateTime Range Picker',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.fullDateTime,
              initialDate: startDateTime,
              hintTextDate: 'Select Date',
              onChanged: (dateRange) {
                setState(() {
                  startDateTime = dateRange.start;
                  endDateTime = dateRange.end;
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

## Advanced Options

### Time Picker Styles

Choose from three different time picker styles:

```dart
TextFormFieldDateTimeRangePicker(
  selectedOption: DateTimeOption.fullDateTime,
  timePickerStyle: TimePickerStyle.spinner, // spinner, dropdown, or spinnerdropdown
  // Other parameters...
)
```

### 24-Hour Mode

Enable 24-hour time format:

```dart
TextFormFieldDateTimeRangePicker(
  selectedOption: DateTimeOption.timeOnly,
  is24HourMode: true, // Set to false for 12-hour AM/PM format
  // Other parameters...
)
```

### Custom Styling and Icons

```dart
TextFormFieldDateTimeRangePicker(
  selectedOption: DateTimeOption.fullDateTime,
  suffixIconDate: const Icon(Icons.calendar_today, color: Colors.blue),
  suffixIconTime: const Icon(Icons.access_time, color: Colors.green),
  titleStartdate: const Text('From Date', style: TextStyle(fontWeight: FontWeight.bold)),
  titleEndDate: const Text('To Date', style: TextStyle(fontWeight: FontWeight.bold)),
  titleStartTime: const Text('Start Time', style: TextStyle(fontWeight: FontWeight.bold)),
  titleEndTime: const Text('End Time', style: TextStyle(fontWeight: FontWeight.bold)),
  dateFieldFillColor: Colors.grey[200],
  dateFieldBorderRadius: BorderRadius.circular(12),
  // Other parameters...
)
```

### Custom Time Limits

```dart
TextFormFieldDateTimeRangePicker(
  selectedOption: DateTimeOption.fullDateTime,
  minHour: 8, // Restrict selection to start at 8:00
  maxHour: 22, // Restrict selection to end at 22:00
  // Other parameters...
)
```

### Use with State Management (BLoC Example)

```dart
TextFormFieldDateTimeRangePicker(
  selectedOption: DateTimeOption.fullDateTime,
  initialDate: state.dateTime ?? DateTime.now(),
  hintTextDate: 'Select Date',
  onChanged: (dateRange) {
    context.read<ScheduleFormBloc>().add(
      ScheduleFormEvent.dateTimeChanged(
        dateTime: dateRange.start,
        endTime: dateRange.end,
      ),
    );
  },
),
```

## Complete Parameters List

### Core Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `selectedOption` | `DateTimeOption` | Mode of date-time selection (fullDateTime, timeOnly, dateOnly) |
| `minHour` | `int` | Minimum selectable hour (0-23). Default: `0` |
| `maxHour` | `int` | Maximum selectable hour (0-23). Default: `18` |
| `initialStartHour` | `int?` | Initial hour for start time. Default: same as `minHour` |
| `initialEndHour` | `int?` | Initial hour for end time. Default: same as `maxHour` |
| `initialDate` | `DateTime?` | Initial date to display |
| `lastDate` | `DateTime?` | Latest selectable date |
| `onChanged` | `ValueChanged<DateTimeRange>?` | Callback for range changes |

### UI Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `suffixIconDate` | `Icon?` | Custom icon for date picker fields |
| `suffixIconTime` | `Icon?` | Custom icon for time picker fields |
| `titleStartdate` | `Text?` | Custom title for start date field |
| `titleEndDate` | `Text?` | Custom title for end date field |
| `titleStartTime` | `Text?` | Custom title for start time field |
| `titleEndTime` | `Text?` | Custom title for end time field |
| `hintTextDate` | `String?` | Hint text for date fields |
| `hintTextTime` | `String?` | Hint text for time fields |
| `buttonCancelTime` | `String?` | Custom text for cancel button |
| `buttonSubmitTime` | `String?` | Custom text for submit button |

### Time Picker Configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `timePickerStyle` | `TimePickerStyle` | Style of time picker (dropdown, spinner, spinnerdropdown). Default: `dropdown` |
| `minutesInterval` | `int` | Interval between minute values. Default: `1` |
| `secondsInterval` | `int` | Interval between second values. Default: `1` |
| `isShowSeconds` | `bool` | Whether to show seconds selection. Default: `false` |
| `is24HourMode` | `bool` | Whether to use 24-hour format. Default: `true` |
| `isForce2Digits` | `bool` | Force 2-digit display for numbers. Default: `false` |
| `onTimeChange` | `TimePickerCallback?` | Callback when time changes (for CustomTimePicker) |

### Spinner Appearance (for Custom Time Picker)

| Parameter | Type | Description |
|-----------|------|-------------|
| `highlightedTextStyle` | `TextStyle?` | Text style for highlighted (selected) time values |
| `normalTextStyle` | `TextStyle?` | Text style for non-selected time values |
| `itemHeight` | `double?` | Height of each item in the spinner |
| `itemWidth` | `double?` | Width of each spinner column |
| `alignment` | `AlignmentGeometry?` | Alignment of text within spinner items |
| `spacing` | `double?` | Horizontal spacing between spinner components |

### Date Field Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `dateFieldFormat` | `DateFormat?` | Format for date display |
| `dateFieldFirstDate` | `DateTime?` | First selectable date |
| `dateFieldValidator` | `String? Function(DateTime?)?` | Validation function for date fields |
| `dateFieldAutovalidateMode` | `AutovalidateMode?` | Auto-validation mode for date fields |
| `dateFieldEnabled` | `bool` | Whether date fields are enabled. Default: `true` |
| `dateFieldResetIcon` | `Icon?` | Icon to reset/clear date fields. Default: `Icons.close` |
| `dateFieldFilled` | `bool` | Whether date fields are filled. Default: `true` |
| `dateFieldFillColor` | `Color?` | Fill color for date fields. Default: light gray |
| `dateFieldBorderRadius` | `BorderRadius` | Border radius for fields. Default: `BorderRadius.circular(8)` |
| `dateFieldBorderSide` | `BorderSide` | Border side for date fields. Default: `BorderSide.none` |
| `dateFieldHintStyle` | `TextStyle` | Hint text style for date fields |
| `dateFieldErrorStyle` | `TextStyle?` | Error text style for date fields |

### Text Field Properties

| Parameter | Type | Description |
|-----------|------|-------------|
| `dateFieldKeyboardType` | `TextInputType?` | Keyboard type for date fields |
| `dateFieldTextCapitalization` | `TextCapitalization` | Text capitalization for date fields. Default: `none` |
| `dateFieldTextInputAction` | `TextInputAction?` | Text input action for date fields |
| `dateFieldStyle` | `TextStyle?` | Text style for the date fields |
| `dateFieldStrutStyle` | `StrutStyle?` | Strut style for date fields |
| `dateFieldTextAlign` | `TextAlign` | Text alignment for date fields. Default: `start` |
| `dateFieldAutofocus` | `bool` | Whether date fields should autofocus. Default: `false` |
| `dateFieldReadOnly` | `bool` | Whether date fields are read-only. Default: `true` |
| `dateFieldShowCursor` | `bool?` | Whether to show cursor in date fields |
| `dateFieldObscureText` | `bool` | Whether to obscure text in date fields. Default: `false` |
| `dateFieldAutocorrect` | `bool` | Whether to enable autocorrect in date fields. Default: `true` |
| `dateFieldMaxLengthEnforcement` | `MaxLengthEnforcement` | Max length enforcement for date fields. Default: `enforced` |
| `dateFieldMaxLines` | `int` | Maximum number of lines for date fields. Default: `1` |
| `dateFieldMinLines` | `int?` | Minimum number of lines for date fields |
| `dateFieldExpands` | `bool` | Whether date fields should expand to fill space. Default: `false` |
| `dateFieldMaxLength` | `int?` | Maximum length for date fields |
| `dateFieldContentPadding` | `EdgeInsetsGeometry?` | Content padding for date fields |
| `dateFieldCursorWidth` | `double` | Cursor width for date fields. Default: `2.0` |
| `dateFieldCursorRadius` | `Radius?` | Cursor radius for date fields |
| `dateFieldCursorColor` | `Color?` | Cursor color for date fields |
| `dateFieldScrollPadding` | `EdgeInsets` | Scroll padding for date fields. Default: `EdgeInsets.all(20.0)` |
| `dateFieldEnableInteractiveSelection` | `bool` | Enable interactive selection in date fields. Default: `true` |
| `dateFieldOnEditingComplete` | `VoidCallback?` | Callback when editing is complete in date fields |
| `dateFieldOnFieldSubmitted` | `void Function(DateTime?)?` | Callback when date fields are submitted |
| `dateFieldInputFormatters` | `List<TextInputFormatter>?` | Input formatters for date fields |
| `dateFieldKeyboardAppearance` | `Brightness?` | Keyboard appearance for date fields |
| `dateFieldBuildCounter` | `Widget? Function(...)` | Builder for counter in date fields |

## License

MIT

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Activities
![Alt](https://repobeats.axiom.co/api/embed/aea2f13bdf4c30458609cdb40c73b12a8ef8bffd.svg "Repobeats analytics image")

[pub]: https://pub.dev/packages/textformfield_datetime_range_picker
[github]: https://github.com/adampermana
[releases]: https://github.com/adampermana/textformfield_datetime_range_picker/releases
[repo]: https://github.com/adampermana/textformfield_datetime_range_picker
[issues]: https://github.com/adampermana/textformfield_datetime_range_picker/issues
[license]: https://github.com/adampermana/textformfield_datetime_range_picker/blob/master/LICENSE
[pulls]: https://github.com/adampermana/textformfield_datetime_range_picker/pulls