#include "include/textformfield_datetime_range_picker/textformfield_datetime_range_picker_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "textformfield_datetime_range_picker_plugin.h"

void TextformfieldDatetimeRangePickerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  textformfield_datetime_range_picker::TextformfieldDatetimeRangePickerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
