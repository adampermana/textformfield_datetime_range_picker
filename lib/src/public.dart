// Forward the implementation from the internal file
export 'textformfield_datetime_range_picker_impl.dart'
    show TextFormFieldDateTimeRangePicker;

/// Callback for when the user selects a time
typedef TimePickerCallback = void Function(DateTime);

/// - [DateTimeOption.fullDateTime]: Shows date and time pickers for both start and end.
/// - [DateTimeOption.timeOnly]: Shows only time pickers for start and end times.
/// - [DateTimeOption.dateOnly]: Shows only date pickers for start and end dates.
///
enum DateTimeOption { fullDateTime, timeOnly, dateOnly }

/// - [TimePickerStyle.dropdown]: Uses the default time picker dropdown.
/// - [TimePickerStyle.spinner]: Uses the custom spinner-based time picker.
enum TimePickerStyle { dropdown, spinner, spinnerdropdown }
