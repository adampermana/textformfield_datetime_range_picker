#ifndef FLUTTER_PLUGIN_TEXTFORMFIELD_DATETIME_RANGE_PICKER_PLUGIN_H_
#define FLUTTER_PLUGIN_TEXTFORMFIELD_DATETIME_RANGE_PICKER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace textformfield_datetime_range_picker {

class TextformfieldDatetimeRangePickerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TextformfieldDatetimeRangePickerPlugin();

  virtual ~TextformfieldDatetimeRangePickerPlugin();

  // Disallow copy and assign.
  TextformfieldDatetimeRangePickerPlugin(const TextformfieldDatetimeRangePickerPlugin&) = delete;
  TextformfieldDatetimeRangePickerPlugin& operator=(const TextformfieldDatetimeRangePickerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace textformfield_datetime_range_picker

#endif  // FLUTTER_PLUGIN_TEXTFORMFIELD_DATETIME_RANGE_PICKER_PLUGIN_H_
