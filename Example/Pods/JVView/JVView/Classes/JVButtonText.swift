import UIKit
import JVCurrentDevice
import JVGradientLayer

open class JVButtonText: JVButton {
    
    public var contentTypeText: ContentTypeJVButtonText!
    
    override open func setContentType() {
        super.setContentType()
        
        contentTypeText = (contentType as! ContentTypeJVButtonText)
        titleLabel?.font = contentTypeText.contentTypeTextEdges.contentTypeTextFont.font
        titleLabel?.textColor = contentTypeText.contentTypeTextEdges.contentTypeTextFont.color
        contentEdgeInsets = contentTypeText.contentTypeTextEdges.textEdges.toEdgeRectInsets()
    }
    
    open override var width: CGFloat {
        get {
            return (titleLabel?.intrinsicContentSize.width ?? 0)
                + contentTypeText.contentTypeTextEdges.textEdges.width
                + layer.borderWidth / 2
        }
    }
    
    open override var height: CGFloat {
        get {
            return (titleLabel?.intrinsicContentSize.height ?? 0)
                + contentTypeText.contentTypeTextEdges.textEdges.height
                + layer.borderWidth / 2
        }
    }

}
