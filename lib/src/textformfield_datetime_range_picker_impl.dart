// ignore_for_file: unused_element, depend_on_referenced_packages, no_logic_in_create_state

/*============================================================
 Module Name       : textformfield_datetime_range_picker.dart
 Date of Creation  : 2024-08-03
 Name of Creator   : Adam Permana
 History of Modifications:
 2024-08-03 - Initial creation of the TextFormFieldDateTimeRangePicker widget.
 2024-08-03 - Added support for different date-time selection modes: fullDateTime, timeOnly, dateOnly.
 2024-08-03 - Integrated CustomTimePicker for enhanced time selection experience.
 2025-05-05 - Converted from plugin to pure Dart package for improved maintainability.
 2025-05-05 - Updated to support iOS 18 SDK compatibility requirements.

 Summary           :
 This file contains a customizable Flutter widget for picking a range of dates and/or times.
 The `TextFormFieldDateTimeRangePicker` widget allows users to select a range of dates and times
 with different modes of selection: full date-time, time-only, and date-only. It supports various
 configurations such as initial date, minimum and maximum hours, custom icons, and titles.
 
 The widget includes an integrated CustomTimePicker for a spinner-based time selection experience.

 Functions         :
 - _buildFullDateTimeOption: Builds the UI for full date-time selection mode.
 - _buildTimeOnlyOption: Builds the UI for time-only selection mode.
 - _buildDateOnlyOption: Builds the UI for date-only selection mode.
 - _buildDateField: Creates a date picker field.
 - _buildTimeDropdown: Creates a time picker dropdown field.
 - _buildCustomTimePicker: Creates a custom spinner-based time picker.
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
 - useCustomTimePicker: Whether to use the CustomTimePicker instead of the default time picker.

 ============================================================*/

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:textformfield_datetime_range_picker/src/datetime_fields.dart';
import 'package:textformfield_datetime_range_picker/src/extension/extension_datetime.dart';
import 'package:textformfield_datetime_range_picker/src/time_picker.dart';

import '../textformfield_datetime_range_picker.dart';
import 'time_dropdown.dart';

class TextFormFieldDateTimeRangePicker extends StatefulWidget {
  /// A customizable date and time range picker widget for Flutter applications.
  ///
  /// The `TextFormFieldDateTimeRangePicker` allows users to select a range of dates and times.
  /// It supports three modes: full date-time, time-only, and date-only selection. This widget is useful
  /// for scenarios where you need users to specify a range of dates and/or times, such as booking systems,
  /// scheduling apps, or event management.
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
    this.timePickerStyle = TimePickerStyle.dropdown,
    this.minutesInterval = 1,
    this.secondsInterval = 1,
    this.isShowSeconds = false,
    this.is24HourMode = true,
    this.isForce2Digits = false,
    this.highlightedTextStyle,
    this.normalTextStyle,
    this.itemHeight,
    this.itemWidth,
    this.alignment,
    this.spacing,
    this.onTimeChange,
    // this.isWeb = false,
    ValueChanged<DateTimeRange>? onChanged,

    // Date Field Customization
    this.dateFieldFormat,
    this.dateFieldFirstDate,
    this.dateFieldValidator,
    this.dateFieldAutovalidateMode,
    this.dateFieldEnabled = true,
    this.dateFieldResetIcon = const Icon(Icons.close),
    this.dateFieldKeyboardType,
    this.dateFieldTextCapitalization = TextCapitalization.none,
    this.dateFieldTextInputAction,
    this.dateFieldStyle,
    this.dateFieldStrutStyle,
    this.dateFieldTextAlign = TextAlign.start,
    this.dateFieldAutofocus = false,
    this.dateFieldReadOnly = true,
    this.dateFieldShowCursor,
    this.dateFieldObscureText = false,
    this.dateFieldAutocorrect = true,
    this.dateFieldMaxLengthEnforcement = MaxLengthEnforcement.enforced,
    this.dateFieldMaxLines = 1,
    this.dateFieldMinLines,
    this.dateFieldExpands = false,
    this.dateFieldMaxLength,
    this.dateFieldOnEditingComplete,
    this.dateFieldOnFieldSubmitted,
    this.dateFieldInputFormatters,
    this.dateFieldCursorWidth = 2.0,
    this.dateFieldCursorRadius,
    this.dateFieldCursorColor,
    this.dateFieldKeyboardAppearance,
    this.dateFieldScrollPadding = const EdgeInsets.all(20.0),
    this.dateFieldEnableInteractiveSelection = true,
    this.dateFieldBuildCounter,
    this.dateFieldFilled = true,
    this.dateFieldFillColor = const Color.fromRGBO(16, 16, 26, 0.063),
    this.dateFieldContentPadding,
    this.dateFieldBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.dateFieldBorderSide = BorderSide.none,
    this.dateFieldHintStyle =
        const TextStyle(color: Colors.black54, fontSize: 14),
    this.dateFieldErrorStyle,
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

