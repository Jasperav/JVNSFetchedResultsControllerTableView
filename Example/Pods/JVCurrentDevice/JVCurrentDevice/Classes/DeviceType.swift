public enum DeviceType {
    case mobileSmall, mobileBig, tablet
    
    public static let allTypes: [DeviceType] = [mobileSmall,
                                                mobileBig,
                                                tablet]
    
    public var dimensions: String {
        get {
            switch self {
            case .mobileSmall:
                return "@2x"
            case .mobileBig:
                return "@3x"
            case .tablet:
                return "@2x_tablet"
            }
        }
    }
}
