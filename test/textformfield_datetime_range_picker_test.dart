// import 'package:flutter_test/flutter_test.dart';
// import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker.dart';
// import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker_platform_interface.dart';
// import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockTextformfieldDatetimeRangePickerPlatform
//     with MockPlatformInterfaceMixin
//     implements TextformfieldDatetimeRangePickerPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final TextformfieldDatetimeRangePickerPlatform initialPlatform = TextformfieldDatetimeRangePickerPlatform.instance;

//   test('$MethodChannelTextformfieldDatetimeRangePicker is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelTextformfieldDatetimeRangePicker>());
//   });

//   test('getPlatformVersion', () async {
//     TextformfieldDatetimeRangePicker textformfieldDatetimeRangePickerPlugin = TextformfieldDatetimeRangePicker();
//     MockTextformfieldDatetimeRangePickerPlatform fakePlatform = MockTextformfieldDatetimeRangePickerPlatform();
//     TextformfieldDatetimeRangePickerPlatform.instance = fakePlatform;

//     expect(await textformfieldDatetimeRangePickerPlugin.getPlatformVersion(), '42');
//   });
// }