  /// The style of time picker to use (dropdown or spinner)
  final TimePickerStyle timePickerStyle;

  /// Interval between minute values (for CustomTimePicker)
  final int minutesInterval;

  /// Interval between second values (for CustomTimePicker)
  final int secondsInterval;

  /// Whether to show seconds selection (for CustomTimePicker)
  final bool isShowSeconds;

  /// Whether to use 24 hour mode (true) or 12 hour AM/PM mode (false) (for CustomTimePicker)
  final bool is24HourMode;

  /// Whether to force 2-digit display (e.g., "01" instead of "1") (for CustomTimePicker)
  final bool isForce2Digits;

  /// Text style for the highlighted (selected) time values (for CustomTimePicker)
  final TextStyle? highlightedTextStyle;

  /// Text style for non-selected time values (for CustomTimePicker)
  final TextStyle? normalTextStyle;

  /// Height of each item in the spinner (for CustomTimePicker)
  final double? itemHeight;

  /// Width of each spinner column (for CustomTimePicker)
  final double? itemWidth;

  /// Alignment of text within each spinner item (for CustomTimePicker)
  final AlignmentGeometry? alignment;

  /// Horizontal spacing between spinner components (for CustomTimePicker)
  final double? spacing;

  /// Callback function called when time changes (for CustomTimePicker)
  final TimePickerCallback? onTimeChange;

  /// Callback function when a single date-time is changed (for non-range mode).
  final ValueChanged<DateTime>? onDateTimeChanged;

  /// Callback function when the date-time range is changed.
  final ValueChanged<DateTimeRange>? onDateTimeRangeChanged;

  // Date Field Customization Options

  /// Date format for the date fields
  final DateFormat? dateFieldFormat;

  /// First selectable date in date pickers (defaults to current date)
  final DateTime? dateFieldFirstDate;

  /// Validator function for the date fields
  final String? Function(DateTime?)? dateFieldValidator;

  /// Auto-validate mode for the date fields
  final AutovalidateMode? dateFieldAutovalidateMode;

  /// Whether the date fields are enabled
  final bool dateFieldEnabled;

  /// Icon to reset/clear the date fields
  final Icon? dateFieldResetIcon;

  /// Keyboard type for the date fields
  final TextInputType? dateFieldKeyboardType;

  /// Text capitalization for the date fields
  final TextCapitalization dateFieldTextCapitalization;

  /// Text input action for the date fields
  final TextInputAction? dateFieldTextInputAction;

  /// Text style for the date fields
  final TextStyle? dateFieldStyle;

  /// Strut style for the date fields
  final StrutStyle? dateFieldStrutStyle;

  /// Text alignment for the date fields
  final TextAlign dateFieldTextAlign;

  /// Whether the date fields should autofocus
  final bool dateFieldAutofocus;

  /// Whether the date fields are read-only
  final bool dateFieldReadOnly;

  /// Whether to show the cursor in the date fields
  final bool? dateFieldShowCursor;

  /// Whether to obscure text in the date fields
  final bool dateFieldObscureText;

  /// Whether to enable autocorrect in the date fields
  final bool dateFieldAutocorrect;

  /// Maximum length enforcement for the date fields
  final MaxLengthEnforcement dateFieldMaxLengthEnforcement;

  /// Maximum number of lines for the date fields
  final int dateFieldMaxLines;

  /// Minimum number of lines for the date fields
  final int? dateFieldMinLines;

  /// Whether the date fields should expand to fill available space
  final bool dateFieldExpands;

  /// Maximum length for the date fields
  final int? dateFieldMaxLength;

  /// Callback when editing is complete in the date fields
  final VoidCallback? dateFieldOnEditingComplete;

  /// Callback when the date fields are submitted
  final void Function(DateTime?)? dateFieldOnFieldSubmitted;

  /// Input formatters for the date fields
  final List<TextInputFormatter>? dateFieldInputFormatters;

  /// Cursor width for the date fields
  final double dateFieldCursorWidth;

