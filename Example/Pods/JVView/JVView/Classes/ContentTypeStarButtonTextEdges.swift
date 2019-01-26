import JVConstraintEdges

open class ContentTypeTextFontEdgesJVButtonText: ContentTypeTextFontEdges {
    public let contentTypeJVButtonText: ContentTypeJVButtonText
    
    public init(contentTypeId: String?, contentTypeTextFont: ContentTypeTextFont, textEdges: ConstraintEdges, contentTypeJVButtonText: ContentTypeJVButtonText) {
        self.contentTypeJVButtonText = contentTypeJVButtonText
        super.init(contentTypeId: contentTypeId, contentTypeTextFont: contentTypeTextFont, textEdges: textEdges)
    }
}
