import UIKit
import JVCAShapeLayerExtensions

open class ShapeHalfMoon: CAShapeLayer {
    
    private var contentType: ContentTypeShapeHalfMoon!
    
    public init(contentType: ContentTypeShapeHalfMoon) {
        super.init()
        self.contentType = contentType
        fillColor = contentType.gradient
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    open override func layoutSublayers() {
        super.layoutSublayers()
        self.path = nil
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: frame.height / 2))
        path.addQuadCurve(to: CGPoint(x: frame.width, y: frame.height / 2),
                          controlPoint: CGPoint(x: frame.width / 2,
                                                y: frame.height / 2 + frame.height / 3))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.close()
        
        self.path = path.cgPath
    }
    
    public func animateFillColorOnButtonClick(duration: CFTimeInterval?, autoreverse: Bool = false, repeatCount: Float? = nil) {
        animateFillColor(color: contentType.gradientOnButtonClick, duration: duration ?? 0)
    }
    
    public func animateFillColorToOriginal(duration: CFTimeInterval?, autoreverse: Bool = false, repeatCount: Float? = nil) {
        animateFillColor(color: contentType.gradient, duration: duration ?? 0)
    }
    
}
