import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let deviceInfoChannel = FlutterMethodChannel(
            name: "com.sigmalogic.sigmanotes/device_info",
            binaryMessenger: controller.binaryMessenger
        )

        deviceInfoChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            switch call.method {
            case "getDeviceModel":
                result(self.getDeviceModel())
            case "getOSVersion":
                result(self.getOSVersion())
            case "getBatteryLevel":
                result(self.getBatteryLevel())
            case "getManufacturer":
                result("Apple")
            case "getTotalStorage":
                result(self.getTotalStorage())
            case "getAvailableStorage":
                result(self.getAvailableStorage())
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String(validatingUTF8: ptr)
            }
        }
        return modelCode ?? UIDevice.current.model
    }

    private func getOSVersion() -> String {
        return "iOS \(UIDevice.current.systemVersion)"
    }

    private func getBatteryLevel() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        if batteryLevel < 0 {
            return -1
        }
        return Int(batteryLevel * 100)
    }

    private func getTotalStorage() -> String {
        if let totalSpace = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [.volumeTotalCapacityKey]).volumeTotalCapacity {
            return formatBytes(Int64(totalSpace))
        }
        return "Unknown"
    }

    private func getAvailableStorage() -> String {
        if let availableSpace = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [.volumeAvailableCapacityKey]).volumeAvailableCapacity {
            return formatBytes(Int64(availableSpace))
        }
        return "Unknown"
    }

    private func formatBytes(_ bytes: Int64) -> String {
        let gb = Double(bytes) / (1024.0 * 1024.0 * 1024.0)
        return String(format: "%.2f GB", gb)
    }
}