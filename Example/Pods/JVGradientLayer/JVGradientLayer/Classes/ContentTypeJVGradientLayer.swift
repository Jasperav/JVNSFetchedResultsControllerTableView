import JVContentType

public struct ContentTypeJVGradientLayer: ContentTypeGroup {
    
    public static var allTypes = Set<ContentTypeJVGradientLayer>()
    
    public var contentTypeId: String?
    public var contentTypeGroupId: [String]?
    public var color: CGColor
    public var gradientLocation: NSNumber
    public var startPoint: CGPoint?
    public var endPoint: CGPoint?
    
    public init(color: CGColor, location: NSNumber) {
        self.init(contentTypeId: nil, contentTypeGroupId: nil, color: color, gradientLocation: location, startPoint: nil, endPoint: nil)
    }
    
    public init(contentTypeId: String?, contentTypeGroupId: [String]?, color: CGColor, gradientLocation: NSNumber, startPoint: CGPoint?, endPoint: CGPoint?) {
        self.contentTypeId = contentTypeId
        self.contentTypeGroupId = contentTypeGroupId
        self.color = color
        self.gradientLocation = gradientLocation
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
}
