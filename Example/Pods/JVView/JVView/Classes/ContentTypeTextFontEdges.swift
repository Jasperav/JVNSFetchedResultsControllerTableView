import JVConstraintEdges
import JVContentType

open class ContentTypeTextFontEdges {
    
    public static var allTypes = Set<ContentTypeTextFontEdges>()
    
    public var contentTypeId: String?
    public let contentTypeTextFont: ContentTypeTextFont
    public let textEdges: ConstraintEdges
    
    public init(contentTypeId: String?, contentTypeTextFont: ContentTypeTextFont, textEdges: ConstraintEdges) {
        self.contentTypeId = contentTypeId
        self.contentTypeTextFont = contentTypeTextFont
        self.textEdges = textEdges
    }
    
    public static func getContentType(contentTypeId: String) -> ContentTypeTextFontEdges {
        return allTypes.first { $0.contentTypeId! == contentTypeId }!
    }
    
    func addToAllTypes() {
        assert(!ContentTypeTextFontEdges.allTypes.contains(self))
        
        ContentTypeTextFontEdges.allTypes.insert(self)
    }
}

extension ContentTypeTextFontEdges: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentTypeId!)
    }
    
    public static func == (lhs: ContentTypeTextFontEdges, rhs: ContentTypeTextFontEdges) -> Bool {
        return lhs.contentTypeId! == rhs.contentTypeId!
    }
}
