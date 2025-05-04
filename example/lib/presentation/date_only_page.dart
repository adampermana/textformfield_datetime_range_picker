part of '../main.dart';

class DateOnlyPage extends StatefulWidget {
  const DateOnlyPage({super.key});

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
