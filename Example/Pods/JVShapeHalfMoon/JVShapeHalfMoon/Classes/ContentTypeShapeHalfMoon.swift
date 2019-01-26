import JVContentType

public struct ContentTypeShapeHalfMoon: ContentType {

    public static var allTypes = Set<ContentTypeShapeHalfMoon>()
    
    public var contentTypeId: String?
    public var gradient: CGColor
    public var gradientOnButtonClick: CGColor
    
    public init(contentTypeId: String?, gradient: CGColor, gradientOnButtonClick: CGColor) {
        self.contentTypeId = contentTypeId
        self.gradient = gradient
        self.gradientOnButtonClick = gradientOnButtonClick
    }
}