  /// Cursor radius for the date fields
  final Radius? dateFieldCursorRadius;

  /// Cursor color for the date fields
  final Color? dateFieldCursorColor;

  /// Keyboard appearance for the date fields
  final Brightness? dateFieldKeyboardAppearance;

  /// Scroll padding for the date fields
  final EdgeInsets dateFieldScrollPadding;

  /// Whether to enable interactive selection in the date fields
  final bool dateFieldEnableInteractiveSelection;

  /// Builder for the counter in the date fields
  final Widget? Function(BuildContext,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength})? dateFieldBuildCounter;

  /// Whether the date fields are filled
  final bool dateFieldFilled;

  /// Fill color for the date fields
  final Color? dateFieldFillColor;

  /// Content padding for the date fields
  final EdgeInsetsGeometry? dateFieldContentPadding;

  /// Border radius for the date fields
  final BorderRadius dateFieldBorderRadius;

  /// Border side for the date fields
  final BorderSide dateFieldBorderSide;

  /// Hint text style for the date fields
  final TextStyle dateFieldHintStyle;

  /// Error text style for the date fields
  final TextStyle? dateFieldErrorStyle;

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
            // Choose the time picker style based on the timePickerStyle property
            widget.timePickerStyle == TimePickerStyle.spinner
                ? _buildCustomTimePicker(
                    isStartTime: true,
                    title: widget.titleStartTime ?? const Text('Starting Hour'),
                  )
                : widget.timePickerStyle == TimePickerStyle.spinnerdropdown
                    ? _buildSpinnerDropdown(
                        time: startTime,
                        onTimeChanged: (val) {
                          setState(() {
                            startTime = val;
                            if (startDate!.isAtSameMomentAs(endDate!)) {
                              if (val.hour > endTime.hour ||
                                  (val.hour == endTime.hour &&
                                      val.minute >= endTime.minute)) {
                                endTime = endTime.replacing(
                                    minute: startTime.minute + 15);
                              }
                            }
                            dateTimeChanged();
                          });
                        },
                        title: widget.titleStartTime ??
                            const Text('Starting Hour'),
                      )
                    : _buildTimeDropdown(
                        time: startTime,
                        onTimeChanged: (val) {
                          setState(() {
                            startTime = val;
                            if (startDate!.isAtSameMomentAs(endDate!)) {
                              if (val.hour > endTime.hour ||
                                  (val.hour == endTime.hour &&
                                      val.minute >= endTime.minute)) {
                                endTime = endTime.replacing(
                                    minute: startTime.minute + 15);
                              }
                            }
                            dateTimeChanged();
                          });
                        },
                        title: widget.titleStartTime ??
                            const Text('Starting Hour'),
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
            // Choose the time picker style based on the timePickerStyle property
            widget.timePickerStyle == TimePickerStyle.spinner
                ? _buildCustomTimePicker(
                    isStartTime: false,
                    title: widget.titleEndTime ?? const Text('End Hour'),
                  )
                : widget.timePickerStyle == TimePickerStyle.spinnerdropdown
                    ? _buildSpinnerDropdown(
                        time: endTime,
                        onTimeChanged: (val) {
                          setState(() {
                            endTime = val;
                            if (startDate!.isAtSameMomentAs(endDate!)) {
                              if (endTime.hour < startTime.hour ||
                                  (endTime.hour == startTime.hour &&
                                      endTime.minute <= startTime.minute)) {
                                startTime = startTime.replacing(
                                    minute: endTime.minute - 15);
                              }
                            }
                            dateTimeChanged();
                          });
                        },
                        title: widget.titleEndTime ?? const Text('End Hour'),
                      )
                    : _buildTimeDropdown(
                        time: endTime,
                        onTimeChanged: (val) {
                          setState(() {
                            endTime = val;
                            if (startDate!.isAtSameMomentAs(endDate!)) {
                              if (endTime.hour < startTime.hour ||
                                  (endTime.hour == startTime.hour &&
                                      endTime.minute <= startTime.minute)) {
                                startTime = startTime.replacing(
                                    minute: endTime.minute - 15);
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
          child: widget.timePickerStyle == TimePickerStyle.spinner
              ? _buildCustomTimePicker(
                  isStartTime: true,
                  title: widget.titleStartTime ?? const Text('Start Time'),
                )
              : widget.timePickerStyle == TimePickerStyle.spinnerdropdown
                  ? _buildSpinnerDropdown(
                      time: startTime,
                      onTimeChanged: (val) {
                        setState(() {
                          startTime = val;
                          if (val.hour == endTime.hour &&
                              startTime.minute >= endTime.minute) {
                            endTime = endTime.replacing(
                                minute: startTime.minute + 15);
                          }
                          dateTimeChanged();
                        });
                      },
                      title: widget.titleStartTime ?? const Text('Start Time'),
                    )
                  : _buildTimeDropdown(
                      time: startTime,
                      onTimeChanged: (val) {
                        setState(() {
                          startTime = val;
                          if (val.hour == endTime.hour &&
                              startTime.minute >= endTime.minute) {
                            endTime = endTime.replacing(
                                minute: startTime.minute + 15);
                          }
                          dateTimeChanged();
                        });
                      },
                      title: widget.titleStartTime ?? const Text('Start Time'),
                    ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: widget.timePickerStyle == TimePickerStyle.spinner
              ? _buildCustomTimePicker(
                  isStartTime: false,
                  title: widget.titleEndTime ?? const Text('End Time'),
                )
              : widget.timePickerStyle == TimePickerStyle.spinnerdropdown
                  ? _buildSpinnerDropdown(
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
                    )
                  : _buildTimeDropdown(
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
    // Create the date format or use the provided one
    final dateFormat =
        widget.dateFieldFormat ?? DateFormat('EEE, dd MMMM yyyy');

    // Create the input decoration
    final decoration = InputDecoration(
      filled: widget.dateFieldFilled,
      fillColor: widget.dateFieldFillColor,
      hintText: hintTextDate,
      hintStyle: widget.dateFieldHintStyle,
      errorStyle: widget.dateFieldErrorStyle,
      contentPadding: widget.dateFieldContentPadding,
      suffixIcon: widget.suffixIconDate ??
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.red,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: widget.dateFieldBorderSide,
        borderRadius: widget.dateFieldBorderRadius,
      ),
    );

    return DateTimeFields(
      controller: controller,
      format: dateFormat,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: widget.dateFieldFirstDate ?? today,
          initialDate: currentValue ?? today,
          lastDate: widget.lastDate ?? DateTime(2050),
        );
      },
      decoration: decoration,
      onChanged: (date) {
        if (date != null) {
          controller.text = dateFormat.format(date);
        } else {
          controller.clear();
        }
        onChanged(date);
      },

      // Pass through all customization options
      style: widget.dateFieldStyle ??
          const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      keyboardType: widget.dateFieldKeyboardType,
      textCapitalization: widget.dateFieldTextCapitalization,
      textInputAction: widget.dateFieldTextInputAction,
      strutStyle: widget.dateFieldStrutStyle,
      textAlign: widget.dateFieldTextAlign,
      autofocus: widget.dateFieldAutofocus,
      readOnly: widget.dateFieldReadOnly,
      showCursor: widget.dateFieldShowCursor,
      obscureText: widget.dateFieldObscureText,
      autocorrect: widget.dateFieldAutocorrect,
      maxLengthEnforcement: widget.dateFieldMaxLengthEnforcement,
      maxLines: widget.dateFieldMaxLines,
      minLines: widget.dateFieldMinLines,
      expands: widget.dateFieldExpands,
      maxLength: widget.dateFieldMaxLength,
      onEditingComplete: widget.dateFieldOnEditingComplete,
      onFieldSubmitted: widget.dateFieldOnFieldSubmitted,
      inputFormatters: widget.dateFieldInputFormatters,
      cursorWidth: widget.dateFieldCursorWidth,
      cursorRadius: widget.dateFieldCursorRadius,
      cursorColor: widget.dateFieldCursorColor,
      keyboardAppearance: widget.dateFieldKeyboardAppearance,
      scrollPadding: widget.dateFieldScrollPadding,
      enableInteractiveSelection: widget.dateFieldEnableInteractiveSelection,
      buildCounter: widget.dateFieldBuildCounter,
      validator: widget.dateFieldValidator,
      autovalidateMode: widget.dateFieldAutovalidateMode,
      enabled: widget.dateFieldEnabled,
      resetIcon: widget.dateFieldResetIcon,
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
          is24HourMode: widget.is24HourMode, // Pass the 24-hour mode preference
          onTimeChanged: onTimeChanged,
          boxDecoration: BoxDecoration(
            color: widget.dateFieldFillColor,
            borderRadius: widget.dateFieldBorderRadius,
          ),
          textStyle: widget.dateFieldStyle ??
              const TextStyle(
                color: Colors.black87,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }

  Widget _buildCustomTimePicker({
    required bool isStartTime,
    required Widget title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 5),
        CustomTimePicker(
          time: isStartTime
              ? startDate?.copyWith(
                  hour: startTime.hour,
                  minute: startTime.minute,
                )
              : endDate?.copyWith(
                  hour: endTime.hour,
                  minute: endTime.minute,
                ),
          minutesInterval: widget.minutesInterval,
          secondsInterval: widget.secondsInterval,
          is24HourMode: widget.is24HourMode,
          isShowSeconds: widget.isShowSeconds,
          highlightedTextStyle: widget.highlightedTextStyle,
          normalTextStyle: widget.normalTextStyle,
          itemHeight: widget.itemHeight,
          itemWidth: widget.itemWidth,
          alignment: widget.alignment,
          spacing: widget.spacing,
          isForce2Digits: widget.isForce2Digits,
          // isWeb: widget.isWeb,
          onTimeChange: (dateTime) {
            if (isStartTime) {
              setState(() {
                startTime = TimeOfDay(
                  hour: dateTime.hour,
                  minute: dateTime.minute,
                );

                // Ensure end time is after start time if same day
                if (startDate!.isAtSameMomentAs(endDate!)) {
                  if (startTime.hour > endTime.hour ||
                      (startTime.hour == endTime.hour &&
                          startTime.minute >= endTime.minute)) {
                    endTime = TimeOfDay(
                      hour: startTime.hour,
                      minute: min(59, startTime.minute + 15),
                    );
                  }
                }

                dateTimeChanged();
              });
            } else {
              setState(() {
                endTime = TimeOfDay(
                  hour: dateTime.hour,
                  minute: dateTime.minute,
                );

                // Ensure start time is before end time if same day
                if (startDate!.isAtSameMomentAs(endDate!)) {
                  if (endTime.hour < startTime.hour ||
                      (endTime.hour == startTime.hour &&
                          endTime.minute <= startTime.minute)) {
                    startTime = TimeOfDay(
                      hour: endTime.hour,
                      minute: max(0, endTime.minute - 15),
                    );
                  }
                }

                dateTimeChanged();
              });
            }

            // Call the onTimeChange callback if provided
            if (widget.onTimeChange != null) {
              widget.onTimeChange!(dateTime);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSpinnerDropdown({
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onTimeChanged,
    required Widget title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            // Show a dialog with the spinner when clicked
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // Create a copy of the time to track changes within the dialog
                TimeOfDay selectedTime = time;

                return AlertDialog(
                  title: title,
                  content: SizedBox(
                    height: (_getItemHeight() ?? 180) * 1.5,
                    width: (_getItemWidth() ?? 200) *
                        (widget.is24HourMode
                            ? 2.0
                            : 3.0), // Wider for AM/PM mode
                    child: CustomTimePicker(
                      time: DateTime(
                        today.year,
                        today.month,
                        today.day,
                        time.hour,
                        time.minute,
                      ),
                      minutesInterval: widget.minutesInterval,
                      secondsInterval: widget.secondsInterval,
                      is24HourMode: widget
                          .is24HourMode, // Pass through the format preference
                      isShowSeconds: widget.isShowSeconds,
                      highlightedTextStyle: widget.highlightedTextStyle,
                      normalTextStyle: widget.normalTextStyle,
                      itemHeight: widget.itemHeight,
                      itemWidth: widget.itemWidth,
                      alignment: widget.alignment,
                      spacing: widget.spacing,
                      isForce2Digits: widget.isForce2Digits,
                      onTimeChange: (dateTime) {
                        selectedTime = TimeOfDay(
                          hour: dateTime.hour,
                          minute: dateTime.minute,
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(widget.buttonCancelTime ?? 'Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(widget.buttonSubmitTime ?? 'OK'),
                      onPressed: () {
                        onTimeChanged(selectedTime);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: widget.dateFieldFillColor,
              borderRadius: widget.dateFieldBorderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // Format time according to the current format mode
                  widget.is24HourMode
                      ? DateFormat('HH:mm')
                          .format(DateTime(2023, 1, 1, time.hour, time.minute))
                      : time.format(context),
                  style: widget.dateFieldStyle ??
                      const TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(width: 4),
                widget.suffixIconTime ??
                    const Icon(
                      Icons.access_time,
                      color: Colors.blue,
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Helper methods to get item dimensions from widget parameters
  double? _getItemHeight() => widget.itemHeight;
  double? _getItemWidth() => widget.itemWidth;
}
