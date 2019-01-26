import JVContentType

public struct ContentTypeJVGradientLayerPoint: ContentType {
    
    public static var allTypes = Set<ContentTypeJVGradientLayerPoint>()
    
    public var contentTypeId: String?
    public var startPoint: CGPoint
    public var endPoint: CGPoint
    
    public init(contentTypeId: String?, startPoint: CGPoint, endPoint: CGPoint) {
        self.contentTypeId = contentTypeId
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
