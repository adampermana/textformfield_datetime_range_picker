part of '../main.dart';

class CustomizedPickerPage extends StatefulWidget {
  const CustomizedPickerPage({super.key});

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
