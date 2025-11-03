import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';
import '../../services/providers/device_info_provider.dart';

class DeviceInfoWidget extends ConsumerWidget {
  const DeviceInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInfoAsync = ref.watch(deviceInfoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Device Information",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        const SizedBox(height: 8),
        deviceInfoAsync.when(
          data: (deviceInfo) {
            // Convert map to list of key/value pairs
            final List<MapEntry<String, String>> infoList = [
              MapEntry('Device Model', deviceInfo['deviceModel'] ?? 'Unknown'),
              MapEntry('OS Version', deviceInfo['osVersion'] ?? 'Unknown'),
              MapEntry('Battery Level', '${deviceInfo['batteryLevel'] ?? 0}%'),
              MapEntry('Manufacturer', deviceInfo['manufacturer'] ?? 'Unknown'),
              MapEntry(
                'Available Storage',
                deviceInfo['availableStorage'] ?? 'Unknown',
              ),
              MapEntry(
                'Total Storage',
                deviceInfo['totalStorage'] ?? 'Unknown',
              ),
            ];

            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: infoList.length,
              separatorBuilder: (_, __) => const Divider(
                height: 20,
                color: SigmaColors.gray,
                thickness: 0.2,
                endIndent: 4,
                indent: 4,
              ),
              itemBuilder: (context, index) {
                final info = infoList[index];
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        info.key,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Text(
                      info.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(strokeWidth: 2.4),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                SigmaInkwell(
                  onTap: () {
                    ref.read(deviceInfoProvider.notifier).refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
