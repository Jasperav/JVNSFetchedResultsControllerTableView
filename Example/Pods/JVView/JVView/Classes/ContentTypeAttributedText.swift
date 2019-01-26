import UIKit
import JVCurrentDevice
import JVContentType
import JVFontUtils

open class ContentTypeAttributedText {
    
    public static var allTypes = [ContentTypeAttributedText]()
    
    public let contentTypeId: String?
    public let contentTypeTextFont: ContentTypeTextFont
    public let rangeStart: Int?
    public let rangeEnd: Int?
    
    /// keep rangeStart and rangeEnd nil to base it on the linebreaks (\n)
    public init(contentTypeId: String?, contentTypeTextFont: ContentTypeTextFont, rangeStart: Int?, rangeEnd: Int?) {
        self.contentTypeId = contentTypeId
        self.contentTypeTextFont = contentTypeTextFont
        self.rangeStart = rangeStart
        self.rangeEnd = rangeEnd
    }
    
    public static func createAttributedText(contentTypeAttributedText contentType: ContentTypeJVLabelAttributedText,
                                            customText: String? = nil)
        -> (attributedString: NSAttributedString, height: CGFloat, width: CGFloat)? {
        var text: String? = nil
        
        if let customText = customText {
            text = customText
        } else if let initialText = contentType.initialText {
            text = initialText
        }
        guard let _text = text else { return nil }
        
        let attributedText = NSMutableAttributedString.init(string: _text)
        var rangeStart = 0
        var height: CGFloat = 0
        var width: CGFloat = 0
        
        for contentTypeAttributedText in contentType.contentTypeAttributedTexts {
            let rangeEnd: Int
            
            rangeStart = contentTypeAttributedText.rangeStart ?? rangeStart // if nil, calculate the indexes of linebreaks.
            
            if let _rangeEnd = contentTypeAttributedText.rangeEnd {
                rangeEnd = _rangeEnd
            } else {  // Base the rangeEnd on linebreaks.
                let textThatHasNotBeenAttributed = _text.suffix(_text.count - rangeStart)
                let lineBreakIndex = textThatHasNotBeenAttributed.index(of: "\n")?.encodedOffset ?? textThatHasNotBeenAttributed.count
                rangeEnd = lineBreakIndex
            }
            
            attributedText.addAttributes([NSAttributedString.Key.font: contentTypeAttributedText.contentTypeTextFont.font,
                                          NSAttributedString.Key.foregroundColor: contentTypeAttributedText.contentTypeTextFont.color],
                                         range: NSMakeRange(rangeStart, rangeEnd))
            
            let subString = _text.suffix(_text.count - rangeStart).prefix(rangeEnd)
            
            width = max(JVFontUtils.determineWidth(font: contentTypeAttributedText.contentTypeTextFont.font, text: String(subString)), width)
            height += JVFontUtils.determineHeight(font: contentTypeAttributedText.contentTypeTextFont.font, text: String(subString))
            
            rangeStart = rangeEnd + 1
        }
        
        return (attributedString: attributedText, height: height, width: width)
    }
    
    public static func getContentType(contentTypeId: String) -> ContentTypeAttributedText {
        return ContentTypeAttributedText.allTypes.first { $0.contentTypeId! == contentTypeId }!
    }
    
    public func addToAllTypes() {
        assert(contentTypeId != nil)
        assert(!ContentTypeAttributedText.allTypes.contains { $0.contentTypeId! == contentTypeId })
        ContentTypeAttributedText.allTypes.append(self)
    }
    
}

