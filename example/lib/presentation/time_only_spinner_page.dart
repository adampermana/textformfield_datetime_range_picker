part of '../main.dart';

class TimeOnlySpinnerPage extends StatefulWidget {
  const TimeOnlySpinnerPage({super.key});

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
