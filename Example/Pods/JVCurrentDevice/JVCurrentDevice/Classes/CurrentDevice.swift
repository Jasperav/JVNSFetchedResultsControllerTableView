import DeviceKit

public struct CurrentDevice {
    
    private static let device = Device()
    public static let isRightToLeftLanguage = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    public static let isTablet = device.isPad
    public static let screenBounds = UIScreen.main.bounds.width
    
    // This MUST be a computed property since the keyWindow is nil when starting up the app.
    public static var availableWidthInSafeArea: CGFloat {
        get {
            guard let window = UIApplication.shared.keyWindow else { return UIScreen.main.bounds.width }
            let left = window.safeAreaInsets.left
            let right = window.safeAreaInsets.right
            return UIScreen.main.bounds.width - left - right
        }
    }
    
    // This MUST be a computed property since the keyWindow is nil when starting up the app.
    public static var availableHeightInSafeArea: CGFloat {
        get {
            guard let window = UIApplication.shared.keyWindow else { return UIScreen.main.bounds.height }
            let top = window.safeAreaInsets.top
            let bottom = window.safeAreaInsets.bottom
            return UIScreen.main.bounds.height - top - bottom
        }
    }
    
    public static func getTopController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
        
    }
    
    public static func getTopController<T: UIViewController>(viewController: T.Type) -> T? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController as? T {
            while let presentedViewController = topController.presentedViewController as? T {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    public static func getValue<T>(tablet: T, phone: T) -> T {
        return CurrentDevice.isTablet ? tablet : phone
    }
    
    public static let deviceType: DeviceType = {
        switch device {
        case .iPodTouch5,
             .iPodTouch6,
             .iPhone4,
             .iPhone4s,
             .iPhone5,
             .iPhone5c,
             .iPhone5s,
             .iPhoneSE,
             .simulator(_),
             .unknown(_),
             .iPhone6,
             .iPhone6Plus,
             .iPhone6s:
            return .mobileSmall
        case .iPhone6sPlus,
             .iPhone7,
             .iPhone7Plus,
             .iPhone8,
             .iPhone8Plus,
             .iPhoneX,
             .iPhoneXs,
             .iPhoneXsMax,
             .iPhoneXr,
             .homePod:
            return .mobileBig
        case .iPad2,
             .iPad3,
             .iPad4,
             .iPadAir,
             .iPadAir2,
             .iPad5,
             .iPadMini,
             .iPadMini2,
             .iPadMini3,
             .iPadMini4,
             .iPadPro9Inch,
             .iPadPro12Inch,
             .iPadPro12Inch2,
             .iPadPro10Inch,
             .iPad6,
             .iPadPro11Inch,
             .iPadPro12Inch3:
            return .tablet
        }
    }()
    
    public static func getFreeDiskSpaceInMb() -> Int64 {
        if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
            return space ?? 0 / 1_048_576
        } else {
            return 0
        }
    }
    
}
