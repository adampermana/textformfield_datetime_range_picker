// ============================================================
// Module Name       : extension_datetime.dart
// Date of Creation  : 2024-08-03
// Name of Creator   : Adam Permana
// History of Modifications:
//
// Summary           :
// This file contains extensions for the [DateTime] and [DateTimeRange] classes.
// It provides additional methods and utilities for date and time manipulation
// such as calculating the number of days in a month, adding days or months,
// and comparing different aspects of dates and times.
//
// Functions         :
// - `daysInMonth`: Returns the number of days in the month of the [DateTime] object.
// - `dateOnly`: Returns a [DateTime] object with time set to midnight.
// - `addDays`: Adds a specified number of days to the [DateTime] object and sets time to midnight.
// - `addMonths`: Adds a specified number of months to the [DateTime] object and sets day to 1 and time to midnight.
// - `isSameHour`: Checks if two [DateTime] objects have the same hour, day, month, and year.
// - `isSameDay`: Checks if two [DateTime] objects have the same day, month, and year.
// - `isSameMonth`: Checks if two [DateTime] objects have the same month and year.
// - `monthDelta`: Calculates the number of months between two [DateTime] objects.
// - `firstDayOffset`: Computes the offset of the first day of the month from the first day of the week.
// - `isBeforeDay`: Checks if the current [DateTime] object is before another [DateTime] object by day.
// - `isAfterDay`: Checks if the current [DateTime] object is after another [DateTime] object by day.
// - `isBeforeHour`: Checks if the current [DateTime] object is before another [DateTime] object by hour.
// - `isAfterHour`: Checks if the current [DateTime] object is after another [DateTime] object by hour.
// - `simplify`: Returns a simplified representation of the [DateTime] object in minutes.
// - `copyWith`: Returns a new [DateTime] object with specified changes to year, month, day, hour, minute, second, millisecond, or microsecond.
// - `resetTime`: Returns a new [DateTime] object with time set to either the start or end of the day.
// - `datesOnly`: Returns a [DateTimeRange] with the dates of the original but with times set to midnight.
//
// Variables         : None
//
// ============================================================

import 'package:flutter/material.dart';

extension DateTimeExt on DateTime {
  /// Returns the number of days in a month, according to the proleptic
  /// Gregorian calendar.
  ///
  /// This applies the leap year logic introduced by the Gregorian reforms of
  /// 1582. It will not give valid results for dates prior to that time.
  int get daysInMonth => DateUtils.getDaysInMonth(year, month);

  /// Returns a [DateTime] with the date of the original, but time set to
  /// midnight.
  DateTime get dateOnly => DateUtils.dateOnly(this);

  /// Returns a [DateTime] with the added number of days and time set to
  /// midnight.
  DateTime addDays(int days) => DateUtils.addDaysToDate(this, days);

  /// Returns a [DateTime] that is [monthDate] with the added number
  /// of months and the day set to 1 and time set to midnight.
  ///
  /// For example:
  /// ```
  /// DateTime date = DateTime(year: 2019, month: 1, day: 15);
  /// DateTime futureDate = DateUtils.addMonthsToMonthDate(date, 3);
  /// ```
  ///
  /// `date` would be January 15, 2019.
  /// `futureDate` would be April 1, 2019 since it adds 3 months.
  DateTime addMonths(int months) =>
      DateUtils.addMonthsToMonthDate(this, months);

  /// Returns true if the two [DateTime] objects have the same hour, day, month, and
  /// year, or are both null.
  bool isSameHour(DateTime? other) => isSameDay(other) && hour == other?.hour;

  /// Returns true if the two [DateTime] objects have the same day, month, and
  /// year, or are both null.
  bool isSameDay(DateTime? other) => DateUtils.isSameDay(this, other);

  /// Returns true if the two [DateTime] objects have the same month and
  /// year, or are both null.
  bool isSameMonth(DateTime? other) => DateUtils.isSameMonth(this, other);

  /// Determines the number of months between two [DateTime] objects.
  ///
  /// For example:
  /// ```
  /// DateTime date1 = DateTime(year: 2019, month: 6, day: 15);
  /// DateTime date2 = DateTime(year: 2020, month: 1, day: 15);
  /// int delta = monthDelta(date1, date2);
  /// ```
  ///
  /// The value for `delta` would be `7`.
  int monthDelta(DateTime other) => DateUtils.monthDelta(this, other);

  /// Computes the offset from the first day of the week that the first day of
  /// the [month] falls on.
  ///
  /// For example, September 1, 2017 falls on a Friday, which in the calendar
  /// localized for United States English appears as:
  ///
  /// ```
  /// S M T W T F S
  /// _ _ _ _ _ 1 2
  /// ```
  ///
  /// The offset for the first day of the months is the number of leading blanks
  /// in the calendar, i.e. 5.
  ///
  /// The same date localized for the Russian calendar has a different offset,
  /// because the first day of week is Monday rather than Sunday:
  ///
  /// ```
  /// M T W T F S S
  /// _ _ _ _ 1 2 3
  /// ```
  ///
  /// So the offset is 4, rather than 5.
  ///
  /// This code consolidates the following:
  ///
  /// - [DateTime.weekday] provides a 1-based index into days of week, with 1
  ///   falling on Monday.
  /// - [MaterialLocalizations.firstDayOfWeekIndex] provides a 0-based index
  ///   into the [MaterialLocalizations.narrowWeekdays] list.
  /// - [MaterialLocalizations.narrowWeekdays] list provides localized names of
  ///   days of week, always starting with Sunday and ending with Saturday.
  int firstDayOffset(MaterialLocalizations localizations) =>
      DateUtils.firstDayOffset(year, month, localizations);

  bool isBeforeDay(DateTime other) {
    return (year != other.year
        ? year < other.year
        : (month != other.month ? month < other.month : (day < other.day)));
  }

  bool isAfterDay(DateTime other) {
    return (year != other.year
        ? year > other.year
        : (month != other.month ? month > other.month : (day > other.day)));
  }

  bool isBeforeHour(DateTime other) {
    return (year != other.year
        ? year < other.year
        : (month != other.month
            ? month < other.month
            : (day != other.day ? day < other.day : hour < other.hour)));
  }

  bool isAfterHour(DateTime other) {
    return (year != other.year
        ? year > other.year
        : (month != other.month
            ? month > other.month
            : (day != other.day ? day > other.day : hour > other.hour)));
  }

  int simplify() {
    return millisecondsSinceEpoch ~/ 60000;
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime resetTime({bool toEnd = false}) {
    return copyWith(
      hour: toEnd ? 23 : 0,
      minute: toEnd ? 59 : 0,
      second: toEnd ? 59 : 0,
      millisecond: toEnd ? 999 : 0,
    );
  }
}

extension DateTimeRangeExt on DateTimeRange {
  /// Returns a [DateTimeRange] with the dates of the original, but with times
  /// set to midnight.
  ///
  /// See also:
  ///  * [dateOnly], which does the same thing for a single date.
  DateTimeRange get datesOnly => DateUtils.datesOnly(this);
}
