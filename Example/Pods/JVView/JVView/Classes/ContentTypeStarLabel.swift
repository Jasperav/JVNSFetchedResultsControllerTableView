import JVContentType
import JVFontUtils

open class ContentTypeJVLabel: Copyable {
    
    public static var allTypes = Set<ContentTypeJVLabel>()
    
    public let contentTypeId: String?
    public var textAligment: NSTextAlignment = .natural
    public var initialText: String?
    public var numberOfLines = 1
    public var minimumScaleFactor: CGFloat = 0.0
    
    private enum CodingKeys: CodingKey {
        case contentTypeId, initialText, numberOfLines
    }
    
    public required init(old: ContentTypeJVLabel, contentTypeId: String?) {
        self.contentTypeId = contentTypeId
        initialText = old.initialText
        numberOfLines = old.numberOfLines
        textAligment = old.textAligment
        minimumScaleFactor = old.minimumScaleFactor
        assert(type(of: self) != ContentTypeJVLabel.self, "This class is a fake abstract class, please use a subclass")
    }
    
    /// This initializer is internal because this class is an fake abstract class
    internal init(contentTypeId: String?,
                  textAligment: NSTextAlignment = .natural,
                  initialText: String? = nil,
                  numberOfLines: Int = 1) {
        self.contentTypeId = contentTypeId
        self.textAligment = textAligment
        self.initialText = initialText
        self.numberOfLines = numberOfLines
    }
    
    /// This initializer is internal because this class is an fake abstract class
    init(contentTypeId: String?) {
        self.contentTypeId = contentTypeId
    }
    
    public static func getContentType(contentTypeId: String) -> ContentTypeJVLabel {
        return ContentTypeJVLabel.allTypes.first { $0.contentTypeId! == contentTypeId }!
    }
    
    public static func getInitialText(contentTypeId: String) -> String {
        return getContentType(contentTypeId: contentTypeId).initialText ?? ""
    }
    
    public static func getContentTextFonts(contentTypeId: String) -> [ContentTypeTextFont] {
        let contentType = getContentType(contentTypeId: contentTypeId)
        
        if let contentTypeJVLabelText = contentType as? ContentTypeJVLabelText {
            return [contentTypeJVLabelText.contentTypeTextFont]
        } else {
            let contentTypeJVLabelAttributedText = contentType as! ContentTypeJVLabelAttributedText
            return contentTypeJVLabelAttributedText.contentTypeAttributedTexts.map { $0.contentTypeTextFont }
        }
    }
    
    public static func getSizeText(contentTypeLabel: ContentTypeJVLabel, customText: String? = nil) -> (height: CGFloat, width: CGFloat) {
        let text = customText == nil ? contentTypeLabel.initialText! : customText!
        
        if let contentTypeLabelText = contentTypeLabel as? ContentTypeJVLabelText {
            let textFont = contentTypeLabelText.contentTypeTextFont!
            let height = JVFontUtils.determineHeight(font: textFont.font, text: text)
            let width = JVFontUtils.determineWidth(font: textFont.font, text: text)
            return (height: height, width: width)
        } else {
            let contentTypeLabelTextAttributed = contentTypeLabel as! ContentTypeJVLabelAttributedText
            let attributedText = ContentTypeAttributedText.createAttributedText(contentTypeAttributedText: contentTypeLabelTextAttributed, customText: text)
            
            return (height: attributedText!.height, width: attributedText!.width)
        }
    }
    
    public func addToAllTypes() {
        assert(!ContentTypeJVLabel.allTypes.contains(self))

        ContentTypeJVLabel.allTypes.insert(self)
    }
    
}


extension ContentTypeJVLabel: Hashable {
    public static func == (lhs: ContentTypeJVLabel, rhs: ContentTypeJVLabel) -> Bool {
        return lhs.contentTypeId! == rhs.contentTypeId!
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentTypeId!)
    }
}
