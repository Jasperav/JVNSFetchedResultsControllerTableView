import UIKit
import JVCAGradientLayerExtensions

open class JVGradientLayer: CAGradientLayer {
    
    private var contentType: [ContentTypeJVGradientLayer]!
    
    public override init() {
        super.init()
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public init(contentType: [ContentTypeJVGradientLayer], contentTypePoint: ContentTypeJVGradientLayerPoint? = nil, setColorsInstant: Bool = true) {
        super.init()
        
        if let _contentTypePoint = contentTypePoint {
            startPoint = _contentTypePoint.startPoint
            endPoint = _contentTypePoint.endPoint
        } else {
            startPoint = CGPoint.zero
            endPoint = CGPoint(x: 1, y: 1)
        }
        
        setContentType(contentType: contentType, setColorsInstant: setColorsInstant)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getColors() -> [CGColor] {
        return contentType.map { $0.color }
    }
    
    public func setContentType(contentType: [ContentTypeJVGradientLayer], setColorsInstant: Bool = true) {
        self.contentType = contentType
        
        guard contentType.count > 1 else {
            locations = [0.0, 1.0]
            if setColorsInstant {
                colors = [contentType[0].color, contentType[0].color]
            } else {
                animateColors(colors: clearColors, duration: nil)
            }
            return
        }
        // The gradient locations should ALWAYS go from smallest value to biggest value
        locations = contentType.map { $0.gradientLocation }.sorted(by: {$0.doubleValue < $1.doubleValue})

        if setColorsInstant {
            colors = contentType.map { $0.color }
        } else {
            animateColors(colors: clearColors, duration: nil)
        }
    }
    
    public func animateColors(duration: TimeInterval?, autoreverse: Bool = false) {
        animateColors(colors: contentType.map {$0.color }, duration: duration, autoreverse: autoreverse)
    }
    
    private var clearColors: [CGColor] {
        get {
            let colorsCount = self.locations?.count ?? 0
            var colors = [UIColor]()
            for _ in 0..<colorsCount {
                colors.append(UIColor.clear)
            }
            
            return colors.map { $0.cgColor }
        }
    }
    
}

