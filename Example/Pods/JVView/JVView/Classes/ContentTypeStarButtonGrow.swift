import JVContentType

public struct ContentTypeJVButtonGrow: ContentType {

    public static var allTypes = Set<ContentTypeJVButtonGrow>()
    
    public var contentTypeId: String?
    public let addSize: CGSize
    
    public init(contentTypeId: String?, addSize: CGSize) {
        self.contentTypeId = contentTypeId
        self.addSize = addSize
    }

}
