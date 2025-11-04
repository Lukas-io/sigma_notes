import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../device_info_service.dart';

part 'device_info_provider.g.dart';

// Provider for the service - keep alive since it's a lightweight singleton
@Riverpod(keepAlive: true)
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
    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;

    state = const AsyncValue.loading();

    // Check if the provider is still mounted after setting loading state
    if (!ref.mounted) return;

    state = await AsyncValue.guard(() async {
      final service = ref.read(deviceInfoServiceProvider);
      // Check if the provider is still mounted before accessing service
      if (!ref.mounted) return state.value ?? {};
      return await service.getAllDeviceInfo();
    });
  }
}
