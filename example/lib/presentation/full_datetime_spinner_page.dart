part of '../main.dart';

class FullDateTimeSpinnerPage extends StatefulWidget {
  const FullDateTimeSpinnerPage({super.key});

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
