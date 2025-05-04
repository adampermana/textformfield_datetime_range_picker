part of '../main.dart';

class TimeOnlyDropdownPage extends StatefulWidget {
  const TimeOnlyDropdownPage({super.key});

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
