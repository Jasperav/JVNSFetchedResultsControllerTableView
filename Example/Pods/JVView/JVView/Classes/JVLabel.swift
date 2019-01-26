import UIKit
import JVCurrentDevice
import JVContentType
import JVSizeable

open class JVLabel: UILabel, Sizeable {
    
    @IBInspectable public var contentTypeId: String = "" {
        didSet{
            contentType = contentTypeId.contentTypeJVLabel
            setContentType()
        }
    }
    
    public var contentType: ContentTypeJVLabel!
    public var holdsAttributedText = false
    
    public var width: CGFloat {
        get {
            return intrinsicContentSize.width
        }
    }
    
    public var height: CGFloat {
        get {
            return intrinsicContentSize.height
        }
    }
    
    public init(contentType: ContentTypeJVLabel) {
        super.init(frame: CGRect.zero)
        
        self.contentType = contentType
        setContentType()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func setContentType() {
        setText(nil, startUp: true)
        
        if contentType.textAligment == .right && CurrentDevice.isRightToLeftLanguage {
            textAlignment = .left
        }
    }
    
    public func setText(_ text: String?, startUp: Bool = false) {
        minimumScaleFactor = contentType.minimumScaleFactor
        if minimumScaleFactor != 0.0 {
            adjustsFontSizeToFitWidth = true
        }
        
        let _text: String
        
        if startUp {
            if let __text = self.text {
                _text = __text
            } else {
                _text = contentType.initialText ?? "Change me"
            }
        } else {
            _text = text ?? "Change me"
        }
        
        if let contentTypeJVLabelAttributedText = contentType as? ContentTypeJVLabelAttributedText {
            holdsAttributedText = true
            if text != nil {
                attributedText = ContentTypeAttributedText.createAttributedText(contentTypeAttributedText: contentTypeJVLabelAttributedText, customText: _text)?.attributedString
            }
        } else {
            let contentTypeText = contentType as! ContentTypeJVLabelText
            let contentTypeTextFont = contentTypeText.contentTypeTextFont!
            
            font = contentTypeTextFont.font
            textColor = contentTypeTextFont.color
            self.text = _text
        }
        
        numberOfLines = contentType.numberOfLines
        
        // If this isn't natural, the user may have initialized a uilabel through the interface with a different
        // textAligment than the acutal contentType.
        // To prevent subcontenting again, we ignore the content type's text aligment
        if textAlignment == .natural {
            textAlignment = contentType.textAligment
        }
    }
    
    public func setTextAligment(textAligment: NSTextAlignment) {
        self.textAlignment = textAligment
        mirrorAligmentIfRightToLeftLanguage()
    }
    
    public func getType() -> ContentTypeJVLabel {
        return contentType
    }
    
}
