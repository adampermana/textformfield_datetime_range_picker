// ignore_for_file: library_private_types_in_public_api

/*============================================================
 Module Name       : datetime_range.dart
 Date of Creation  : 2024-08-03
 Name of Creator   : Adam Permana
 History of Modifications:
                    2024-08-03 - Initial creation by Adam Permana
                    2024-08-03 - Added functionality for DateTimeFields
                    2024-08-03 - Added clear functionality
                    2024-08-03 - Improved focus handling

 Summary           : This module handles DateTimeFields.
 Functions         :
                     - DateTimeFields: A FormField for selecting DateTime
                     - tryFormat: Formats a DateTime to String
                     - tryParse: Parses a String to DateTime
                     - combine: Combines a DateTime and TimeOfDay
                     - convert: Converts a TimeOfDay to DateTime

 Variables         :
                     - format: DateFormat for representing date as string
                     - onShowPicker: Function to show date chooser dialog
                     - resetIcon: Icon to reset the text field
                     - controller: TextEditingController for the field
                     - focusNode: FocusNode for the field
                     - readOnly: Boolean to set read-only state
                     - onChanged: Callback when the field value changes

 ============================================================*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

/// A [FormField<DateTime>] that integrates a text input with time-chooser UIs.
///
/// It borrows many of its parameters from [TextFormField].
///
/// When a [controller] is specified, [initialValue] must be null (the
/// default).
class DateTimeFields extends FormField<DateTime> {
  DateTimeFields({
    required this.format,
    required this.onShowPicker,

    // From super
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,

    // Features
    this.resetIcon = const Icon(Icons.close),
    this.onChanged,

    // From TextFormField
    this.controller,
    this.focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    this.readOnly = true,
    bool? showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    MaxLengthEnforcement maxLengthEnforcement = MaxLengthEnforcement.enforced,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    VoidCallback? onEditingComplete,
    ValueChanged<DateTime?>? onFieldSubmitted,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
  }) : super(builder: (field) {
          final _DateTimeFieldState state = field as _DateTimeFieldState;
          final InputDecoration effectiveDecoration =
              (decoration ?? const InputDecoration())
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
          return TextField(
            controller: state._effectiveController,
            focusNode: state._effectiveFocusNode,
            decoration: effectiveDecoration.copyWith(
              errorText: field.errorText,
              suffixIcon: state.shouldShowClearIcon(effectiveDecoration)
                  ? IconButton(
                      icon: resetIcon!,
                      onPressed: state.clear,
                    )
                  : null,
            ),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            textCapitalization: textCapitalization,
            autofocus: autofocus,
            readOnly: readOnly,
            showCursor: showCursor,
            obscureText: obscureText,
            autocorrect: autocorrect,
            maxLengthEnforcement: maxLengthEnforcement,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            maxLength: maxLength,
            onChanged: (string) => field.didChange(tryParse(string, format)),
            onEditingComplete: onEditingComplete,
            onSubmitted: (string) => onFieldSubmitted == null
                ? null
                : onFieldSubmitted(tryParse(string, format)),
            inputFormatters: inputFormatters,
            enabled: enabled,
            cursorWidth: cursorWidth,
            cursorRadius: cursorRadius,
            cursorColor: cursorColor,
            scrollPadding: scrollPadding,
            keyboardAppearance: keyboardAppearance,
            enableInteractiveSelection: enableInteractiveSelection,
            buildCounter: buildCounter,
          );
        });

  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  final DateFormat format;

  /// Called when the date chooser dialog should be shown.
  final Future<DateTime?> Function(BuildContext context, DateTime? currentValue)
      onShowPicker;

  /// The [InputDecoration.suffixIcon] to show when the field has text. Tapping
  /// the icon will clear the text field. Set this to `null` to disable that
  /// behavior. Also, setting the suffix icon yourself will override this option.
  final Icon? resetIcon;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function(DateTime? value)? onChanged;

  @override
  _DateTimeFieldState createState() => _DateTimeFieldState();

  /// Returns an empty string if [DateFormat.format()] throws or [date] is null.
  static String tryFormat(DateTime? date, DateFormat format) {
    if (date != null) {
      try {
        return format.format(date);
      } catch (e) {
        // print('Error formatting date: $e');
      }
    }
    return '';
  }

  /// Returns null if [format.parse()] throws.
  static DateTime? tryParse(String string, DateFormat format) {
    if (string.isNotEmpty) {
      try {
        return format.parse(string);
      } catch (e) {
        // print('Error parsing date: $e');
      }
    }
    return null;
  }

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  static DateTime combine(DateTime date, TimeOfDay? time) => DateTime(
      date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);

  static DateTime? convert(TimeOfDay? time) =>
      time == null ? null : DateTime(1, 1, 1, time.hour, time.minute);
}

class _DateTimeFieldState extends FormFieldState<DateTime> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  DateTimeFields get widget => super.widget as DateTimeFields;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  FocusNode? get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  bool get hasFocus => _effectiveFocusNode!.hasFocus;
  bool get hasText => _effectiveController!.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: format(widget.initialValue));
      _controller!.addListener(_handleControllerChanged);
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _focusNode!.addListener(_handleFocusChanged);
    }
    widget.controller?.addListener(_handleControllerChanged);
    widget.focusNode?.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(DateTimeFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
        _controller!.addListener(_handleControllerChanged);
      }
      if (widget.controller != null) {
        setValue(parse(widget.controller!.text));
        // Release the controller since it wont be used
        if (oldWidget.controller == null) {
          _controller?.dispose();
          _controller = null;
        }
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      widget.focusNode?.addListener(_handleFocusChanged);

      if (oldWidget.focusNode != null && widget.focusNode == null) {
        _focusNode = FocusNode();
        _focusNode!.addListener(_handleFocusChanged);
      }
      if (widget.focusNode != null) {
        // Release the focus node since it wont be used
        if (oldWidget.focusNode == null) {
          _focusNode?.dispose();
          _focusNode = null;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    widget.focusNode?.removeListener(_handleFocusChanged);
    _controller?.dispose();
    _focusNode?.dispose();
  }

  @override
  void didChange(DateTime? value) {
    super.didChange(value);
    if (parse(_effectiveController!.text) != value) {
      _effectiveController!.text = format(value);
      widget.onChanged?.call(value);
    }
  }

  @override
  void reset() {
    super.reset();
    _effectiveController!.text = format(widget.initialValue);
    setState(() {
      widget.onChanged?.call(widget.initialValue);
    });
  }

  DateTime? parse(String text) => DateTimeFields.tryParse(text, widget.format);

  String format(DateTime? date) =>
      DateTimeFields.tryFormat(date, widget.format);

  Future<void> requestFocus() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!hasFocus && !hadFocus) {
      _effectiveFocusNode!.requestFocus();
      await Future.delayed(const Duration(milliseconds: 100));
      _effectiveFocusNode!.unfocus();
    }
  }

  Future<void> _handleFocusChanged() async {
    if (!hasFocus && hadFocus && !isShowingDialog) {
      setState(() => hadFocus = false);
      return;
    }
    if (!hasFocus && !hadFocus) return;

    if (hasFocus && !hadFocus && !isShowingDialog) {
      hadFocus = true;
      final DateTime? selectedDate = await _showDialog();
      if (selectedDate != null) {
        setState(() {
          didChange(selectedDate);
        });
      }
      isShowingDialog = false;
      if (_effectiveFocusNode!.canRequestFocus) {
        await requestFocus();
      }
    }
  }

  void _handleControllerChanged() {
    final DateTime? date = parse(_effectiveController!.text);
    if (date != value) {
      didChange(date);
    }
  }

  Future<DateTime?> _showDialog() async {
    setState(() => isShowingDialog = true);
    return widget.onShowPicker(context, value);
  }

  void clear() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _effectiveController!.clear();
      didChange(null);
    });
  }

  bool shouldShowClearIcon(InputDecoration decoration) {
    return hasText &&
        (decoration.suffixIcon == null ||
            decoration.suffixIcon == widget.resetIcon);
  }
}
