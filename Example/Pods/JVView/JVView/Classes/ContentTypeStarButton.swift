import JVShapeHalfMoon
import JVConstraintEdges
import JVGradientLayer
import JVContentType
import JVRestartable

open class ContentTypeJVButton: Copyable {
    
    public static var allTypes = Set<ContentTypeJVButton>()
    
    public var contentTypeId: String?
    public var animationClickDuration: TimeInterval!
    public var contentTypeGrow: ContentTypeJVButtonGrow?
    public var contentTypeBackgroundLayer: [ContentTypeJVGradientLayer]?
    public var contentTypeBackgroundLayerPoint: ContentTypeJVGradientLayerPoint?
    public var growByAnimation: (duration: TimeInterval, scaleBy: CGFloat)?
    public var tapHandler: (() -> ())?
    
    public init(contentTypeId: String?, animationClickDuration: TimeInterval? = nil, contentTypeGrow: ContentTypeJVButtonGrow? = nil, contentTypeBackgroundLayer: [ContentTypeJVGradientLayer]? = nil, contentTypeBackgroundLayerPoint: ContentTypeJVGradientLayerPoint? = nil, tapHandler: (() -> ())? = nil) {
        self.contentTypeId = contentTypeId
        self.animationClickDuration = animationClickDuration
        self.contentTypeGrow = contentTypeGrow
        self.contentTypeBackgroundLayer = contentTypeBackgroundLayer
        self.contentTypeBackgroundLayerPoint = contentTypeBackgroundLayerPoint
        self.tapHandler = tapHandler
    }
    
    public required init(old: ContentTypeJVButton, contentTypeId: String?) {
        self.contentTypeId = contentTypeId
        animationClickDuration = old.animationClickDuration
        contentTypeGrow = old.contentTypeGrow?.copy()
        contentTypeBackgroundLayer = old.contentTypeBackgroundLayer?.copy()
        contentTypeBackgroundLayerPoint = old.contentTypeBackgroundLayerPoint
        growByAnimation = old.growByAnimation
        tapHandler = old.tapHandler
    }
    
    public func addToAllTypes() {
        assert(!ContentTypeJVButton.allTypes.contains(self))
        
        ContentTypeJVButton.allTypes.insert(self)
    }
    
    static func getContentType(contentTypeId: String) -> ContentTypeJVButton {
        return ContentTypeJVButton.allTypes.first(where: { $0.contentTypeId == contentTypeId })!
    }
}

extension ContentTypeJVButton: Hashable {
    public static func == (lhs: ContentTypeJVButton, rhs: ContentTypeJVButton) -> Bool {
        return lhs.contentTypeId! == rhs.contentTypeId!
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentTypeId!)
    }
    
}
