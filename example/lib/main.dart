import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DateTime Range Picker Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/full_datetime_dropdown': (context) =>
            const FullDateTimeDropdownPage(),
        '/full_datetime_spinner': (context) => const FullDateTimeSpinnerPage(),
        '/time_only_dropdown': (context) => const TimeOnlyDropdownPage(),
        '/time_only_spinner': (context) => const TimeOnlySpinnerPage(),
        '/date_only': (context) => const DateOnlyPage(),
        '/customized': (context) => const CustomizedPickerPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DateTime Range Picker Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeatureCard(
            context,
            title: 'Full DateTime (Dropdown)',
            description: 'Select date and time with dropdown time picker',
            route: '/full_datetime_dropdown',
          ),
          _buildFeatureCard(
            context,
            title: 'Full DateTime (Spinner)',
            description: 'Select date and time with spinner time picker',
            route: '/full_datetime_spinner',
          ),
          _buildFeatureCard(
            context,
            title: 'Time Only (Dropdown)',
            description: 'Select only time with dropdown time picker',
            route: '/time_only_dropdown',
          ),
          _buildFeatureCard(
            context,
            title: 'Time Only (Spinner)',
            description: 'Select only time with spinner time picker',
            route: '/time_only_spinner',
          ),
          _buildFeatureCard(
            context,
            title: 'Date Only',
            description: 'Select only date range',
            route: '/date_only',
          ),
          _buildFeatureCard(
            context,
            title: 'Fully Customized',
            description: 'Spinner with custom styling, intervals, seconds',
            route: '/customized',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(description),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullDateTimeDropdownPage extends StatefulWidget {
  const FullDateTimeDropdownPage({Key? key}) : super(key: key);

  @override
  State<FullDateTimeDropdownPage> createState() =>
      _FullDateTimeDropdownPageState();
}

class _FullDateTimeDropdownPageState extends State<FullDateTimeDropdownPage> {
  DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full DateTime (Dropdown)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a date and time range using the dropdown time picker:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.fullDateTime,
              timePickerStyle: TimePickerStyle.dropdown,
              initialDate: DateTime.now(),
              hintTextDate: 'Select Date',
              hintTextTime: 'Select Time',
              is24HourMode: true,
              titleStartdate: const Text('Start Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleEndDate: const Text('End Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleStartTime: const Text('Start Time',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleEndTime: const Text('End Time',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onChanged: (range) {
                setState(() {
                  selectedRange = range;
                });
              },
            ),
            const SizedBox(height: 32.0),
            if (selectedRange != null) ...[
              const Text(
                'Selected Range:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Start: ${DateFormat('EEE, dd MMM yyyy - hh:mm a').format(selectedRange!.start)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'End: ${DateFormat('EEE, dd MMM yyyy - hh:mm a').format(selectedRange!.end)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Duration: ${_formatDuration(selectedRange!.duration)}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');

    return parts.join(', ');
  }
}

class FullDateTimeSpinnerPage extends StatefulWidget {
  const FullDateTimeSpinnerPage({Key? key}) : super(key: key);

  @override
  State<FullDateTimeSpinnerPage> createState() =>
      _FullDateTimeSpinnerPageState();
}

class _FullDateTimeSpinnerPageState extends State<FullDateTimeSpinnerPage> {
  DateTimeRange? selectedRange;
  DateTime? lastTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full DateTime (Spinner)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a date and time range using the spinner time picker:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.fullDateTime,
              timePickerStyle: TimePickerStyle.spinnerdropdown,
              initialDate: DateTime.now(),
              hintTextDate: 'Select Date',
              titleStartdate: const Text('Start Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleEndDate: const Text('End Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleStartTime: const Text('Start Time',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleEndTime: const Text('End Time',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              minutesInterval: 5, // Set minutes to increment by 5
              is24HourMode: true, // Use 24-hour format
              onTimeChange: (dateTime) {
                setState(() {
                  lastTimeChanged = dateTime;
                });
              },
              onChanged: (range) {
                setState(() {
                  selectedRange = range;
                });
              },
            ),
            const SizedBox(height: 32.0),
            if (selectedRange != null) ...[
              const Text(
                'Selected Range:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Start: ${DateFormat('EEE, dd MMM yyyy - HH:mm').format(selectedRange!.start)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'End: ${DateFormat('EEE, dd MMM yyyy - HH:mm').format(selectedRange!.end)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Duration: ${_formatDuration(selectedRange!.duration)}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
            if (lastTimeChanged != null) ...[
              const SizedBox(height: 16.0),
              const Text(
                'Last Time Changed:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                DateFormat('HH:mm').format(lastTimeChanged!),
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');

    return parts.join(', ');
  }
}

class TimeOnlyDropdownPage extends StatefulWidget {
  const TimeOnlyDropdownPage({Key? key}) : super(key: key);

  @override
  State<TimeOnlyDropdownPage> createState() => _TimeOnlyDropdownPageState();
}

class _TimeOnlyDropdownPageState extends State<TimeOnlyDropdownPage> {
  DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Only (Dropdown)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a time range using the dropdown time picker:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.timeOnly,
              timePickerStyle: TimePickerStyle.dropdown,
              initialDate: DateTime.now(),
              titleStartTime: const Text('Start Time',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleEndTime: const Text('End Time',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              suffixIconTime: const Icon(Icons.access_time, color: Colors.blue),
              buttonSubmitTime: 'OK',
              buttonCancelTime: 'Cancel',
              is24HourMode: true,
              onChanged: (range) {
                setState(() {
                  selectedRange = range;
                });
              },
            ),
            const SizedBox(height: 32.0),
            if (selectedRange != null) ...[
              const Text(
                'Selected Time Range:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Start: ${DateFormat('hh:mm a').format(selectedRange!.start)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'End: ${DateFormat('hh:mm a').format(selectedRange!.end)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Duration: ${_formatDuration(selectedRange!.duration)}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];
    if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');

    return parts.join(', ');
  }
}

class TimeOnlySpinnerPage extends StatefulWidget {
  const TimeOnlySpinnerPage({Key? key}) : super(key: key);

  @override
  State<TimeOnlySpinnerPage> createState() => _TimeOnlySpinnerPageState();
}

class _TimeOnlySpinnerPageState extends State<TimeOnlySpinnerPage> {
  DateTimeRange? selectedRange;
  DateTime? lastTimeChanged;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    // final isWebPlatform = Theme.of(context).platform == TargetPlatform.;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Only (Spinner)'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a time range using the spinner time picker:',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),

              // Time picker controls - using a fixed height container
              Row(
                children: [
                  // CustomTimePicker wrapped within TextFormFieldDateTimeRangePicker
                  Expanded(
                    child: TextFormFieldDateTimeRangePicker(
                      selectedOption: DateTimeOption.timeOnly,
                      timePickerStyle: TimePickerStyle.spinnerdropdown,
                      initialDate: DateTime.now(),
                      titleStartTime: const Text('Start Time',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      titleEndTime: const Text('End Time',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      minutesInterval: 15, // 15-minute intervals
                      is24HourMode: true, // 12-hour format with AM/PM
                      // Responsive dimensions
                      itemWidth:
                          screenWidth < 1000 ? screenWidth * 0.11 : 100.0,
                      itemHeight: 40.0,
                      spacing: 5.0,
                      // Styling
                      highlightedTextStyle: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      normalTextStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                      // Callbacks
                      onTimeChange: (dateTime) {
                        setState(() {
                          lastTimeChanged = dateTime;
                        });
                      },
                      onChanged: (range) {
                        setState(() {
                          selectedRange = range;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),

              // Results section
              if (selectedRange != null) ...[
                const Text(
                  'Selected Time Range:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Start: ${DateFormat('h:mm a').format(selectedRange!.start)}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'End: ${DateFormat('h:mm a').format(selectedRange!.end)}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Duration: ${_formatDuration(selectedRange!.duration)}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],

              if (lastTimeChanged != null) ...[
                const SizedBox(height: 16.0),
                const Text(
                  'Last Time Changed:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  DateFormat('h:mm a').format(lastTimeChanged!),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];
    if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');

    return parts.join(', ');
  }
}

class DateOnlyPage extends StatefulWidget {
  const DateOnlyPage({Key? key}) : super(key: key);

  @override
  State<DateOnlyPage> createState() => _DateOnlyPageState();
}

class _DateOnlyPageState extends State<DateOnlyPage> {
  DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Only'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a date range:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.dateOnly,
              initialDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              hintTextDate: 'Select Date',
              titleStartdate: const Text('Start Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              titleEndDate: const Text('End Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              suffixIconDate:
                  const Icon(Icons.calendar_today, color: Colors.blue),
              onChanged: (range) {
                setState(() {
                  selectedRange = range;
                });
              },
            ),
            const SizedBox(height: 32.0),
            if (selectedRange != null) ...[
              const Text(
                'Selected Date Range:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Start: ${DateFormat('EEE, dd MMM yyyy').format(selectedRange!.start)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'End: ${DateFormat('EEE, dd MMM yyyy').format(selectedRange!.end)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Duration: ${_formatDuration(selectedRange!.duration)}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;

    return '$days day${days > 1 ? 's' : ''}';
  }
}

class CustomizedPickerPage extends StatefulWidget {
  const CustomizedPickerPage({Key? key}) : super(key: key);

  @override
  State<CustomizedPickerPage> createState() => _CustomizedPickerPageState();
}

class _CustomizedPickerPageState extends State<CustomizedPickerPage> {
  DateTimeRange? selectedRange;
  DateTime? lastTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fully Customized Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This demonstrates a highly customized picker with:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text('• Custom styling for the spinners'),
            const Text('• Seconds selection enabled'),
            const Text('• 10-minute intervals'),
            const Text('• 2-digit time display (e.g., "01" instead of "1")'),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextFormFieldDateTimeRangePicker(
                selectedOption: DateTimeOption.fullDateTime,
                timePickerStyle: TimePickerStyle.spinner,
                initialDate: DateTime.now(),
                hintTextDate: 'Select Date',
                titleStartdate: Text('START DATE',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        letterSpacing: 1)),
                titleEndDate: Text('END DATE',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        letterSpacing: 1)),
                titleStartTime: Text('START TIME',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        letterSpacing: 1)),
                titleEndTime: Text('END TIME',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        letterSpacing: 1)),
                suffixIconDate: Icon(Icons.event, color: Colors.blue.shade700),
                minutesInterval: 10, // 10-minute intervals
                secondsInterval: 15, // 15-second intervals
                isShowSeconds: true, // Show seconds
                is24HourMode: true, // 24-hour format
                isForce2Digits: true, // Force 2-digit display (01 instead of 1)
                highlightedTextStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
                normalTextStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey.shade600,
                ),
                itemHeight: 50, // Smaller item height
                itemWidth: 40, // Smaller item width
                spacing: 10, // Less spacing between components
                onTimeChange: (dateTime) {
                  setState(() {
                    lastTimeChanged = dateTime;
                  });
                },
                onChanged: (range) {
                  setState(() {
                    selectedRange = range;
                  });
                },
              ),
            ),
            const SizedBox(height: 32.0),
            if (selectedRange != null) ...[
              const Text(
                'Selected Range:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Start: ${DateFormat('EEE, dd MMM yyyy - HH:mm:ss').format(selectedRange!.start)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'End: ${DateFormat('EEE, dd MMM yyyy - HH:mm:ss').format(selectedRange!.end)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Duration: ${_formatDuration(selectedRange!.duration)}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
            if (lastTimeChanged != null) ...[
              const SizedBox(height: 16.0),
              const Text(
                'Last Time Changed:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                DateFormat('HH:mm:ss').format(lastTimeChanged!),
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');
    if (seconds > 0) parts.add('$seconds second${seconds > 1 ? 's' : ''}');

    return parts.join(', ');
  }
}
