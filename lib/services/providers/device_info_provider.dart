import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../device_info_service.dart';

part 'device_info_provider.g.dart';

// Provider for the service
@riverpod
DeviceInfoService deviceInfoService(Ref ref) {
  return DeviceInfoService();
}

// Provider for device info
@riverpod
class DeviceInfo extends _$DeviceInfo {
  @override
  Future<Map<String, dynamic>> build() async {
    final service = ref.read(deviceInfoServiceProvider);
    return await service.getAllDeviceInfo();
  }

  // Refresh device info
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(deviceInfoServiceProvider);
      return await service.getAllDeviceInfo();
    });
  }
}
