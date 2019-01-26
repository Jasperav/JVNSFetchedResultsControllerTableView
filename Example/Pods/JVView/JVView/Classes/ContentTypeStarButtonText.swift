import JVConstraintEdges
import JVShapeHalfMoon
import JVGradientLayer

open class ContentTypeJVButtonText: ContentTypeJVButton {
    
    public var contentTypeTextEdges: ContentTypeTextFontEdges!
    
    public init(contentTypeId: String?, contentTypeTextEdgesId: String, animationClickDuration: TimeInterval?, contentTypeGrow: ContentTypeJVButtonGrow?, contentTypeBackgroundLayer: [ContentTypeJVGradientLayer]?, contentTypeBackgroundLayerPoint: ContentTypeJVGradientLayerPoint?, tapHandler: (() -> ())?) {
        contentTypeTextEdges = ContentTypeTextFontEdges.getContentType(contentTypeId: contentTypeTextEdgesId)
        
        super.init(contentTypeId: contentTypeId, animationClickDuration: animationClickDuration, contentTypeGrow: contentTypeGrow, contentTypeBackgroundLayer: contentTypeBackgroundLayer, contentTypeBackgroundLayerPoint: contentTypeBackgroundLayerPoint, tapHandler: tapHandler)
    }
    
    public required init(old: ContentTypeJVButton, contentTypeId: String?) {
        super.init(old: old, contentTypeId: contentTypeId)
        
        contentTypeTextEdges = (old as? ContentTypeJVButtonText)?.contentTypeTextEdges
    }
    
}
