import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'textformfield_datetime_range_picker_platform_interface.dart';

/// An implementation of [TextformfieldDatetimeRangePickerPlatform] that uses method channels.
class MethodChannelTextformfieldDatetimeRangePicker extends TextformfieldDatetimeRangePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('textformfield_datetime_range_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
