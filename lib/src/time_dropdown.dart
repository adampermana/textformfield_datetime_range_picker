import 'package:flutter/material.dart';

class TimeDropdownNew extends StatelessWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;
  final Icon? icon;
  final String? cancelText;
  final String? confirmText;
  final bool is24HourMode; // Added this parameter for format control

  const TimeDropdownNew({
    super.key,
    required this.time,
    this.onTimeChanged,
    required this.boxDecoration,
    required this.textStyle,
    this.cancelText,
    this.confirmText,
    this.icon,
    this.is24HourMode =
        false, // Default to 12-hour format for backward compatibility
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
      cancelText: cancelText ?? 'Cancel',
      confirmText: confirmText ?? 'Confirm',
      builder: (BuildContext context, Widget? child) {
        // Apply the selected time format to the picker
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: is24HourMode,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != time) {
      onTimeChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the time according to the selected mode
    String timeText;
    if (is24HourMode) {
      // Use 24-hour format (HH:mm)
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      timeText = '$hours:$minutes';
    } else {
      // Use 12-hour format with AM/PM
      timeText = time.format(context);
    }

    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        decoration: boxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              timeText,
              style: textStyle,
            ),
            icon ??
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.red,
                ),
          ],
        ),
      ),
    );
  }
}
