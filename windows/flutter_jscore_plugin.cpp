// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#include "include/flutter_jscore/flutter_jscore_plugin.h"

// Must be before VersionHelpers.h
#include <windows.h>

#include <VersionHelpers.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <sstream>

namespace
{

  using flutter::EncodableMap;
  using flutter::EncodableValue;

  class FlutterJscorePlugin : public flutter::Plugin
  {
  public:
    static void RegisterWithRegistrar(flutter::PluginRegistrar *registrar);

    virtual ~FlutterJscorePlugin();

  private:
    FlutterJscorePlugin();

    // Called when a method is called on plugin channel;
    void HandleMethodCall(
        const flutter::MethodCall<EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<EncodableValue>> result);
  };

  // static
  void FlutterJscorePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrar *registrar)
  {
    auto channel = std::make_unique<flutter::MethodChannel<EncodableValue>>(
        registrar->messenger(), "flutter_jscore",
        &flutter::StandardMethodCodec::GetInstance());

    // Uses new instead of make_unique due to private constructor.
    std::unique_ptr<FlutterJscorePlugin> plugin(new FlutterJscorePlugin());

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  FlutterJscorePlugin::FlutterJscorePlugin() = default;

  FlutterJscorePlugin::~FlutterJscorePlugin() = default;

  void FlutterJscorePlugin::HandleMethodCall(
      const flutter::MethodCall<EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<EncodableValue>> result)
  {
    if (method_call.method_name().compare("getPlatformVersion") == 0)
    {
      std::ostringstream version_stream;
      version_stream << "Windows ";
      if (IsWindows10OrGreater())
      {
        version_stream << "10+";
      }
      else if (IsWindows8OrGreater())
      {
        version_stream << "8";
      }
      else if (IsWindows7OrGreater())
      {
        version_stream << "7";
      }
      flutter::EncodableValue response(version_stream.str());
      result->Success(&response);
    }
    else
    {
      result->NotImplemented();
    }
  } 
}

void FlutterJscorePluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
  FlutterJscorePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
