import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'textformfield_datetime_range_picker_method_channel.dart';

abstract class TextformfieldDatetimeRangePickerPlatform extends PlatformInterface {
  /// Constructs a TextformfieldDatetimeRangePickerPlatform.
  TextformfieldDatetimeRangePickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static TextformfieldDatetimeRangePickerPlatform _instance = MethodChannelTextformfieldDatetimeRangePicker();

  /// The default instance of [TextformfieldDatetimeRangePickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelTextformfieldDatetimeRangePicker].
  static TextformfieldDatetimeRangePickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TextformfieldDatetimeRangePickerPlatform] when
  /// they register themselves.
  static set instance(TextformfieldDatetimeRangePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
