// Custom Time Picker implementation from CustomTimePicker widget

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../textformfield_datetime_range_picker.dart';

/// A custom time picker spinner widget that allows selecting hours and minutes.
/// Optionally supports seconds selection and 12/24 hour modes.
class CustomTimePicker extends StatefulWidget {
  /// Initial time value
  final DateTime? time;

  /// Interval between minute values
  final int minutesInterval;

  /// Interval between second values
  final int secondsInterval;

  /// Whether to use 24 hour mode (true) or 12 hour AM/PM mode (false)
  final bool is24HourMode;

  /// Whether to show seconds selection
  final bool isShowSeconds;

  /// Text style for the highlighted (selected) time values
  final TextStyle? highlightedTextStyle;

  /// Text style for non-selected time values
  final TextStyle? normalTextStyle;

  /// Height of each item in the spinner
  final double? itemHeight;

  /// Width of each spinner column
  final double? itemWidth;

  /// Alignment of text within each spinner item
  final AlignmentGeometry? alignment;

  /// Horizontal spacing between spinner components
  final double? spacing;

  /// Whether to force 2-digit display (e.g., "01" instead of "1")
  final bool isForce2Digits;

  // /// Set to true if running on web platform to fix mouse wheel scrolling
  // final bool isWeb;

  /// Callback function called when time changes
  final TimePickerCallback? onTimeChange;

  const CustomTimePicker({
    Key? key,
    this.time,
    this.minutesInterval = 1,
    this.secondsInterval = 1,
    this.is24HourMode = true,
    this.isShowSeconds = false,
    this.highlightedTextStyle,
    this.normalTextStyle,
    this.itemHeight,
    this.itemWidth,
    this.alignment,
    this.spacing,
    this.isForce2Digits = false,
    // this.isWeb = false,
    this.onTimeChange,
  }) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  // ScrollControllers for the different spinner components
  late ScrollController hourController;
  late ScrollController minuteController;
  late ScrollController secondController;
  late ScrollController amPmController;

  // Track the current selected indices
  int currentSelectedHourIndex = -1;
  int currentSelectedMinuteIndex = -1;
  int currentSelectedSecondIndex = -1;
  int currentSelectedAmPmIndex = -1;

  // The current time value
  late DateTime currentTime;

  // Track scrolling state for each component
  bool isHourScrolling = false;
  bool isMinuteScrolling = false;
  bool isSecondsScrolling = false;
  bool isAmPmScrolling = false;

  // Default styling values
  final TextStyle defaultHighlightTextStyle =
      const TextStyle(fontSize: 32, color: Colors.black);
  final TextStyle defaultNormalTextStyle =
      const TextStyle(fontSize: 32, color: Colors.black54);
  final double defaultItemHeight = 60;
  final double defaultItemWidth = 45;
  final double defaultSpacing = 20;
  final AlignmentGeometry defaultAlignment = Alignment.centerRight;

