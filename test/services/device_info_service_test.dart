import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sigma_notes/services/device_info_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceInfoService', () {
    const channel = MethodChannel('com.sigmalogic.sigmanotes/device_info');
    late DeviceInfoService deviceInfoService;

    setUp(() {
      deviceInfoService = DeviceInfoService();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'getDeviceModel':
                return 'Test Device';
              case 'getOSVersion':
                return '1.0.0';
              case 'getBatteryLevel':
                return 80;
              case 'getManufacturer':
                return 'Test Manufacturer';
              case 'getTotalStorage':
                return '128 GB';
              case 'getAvailableStorage':
                return '64 GB';
              default:
                throw MissingPluginException('Not implemented');
            }
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    group('getDeviceModel', () {
      test('returns device model', () async {
        print('\n=== Testing: getDeviceModel ===');
        print('Method channel: ${channel.name}');
        final model = await deviceInfoService.getDeviceModel();
        print('Expected: Test Device');
        print('Actual: $model');
        expect(model, equals('Test Device'));
        print('✅ Test PASSED: getDeviceModel returns mocked value');
      });

      test('returns unknown when error occurs', () async {
        // Set up error scenario
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(code: 'ERROR', message: 'Test error');
            });

        final model = await deviceInfoService.getDeviceModel();
        print('Expected: Unknown Model');
        print('Actual: $model');
        expect(model, equals('Unknown Model'));
      });
    });

    group('getOSVersion', () {
      test('returns OS version', () async {
        print('\n=== Testing: getOSVersion ===');
        print('Method channel: ${channel.name}');
        final version = await deviceInfoService.getOSVersion();
        print('Expected: 1.0.0');
        print('Actual: $version');
        expect(version, equals('1.0.0'));
      });

      test('returns unknown when error occurs', () async {
        // Set up error scenario
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(code: 'ERROR', message: 'Test error');
            });

        final version = await deviceInfoService.getOSVersion();
        print('Expected: Unknown OS');
        print('Actual: $version');
        expect(version, equals('Unknown OS'));
      });
    });

    group('getBatteryLevel', () {
      test('returns battery level', () async {
        print('\n=== Testing: getBatteryLevel ===');
        final level = await deviceInfoService.getBatteryLevel();
        print('Expected: 80');
        print('Actual: $level');
        expect(level, equals(80));
      });

      test('returns -1 when error occurs', () async {
        // Set up error scenario
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(code: 'ERROR', message: 'Test error');
            });

        final level = await deviceInfoService.getBatteryLevel();
        print('Expected: -1');
        print('Actual: $level');
        expect(level, equals(-1));
      });
    });

    group('getManufacturer', () {
      test('returns manufacturer', () async {
        print('\n=== Testing: getManufacturer ===');
        final manufacturer = await deviceInfoService.getManufacturer();
        print('Expected: Test Manufacturer');
        print('Actual: $manufacturer');
        expect(manufacturer, equals('Test Manufacturer'));
      });

      test('returns unknown when error occurs', () async {
        // Set up error scenario
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(code: 'ERROR', message: 'Test error');
            });

        final manufacturer = await deviceInfoService.getManufacturer();
        print('Expected: Unknown Manufacturer');
        print('Actual: $manufacturer');
        expect(manufacturer, equals('Unknown Manufacturer'));
      });
    });

    group('getTotalStorage', () {
      test('returns total storage', () async {
        print('\n=== Testing: getTotalStorage ===');
        final storage = await deviceInfoService.getTotalStorage();
        print('Expected: 128 GB');
        print('Actual: $storage');
        expect(storage, equals('128 GB'));
      });

      test('returns unknown when error occurs', () async {
        // Set up error scenario
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(code: 'ERROR', message: 'Test error');
            });

        final storage = await deviceInfoService.getTotalStorage();
        print('Expected: Unknown');
        print('Actual: $storage');
        expect(storage, equals('Unknown'));
      });
    });

    group('getAvailableStorage', () {
      test('returns available storage', () async {
        print('\n=== Testing: getAvailableStorage ===');
        final storage = await deviceInfoService.getAvailableStorage();
        print('Expected: 64 GB');
        print('Actual: $storage');
        expect(storage, equals('64 GB'));
      });

      test('returns unknown when error occurs', () async {
        // Set up error scenario
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(code: 'ERROR', message: 'Test error');
            });

        final storage = await deviceInfoService.getAvailableStorage();
        print('Expected: Unknown');
        print('Actual: $storage');
        expect(storage, equals('Unknown'));
      });
    });

    group('getAllDeviceInfo', () {
      test('returns all device info', () async {
        print('\n=== Testing: getAllDeviceInfo ===');
        final info = await deviceInfoService.getAllDeviceInfo();
        print('Platform channel: ${channel.name}');
        print('Values: $info');
        expect(info['deviceModel'], equals('Test Device'));
        expect(info['osVersion'], equals('1.0.0'));
        expect(info['batteryLevel'], equals(80));
        expect(info['manufacturer'], equals('Test Manufacturer'));
        expect(info['totalStorage'], equals('128 GB'));
        expect(info['availableStorage'], equals('64 GB'));
      });
    });
  });
}
