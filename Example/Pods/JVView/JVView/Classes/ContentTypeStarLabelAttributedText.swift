import JVContentType

open class ContentTypeJVLabelAttributedText: ContentTypeJVLabel {
    
    public var contentTypeAttributedTexts: [ContentTypeAttributedText]!
    
    public init(contentTypeId: String?,
                contentTypeAttributedTexts: [ContentTypeAttributedText]!,
                textAligment: NSTextAlignment = .natural,
                initialText: String? = nil,
                numberOfLines: Int = 1) {
        self.contentTypeAttributedTexts = contentTypeAttributedTexts
        
        super.init(contentTypeId: contentTypeId, textAligment: textAligment, initialText: initialText, numberOfLines: numberOfLines)
    }
    
    public required init(old: ContentTypeJVLabel, contentTypeId: String?) {
        super.init(old: old, contentTypeId: contentTypeId)
        
        contentTypeAttributedTexts = (old as? ContentTypeJVLabelAttributedText)?.contentTypeAttributedTexts
    }
    
}