  @override
  void initState() {
    super.initState();

    // Initialize with the provided time or current time
    currentTime = widget.time ?? DateTime.now();

    // Initialize hour spinner
    currentSelectedHourIndex =
        (currentTime.hour % (widget.is24HourMode ? 24 : 12)) + _getHourCount();
    hourController = ScrollController(
        initialScrollOffset: (currentSelectedHourIndex - 1) * _getItemHeight());

    // Initialize minute spinner
    currentSelectedMinuteIndex =
        (currentTime.minute / widget.minutesInterval).floor() +
            (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1);
    minuteController = ScrollController(
        initialScrollOffset:
            (currentSelectedMinuteIndex - 1) * _getItemHeight());

    // Initialize second spinner if needed
    currentSelectedSecondIndex =
        (currentTime.second / widget.secondsInterval).floor() +
            (isLoop(_getSecondCount()) ? _getSecondCount() : 1);
    secondController = ScrollController(
        initialScrollOffset:
            (currentSelectedSecondIndex - 1) * _getItemHeight());

    // Initialize AM/PM spinner if needed
    currentSelectedAmPmIndex = currentTime.hour >= 12 ? 2 : 1;
    amPmController = ScrollController(
        initialScrollOffset: (currentSelectedAmPmIndex - 1) * _getItemHeight());

    // Trigger initial callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onTimeChange != null) {
        widget.onTimeChange!(getDateTime());
      }
    });
  }

  @override
  void dispose() {
    // Clean up controllers
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    amPmController.dispose();
    super.dispose();
  }

  // Helper getters
  TextStyle get _highlightedTextStyle =>
      widget.highlightedTextStyle ?? defaultHighlightTextStyle;

  TextStyle get _normalTextStyle =>
      widget.normalTextStyle ?? defaultNormalTextStyle;

  int _getHourCount() => widget.is24HourMode ? 24 : 12;

  int _getMinuteCount() => (60 / widget.minutesInterval).floor();

  int _getSecondCount() => (60 / widget.secondsInterval).floor();

  double _getItemHeight() => widget.itemHeight ?? defaultItemHeight;

  double _getItemWidth() => widget.itemWidth ?? defaultItemWidth;

  double _getSpacing() => widget.spacing ?? defaultSpacing;

  AlignmentGeometry _getAlignment() => widget.alignment ?? defaultAlignment;

  // Determine if we should use looping for this spinner
  bool isLoop(int value) => value > 10;

  // Calculate the current DateTime from selected indices
  DateTime getDateTime() {
    int hour = currentSelectedHourIndex - _getHourCount();
    if (!widget.is24HourMode && currentSelectedAmPmIndex == 2) {
      hour += 12;
    }

    int minute = (currentSelectedMinuteIndex -
            (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1)) *
        widget.minutesInterval;

    int second = (currentSelectedSecondIndex -
            (isLoop(_getSecondCount()) ? _getSecondCount() : 1)) *
        widget.secondsInterval;

    return DateTime(currentTime.year, currentTime.month, currentTime.day, hour,
        minute, second);
  }

  @override
  Widget build(BuildContext context) {
    // Build the components of the time picker
    List<Widget> contents = [
      // Hours column
      SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: Stack(
          children: [
            _buildSelectionBorder(context),
            Positioned.fill(
              child: _buildSpinner(
                hourController,
                _getHourCount(),
                currentSelectedHourIndex,
                isHourScrolling,
                1,
                (index) {
                  setState(() {
                    currentSelectedHourIndex = index;
                    isHourScrolling = true;
                  });
                },
                () {
                  setState(() {
                    isHourScrolling = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),

      // Separator
      _buildSpacer(),
      Text(":", style: _highlightedTextStyle),
      _buildSpacer(),

      // Minutes column
      SizedBox(
        width: _getItemWidth(),
        height: _getItemHeight() * 3,
        child: Stack(
          children: [
            _buildSelectionBorder(context),
            Positioned.fill(
              child: _buildSpinner(
                minuteController,
                _getMinuteCount(),
                currentSelectedMinuteIndex,
                isMinuteScrolling,
                widget.minutesInterval,
                (index) {
                  setState(() {
                    currentSelectedMinuteIndex = index;
                    isMinuteScrolling = true;
                  });
                },
                () {
                  setState(() {
                    isMinuteScrolling = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ];

    // Add seconds if enabled
    if (widget.isShowSeconds) {
      contents.addAll([
        _buildSpacer(),
        Text(":", style: _highlightedTextStyle),
        _buildSpacer(),

        // Seconds column
        SizedBox(
          width: _getItemWidth(),
          height: _getItemHeight() * 3,
          child: Stack(
            children: [
              _buildSelectionBorder(context),
              Positioned.fill(
                child: _buildSpinner(
                  secondController,
                  _getSecondCount(),
                  currentSelectedSecondIndex,
                  isSecondsScrolling,
                  widget.secondsInterval,
                  (index) {
                    setState(() {
                      currentSelectedSecondIndex = index;
                      isSecondsScrolling = true;
                    });
                  },
                  () {
                    setState(() {
                      isSecondsScrolling = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ]);
    }

    // Add AM/PM if not in 24-hour mode
    if (!widget.is24HourMode) {
      contents.addAll([
        _buildSpacer(),
        SizedBox(
          width: _getItemWidth() * 1.2,
          height: _getItemHeight() * 3,
          child: Stack(
            children: [
              _buildSelectionBorder(context),
              Positioned.fill(
                child: _buildAmPmSpinner(),
              ),
            ],
          ),
        ),
      ]);
    }

    // Arrange all components in a row
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: contents,
    );
  }

  // Creates a border around the selected item
  Widget _buildSelectionBorder(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: _getItemHeight(),
        width: _getItemWidth(),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Creates space between components
  Widget _buildSpacer() {
    return SizedBox(
      width: _getSpacing(),
      height: _getItemHeight() * 3,
    );
  }

  // Creates a spinner component (hour, minute, second)
// Creates a spinner component (hour, minute, second)
  Widget _buildSpinner(
    ScrollController controller,
    int maxItems,
    int selectedIndex,
    bool isScrolling,
    int interval,
    Function(int) onUpdateSelectedIndex,
    VoidCallback onScrollEnd,
  ) {
    // Spinner content
    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction == ScrollDirection.idle) {
            // Handle looping if needed
            if (isLoop(maxItems)) {
              int segment = (selectedIndex / maxItems).floor();
              if (segment == 0) {
                onUpdateSelectedIndex(selectedIndex + maxItems);
                controller
                    .jumpTo(controller.offset + (maxItems * _getItemHeight()));
              } else if (segment == 2) {
                onUpdateSelectedIndex(selectedIndex - maxItems);
                controller
                    .jumpTo(controller.offset - (maxItems * _getItemHeight()));
              }
            }

            // Trigger scroll end actions
            onScrollEnd();
            if (widget.onTimeChange != null) {
              widget.onTimeChange!(getDateTime());
            }
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          // Update selected index during scroll
          onUpdateSelectedIndex(
              (controller.offset / _getItemHeight()).round() + 1);
        }
        return true;
      },
      child: ScrollConfiguration(
        // Custom scroll behavior that enables all input types
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse, // Enable mouse drag explicitly
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown,
          },
        ),
        child: ListView.builder(
          itemBuilder: (context, index) {
            String text = '';

            // Determine the text to display based on position
            if (isLoop(maxItems)) {
              text = ((index % maxItems) * interval).toString();
            } else if (index != 0 && index != maxItems + 1) {
              text = (((index - 1) % maxItems) * interval).toString();
            }

            // Special case for 12-hour display
            if (!widget.is24HourMode &&
                controller == hourController &&
                text == '0') {
              text = '12';
            }

            // Add leading zero if required
            if (widget.isForce2Digits && text != '') {
              text = text.padLeft(2, '0');
            }

            return GestureDetector(
              // Add direct tap handling for better usability
              onTap: () {
                if (text.isNotEmpty) {
                  controller.animateTo(
                    (index - 1) * _getItemHeight(),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
              child: Container(
                height: _getItemHeight(),
                alignment: _getAlignment(),
                child: Center(
                  child: Text(
                    text,
                    style: selectedIndex == index
                        ? _highlightedTextStyle
                        : _normalTextStyle,
                  ),
                ),
              ),
            );
          },
          controller: controller,
          itemCount: isLoop(maxItems) ? maxItems * 3 : maxItems + 2,
          physics:
              const BouncingScrollPhysics(), // Use BouncingScrollPhysics for better mouse interaction
          padding: EdgeInsets.zero,
        ),
      ),
    );

    // Stack to handle scroll state
    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        if (isScrolling)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
      ],
    );
  }

  // Creates AM/PM spinner component
  Widget _buildAmPmSpinner() {
    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction == ScrollDirection.idle) {
            setState(() {
              isAmPmScrolling = false;
            });

            if (widget.onTimeChange != null) {
              widget.onTimeChange!(getDateTime());
            }
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            currentSelectedAmPmIndex =
                (amPmController.offset / _getItemHeight()).round() + 1;
            isAmPmScrolling = true;
          });
        }
        return true;
      },
      child: ScrollConfiguration(
        // Apply behavior that prevents mouse wheel scrolling on web platform
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse, // Enable mouse drag explicitly
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown,
          },
        ),
        child: ListView.builder(
          itemBuilder: (context, index) {
            String text = index == 1 ? 'AM' : (index == 2 ? 'PM' : '');
            return Container(
              height: _getItemHeight(),
              alignment: Alignment.center,
              child: Text(
                text,
                style: currentSelectedAmPmIndex == index
                    ? _highlightedTextStyle
                    : _normalTextStyle,
              ),
            );
          },
          controller: amPmController,
          itemCount: 4,
          physics: ItemScrollPhysics(
            itemHeight: _getItemHeight(),
            targetPixelsLimit: 1,
          ),
        ),
      ),
    );

    // Stack to handle scroll state
    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        if (isAmPmScrolling) Positioned.fill(child: Container()),
      ],
    );
  }
}

/// Custom ScrollPhysics that snaps to item positions
class ItemScrollPhysics extends ScrollPhysics {
  /// Height of each item to snap to
  final double itemHeight;

  /// Sensitivity of the snapping effect
  final double targetPixelsLimit;

  const ItemScrollPhysics({
    ScrollPhysics? parent,
    required this.itemHeight,
    this.targetPixelsLimit = 3.0,
  }) : super(parent: parent);

  @override
  ItemScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ItemScrollPhysics(
      parent: buildParent(ancestor),
      itemHeight: itemHeight,
      targetPixelsLimit: targetPixelsLimit,
    );
  }

  // Calculate the current item index
  double _getItem(ScrollPosition position) {
    double maxScrollItem =
        (position.maxScrollExtent / itemHeight).floorToDouble();
    return min(max(0, position.pixels / itemHeight), maxScrollItem);
  }

  // Convert item index to pixel position
  double _getPixels(ScrollPosition position, double item) {
    return item * itemHeight;
  }

  // Calculate target position for ballistic animation
  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);

    if (velocity < -tolerance.velocity) {
      item -= targetPixelsLimit;
    } else if (velocity > tolerance.velocity) {
      item += targetPixelsLimit;
    }

    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // Create spring simulation to snap to nearest item
    final double target =
        _getTargetPixels(position as ScrollPosition, tolerance, velocity);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
