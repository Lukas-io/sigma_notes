import 'package:flutter/services.dart';

class DeviceInfoService {
  static const platform = MethodChannel(
    'com.sigmalogic.sigmanotes/device_info',
  );

  // Get device model
  Future<String> getDeviceModel() async {
    try {
      final String result = await platform.invokeMethod('getDeviceModel');
      return result;
    } catch (e) {
      return 'Unknown Model';
    }
  }

  // Get OS version
  Future<String> getOSVersion() async {
    try {
      final String result = await platform.invokeMethod('getOSVersion');
      return result;
    } catch (e) {
      return 'Unknown OS';
    }
  }

  // Get battery level
  Future<int> getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      return result;
    } catch (e) {
      return -1;
    }
  }

  // Get device manufacturer
  Future<String> getManufacturer() async {
    try {
      final String result = await platform.invokeMethod('getManufacturer');
      return result;
    } catch (e) {
      return 'Unknown Manufacturer';
    }
  }

  // Get total storage
  Future<String> getTotalStorage() async {
    try {
      final String result = await platform.invokeMethod('getTotalStorage');
      return result;
    } catch (e) {
      return 'Unknown';
    }
  }

  // Get available storage
  Future<String> getAvailableStorage() async {
    try {
      final String result = await platform.invokeMethod('getAvailableStorage');
      return result;
    } catch (e) {
      return 'Unknown';
    }
  }

  // Get all device info at once
  Future<Map<String, dynamic>> getAllDeviceInfo() async {
    return {
      'deviceModel': await getDeviceModel(),
      'osVersion': await getOSVersion(),
      'batteryLevel': await getBatteryLevel(),
      'manufacturer': await getManufacturer(),
      'totalStorage': await getTotalStorage(),
      'availableStorage': await getAvailableStorage(),
    };
  }
}
