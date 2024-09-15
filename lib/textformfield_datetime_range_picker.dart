// ignore_for_file: unused_element, depend_on_referenced_packages, no_logic_in_create_state

/*============================================================
 Module Name       : textformfield_datetime_range_picker.dart
 Date of Creation  : 2024-08-03
 Name of Creator   : Adam Permana
 History of Modifications:
 2024-08-03 - Initial creation of the TextFormFieldDateTimeRangePicker widget.
 2024-08-03 - Added support for different date-time selection modes: fullDateTime, timeOnly, dateOnly.

 Summary           :
 This file contains a customizable Flutter widget for picking a range of dates and/or times.
 The `TextFormFieldDateTimeRangePicker` widget allows users to select a range of dates and times
 with different modes of selection: full date-time, time-only, and date-only. It supports various
 configurations such as initial date, minimum and maximum hours, custom icons, and titles.

 Functions         :
 - _buildFullDateTimeOption: Builds the UI for full date-time selection mode.
 - _buildTimeOnlyOption: Builds the UI for time-only selection mode.
 - _buildDateOnlyOption: Builds the UI for date-only selection mode.
 - _buildDateField: Creates a date picker field.
 - _buildTimeDropdown: Creates a time picker dropdown field.
 - changeCurrMonth: Updates the current month for the calendar view.
 - dateTimeChanged: Handles changes to the selected date and time range.

 Variables         :
 - today: The current date and time.
 - date2: The date one day after today.
 - maxhour: The maximum hour value for the time picker.
 - hours: A list of available hours for selection.
 - currMonth: The currently displayed month for the calendar view.
 - daysInMonth: The number of days in the current month.
 - firstDayOffset: The offset for the first day of the month.
 - disableDayUntil: The day until which dates are disabled in the calendar.
 - startTime: The selected start time.
 - endTime: The selected end time.
 - _startDateController: Controller for the start date text field.
 - _endDateController: Controller for the end date text field.
 - startDate: The selected start date.
 - endDate: The selected end date.

 ============================================================*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textformfield_datetime_range_picker/src/datetime_range.dart';
import 'package:textformfield_datetime_range_picker/src/extension/extension_datetime.dart';

/// - [DateTimeOption.fullDateTime]: Shows date and time pickers for both start and end.
/// - [DateTimeOption.timeOnly]: Shows only time pickers for start and end times.
/// - [DateTimeOption.dateOnly]: Shows only date pickers for start and end dates.
///
enum DateTimeOption { fullDateTime, timeOnly, dateOnly }

class TextFormFieldDateTimeRangePicker extends StatefulWidget {
  /// A customizable date and time range picker widget for Flutter applications.
  ///
  /// The `TextFormFieldDateTimeRangePicker` allows users to select a range of dates and times.
  /// It supports three modes: full date-time, time-only, and date-only selection. This widget is useful
  /// for scenarios where you need users to specify a range of dates and/or times, such as booking systems,
  /// scheduling apps, or event management.
  ///
  /// Example usage:
  /// ```dart
  /// TextFormFieldDateTimeRangePicker(
  ///               selectedOption: DateTimeOption.fullDateTime,
  ///               initialDate: dateTtime,
  ///               hintTextDate: 'Select Date',
  ///               hintTextTime: 'Select Time',
  ///               onChanged: (date) {
  ///                 setState(() {
  ///                   dateTtime = date.start;
  ///                   dateTtime = date.end;
  ///                 });
  ///               },
  ///             ),
  ///
  /// example usage Bloc:
  /// TextFormFieldDateTimeRangePicker(
  ///   selectedOption: DateTimeOption.fullDateTime
  ///   initialDate: state.dateTime ?? DateTime.now(),
  ///   hintTextDate: 'Select Date',
  ///   onChanged: (date) {
  ///     context.read<SecurityFormBloc>().add(
  ///           SecurityFormEvent.dateTimeChanged(
  ///             dateTime: date.start,
  ///             endTime: date.end,
  ///           ),
  ///         );
  ///   },
  /// ),
  /// ```
  const TextFormFieldDateTimeRangePicker({
    super.key,
    required this.selectedOption,
    this.minHour = 0,
    this.maxHour = 18,
    int? initialStartHour,
    int? initialEndHour,
    this.suffixIconDate,
    this.suffixIconTime,
    this.initialDate,
    this.lastDate,
    this.titleStartdate,
    this.titleEndDate,
    this.titleStartTime,
    this.titleEndTime,
    this.hintTextDate,
    this.hintTextTime,
    this.buttonCancelTime,
    this.buttonSubmitTime,
    ValueChanged<DateTimeRange>? onChanged,
  })  : assert(minHour < maxHour && (maxHour - minHour >= 1)),
        initialStartHour = initialStartHour ?? minHour,
        initialEndHour = initialEndHour ?? maxHour,
        onDateTimeChanged = null,
        onDateTimeRangeChanged = onChanged,
        ranged = true;

  /// The mode of date-time selection.
  final DateTimeOption selectedOption;

  /// Whether the picker should allow range selection.
  final bool ranged;

  /// The minimum selectable hour (0-23).
  final int minHour;

  /// The maximum selectable hour (0-23).
  final int maxHour;

  /// The initial hour for the start time.
  final int initialStartHour;

  /// The initial hour for the end time.
  final int initialEndHour;

  /// The initial date to display when the picker is first shown.
  final DateTime? initialDate;

  /// The latest selectable date.
  final DateTime? lastDate;

  /// Custom icon for the date picker fields.
  final Icon? suffixIconDate;

  /// Custom icon for the time picker fields.
  final Icon? suffixIconTime;

  /// Custom title for the start date field.
  final Text? titleStartdate;

  /// Custom title for the end date field.
  final Text? titleEndDate;

  /// Custom title for the start time field.
  final Text? titleStartTime;

  /// Custom title for the end time field.
  final Text? titleEndTime;

  /// Hint text for date fields.
  final String? hintTextDate;

  /// Hint text for time fields.
  final String? hintTextTime;

  /// Custom text for the cancel button in time picker.
  final String? buttonCancelTime;

  /// Custom text for the submit button in time picker.
  final String? buttonSubmitTime;

  /// Callback function when a single date-time is changed (for non-range mode).
  final ValueChanged<DateTime>? onDateTimeChanged;

  /// Callback function when the date-time range is changed.
  final ValueChanged<DateTimeRange>? onDateTimeRangeChanged;

  @override
  State<TextFormFieldDateTimeRangePicker> createState() =>
      _TextFormFieldDateTimeRangePickerState(maxHour);
}

class _TextFormFieldDateTimeRangePickerState
    extends State<TextFormFieldDateTimeRangePicker> {
  static const _textStyle = TextStyle(
    color: Color(0xFF292929),
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
  );

  late final DateTime today;
  late final DateTime date2;
  final int maxhour;
  late List<int> hours;
  late DateTime currMonth;
  late int daysInMonth;
  late int firstDayOffset;
  late int disableDayUntil;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  DateTime? startDate;
  DateTime? endDate;

  _TextFormFieldDateTimeRangePickerState(this.maxhour);

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

    today = DateTime.now();
    date2 = DateTime.now().add(const Duration(days: 1));
    hours = List.generate(
      1 + widget.maxHour - widget.minHour,
      (i) => i + widget.minHour,
    );

    startDate = widget.initialDate ?? today;
    endDate = widget.initialDate ?? today;
    startTime = TimeOfDay(hour: today.hour, minute: today.minute);
    endTime = TimeOfDay(hour: widget.initialEndHour, minute: 0);

    changeCurrMonth(startDate!, init: true);
  }

  @override
  void didUpdateWidget(covariant TextFormFieldDateTimeRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minHour != widget.minHour ||
        oldWidget.maxHour != widget.maxHour) {
      hours = List.generate(
        1 + widget.maxHour - widget.minHour,
        (i) => i + widget.minHour,
      );
    }
  }

  void changeCurrMonth(DateTime currentMonth, {bool init = false}) {
    currMonth = currentMonth;
    daysInMonth = currentMonth.daysInMonth;
    firstDayOffset = (currentMonth.copyWith(day: 1).weekday % 7);
    disableDayUntil = (currentMonth.isSameMonth(today)
        ? today.day
        : (currentMonth.isBefore(today) ? 32 : 0));

    if (!init) {
      setState(() {});
    }
  }

  void dateTimeChanged() {
    if (startDate != null && endDate != null) {
      if (startDate!.isAfter(endDate!)) {
        setState(() {
          endDate = startDate;
        });
      }

      if (startDate!.isAtSameMomentAs(endDate!)) {
        if (startTime.hour > endTime.hour ||
            (startTime.hour == endTime.hour &&
                startTime.minute >= endTime.minute)) {
          setState(() {
            endTime = startTime.replacing(minute: startTime.minute + 15);
          });
        }
      }

      if (widget.onDateTimeRangeChanged != null) {
        widget.onDateTimeRangeChanged!(
          DateTimeRange(
            start: startDate!.copyWith(
              hour: startTime.hour,
              minute: startTime.minute,
            ),
            end: endDate!.copyWith(
              hour: endTime.hour,
              minute: endTime.minute,
            ),
          ),
        );
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: _textStyle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.selectedOption == DateTimeOption.fullDateTime) ...[
            _buildFullDateTimeOption(),
          ] else if (widget.selectedOption == DateTimeOption.timeOnly) ...[
            _buildTimeOnlyOption(),
          ] else if (widget.selectedOption == DateTimeOption.dateOnly) ...[
            _buildDateOnlyOption(),
          ],
        ],
      ),
    );
  }

  Widget _buildFullDateTimeOption() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.titleStartdate ?? const Text('Start Date'),
                  const SizedBox(height: 5),
                  _buildDateField(
                    initialValue: startDate,
                    controller: _startDateController,
                    hintTextDate: widget.hintTextDate ?? 'Select Date',
                    onChanged: (value) {
                      setState(() {
                        startDate = value;
                        if (startDate != null &&
                            (endDate == null || startDate!.isAfter(endDate!))) {
                          endDate = startDate;
                          _endDateController.text = _startDateController.text;
                        }
                        dateTimeChanged();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildTimeDropdown(
              time: startTime,
              onTimeChanged: (val) {
                setState(() {
                  startTime = val;
                  if (startDate!.isAtSameMomentAs(endDate!)) {
                    if (val.hour > endTime.hour ||
                        (val.hour == endTime.hour &&
                            val.minute >= endTime.minute)) {
                      endTime =
                          endTime.replacing(minute: startTime.minute + 15);
                    }
                  }
                  dateTimeChanged();
                });
              },
              title: widget.titleStartTime ?? const Text('Starting Hour'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.titleEndDate ?? const Text('End Date'),
                  const SizedBox(height: 5),
                  _buildDateField(
                    initialValue: endDate,
                    hintTextDate: widget.hintTextDate ?? 'Select Date',
                    controller: _endDateController,
                    onChanged: (value) {
                      setState(() {
                        endDate = value;
                        if (endDate != null) {
                          if (startDate == null ||
                              endDate!.isBefore(startDate!)) {
                            startDate = endDate;
                            _startDateController.text = _endDateController.text;
                          }
                        }
                        dateTimeChanged();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildTimeDropdown(
              time: endTime,
              onTimeChanged: (val) {
                setState(() {
                  endTime = val;
                  if (startDate!.isAtSameMomentAs(endDate!)) {
                    if (endTime.hour < startTime.hour ||
                        (endTime.hour == startTime.hour &&
                            endTime.minute <= startTime.minute)) {
                      startTime =
                          startTime.replacing(minute: endTime.minute - 15);
                    }
                  }
                  dateTimeChanged();
                });
              },
              title: widget.titleEndTime ?? const Text('End Hour'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeOnlyOption() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeDropdown(
            time: startTime,
            onTimeChanged: (val) {
              setState(() {
                startTime = val;
                if (val.hour == endTime.hour &&
                    startTime.minute >= endTime.minute) {
                  endTime = endTime.replacing(minute: startTime.minute + 15);
                }
                dateTimeChanged();
              });
            },
            title: widget.titleStartTime ?? const Text('Start Time'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTimeDropdown(
            time: endTime,
            onTimeChanged: (val) {
              setState(() {
                endTime = val;
                if (endTime.hour == startTime.hour &&
                    endTime.minute <= startTime.minute) {
                  startTime = startTime.replacing(
                    minute: endTime.minute - 15,
                  );
                }
                dateTimeChanged();
              });
            },
            title: widget.titleEndTime ?? const Text('End Time'),
          ),
        ),
      ],
    );
  }

  Widget _buildDateOnlyOption() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.titleStartdate ?? const Text('Start Date'),
                  const SizedBox(height: 5),
                  _buildDateField(
                    initialValue: startDate,
                    controller: _startDateController,
                    hintTextDate: widget.hintTextDate ?? 'Select Date',
                    onChanged: (value) {
                      setState(() {
                        startDate = value;
                        if (startDate != null &&
                            (endDate == null || startDate!.isAfter(endDate!))) {
                          endDate = startDate;
                          _endDateController.text = _startDateController.text;
                        }
                        dateTimeChanged();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.titleEndDate ?? const Text('End Date'),
                  const SizedBox(height: 5),
                  _buildDateField(
                    initialValue: endDate,
                    controller: _endDateController,
                    hintTextDate: widget.hintTextDate ?? 'Select Date',
                    onChanged: (value) {
                      setState(() {
                        endDate = value;
                        if (endDate != null) {
                          if (startDate == null ||
                              endDate!.isBefore(startDate!)) {
                            startDate = endDate;
                            _startDateController.text = _endDateController.text;
                          }
                        }
                        dateTimeChanged();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required DateTime? initialValue,
    required ValueChanged<DateTime?> onChanged,
    required String? hintTextDate,
    required TextEditingController controller,
  }) {
    return DateTimeFields(
      controller: controller,
      format: DateFormat('EEE, dd MMMM yyyy'),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: today,
          initialDate: currentValue ?? today,
          lastDate: widget.lastDate ?? DateTime(2050),
        );
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(16, 16, 26, 0.063),
        hintText: hintTextDate,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        suffixIcon: widget.suffixIconDate ??
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.red,
            ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onChanged: (date) {
        if (date != null) {
          controller.text = DateFormat('EEE, dd MMMM yyyy').format(date);
        } else {
          controller.clear();
        }
        onChanged(date);
      },
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    );
  }

  Widget _buildTimeDropdown({
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onTimeChanged,
    required Widget title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 5),
        TimeDropdownNew(
          time: time,
          confirmText: widget.buttonSubmitTime ?? 'Submit',
          cancelText: widget.buttonCancelTime ?? 'Cancel',
          icon: widget.suffixIconTime,
          onTimeChanged: onTimeChanged,
          boxDecoration: const BoxDecoration(
            color: Color.fromRGBO(16, 16, 26, 0.063),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class TimeDropdownNew extends StatelessWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;
  final Icon? icon;
  final String? cancelText;
  final String? confirmText;

  const TimeDropdownNew({
    super.key,
    required this.time,
    this.onTimeChanged,
    required this.boxDecoration,
    required this.textStyle,
    this.cancelText,
    this.confirmText,
    this.icon,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
      cancelText: cancelText ?? 'Cancel',
      confirmText: confirmText ?? 'Confirm',
    );
    if (picked != null && picked != time) {
      onTimeChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        decoration: boxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time.format(context),
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
