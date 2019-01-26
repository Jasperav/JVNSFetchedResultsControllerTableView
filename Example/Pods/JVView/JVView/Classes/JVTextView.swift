import UIKit

open class JVTextView: UITextView {
    
    @IBInspectable public var contentTypeId: String = "" {
        didSet{
            contentType = contentTypeId.contentTypeTextView
            setContentType()
        }
    }
    
    public var contentType: ContentTypeTextView!
    
    public init(contentType: ContentTypeTextView, textContainer: NSTextContainer? = nil) {
        super.init(frame: CGRect.zero, textContainer: textContainer)
        
        self.contentType = contentType
        setContentType()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setContentType() {
        font = contentType.contentTypeTextFont.font
    }
    
}
