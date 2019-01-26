import UIKit
import JVContentType
import JVSizeable
import JVRestartable

// This is a button without a text, but for example a picture
// Some touch events have a === check.
open class JVButton: UIButton, Sizeable, Restartable {

    @IBInspectable var contentTypeId: String = "" {
        didSet {
            self.contentType = contentTypeId.contentTypeJVButton
            setContentType()
        }
    }
    
    /// Tap handler for touch up inside events
    public var tapHandler: (() -> ())?
    
    /// Tap handler for touch down events
    public var tapHandlerTouchDown: (() -> ())?
    
    public var tapHandlerTouchUpOutside: (() -> ())?
    public var contentType: ContentTypeJVButton!
    public var onTouchDownGrowInSize: CGSize?
    
    /// If this is true, the view that needs to be animated will grow in and shrink with an animation
    /// after a touch up events has occured.
    /// If this property is set to true, make sure the contentType has a non-nil value of growByAnimation
    public var restartGrowByAnimationOnTouchUp = false
    
    /// For this specific class, this value is only accurate when the view has layed out this view. For this subclasses, this width is overridden and returns the correct value at compile time.
    open var width: CGFloat {
        get {
            return getViewToAnimate().frame.width
        }
    }
    
    /// For this specific class, this value is only accurate when the view has layed out this view. For this subclasses, this width is overridden and returns the correct value at compile time.
    open var height: CGFloat {
        get {
            return getViewToAnimate().frame.height
        }
    }
    
    /// This is used in StarUIView.
    public weak var delegate: JVButtonDelegate?
    public weak var viewToAnimate: UIView?
    
    public init(contentType: ContentTypeJVButton) {
        super.init(frame: CGRect.zero)
        
        self.contentType = contentType
        setContentType()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func getViewToAnimate() -> UIView {
        return viewToAnimate != nil ? viewToAnimate! : self
    }
    
    open func setContentType() {
        addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchDragOutside)
        addTarget(self, action: #selector(touchDragInside(_:)), for: .touchDragEnter)
        addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchCancel)
        
        self.tapHandler = contentType.tapHandler
        
        if let contentTypeGrow = contentType.contentTypeGrow {
            onTouchDownGrowInSize = contentTypeGrow.addSize
        }
        
    }
    
    open func touchUp(_ sender: UIButton) {
        delegate?.touchUp(self)
    }
    
    @objc open func touchUpInside(_ sender: UIButton) {
        tapHandler?()
        touchUp(sender)
        touchUpOutside(UIButton())
    }
    
    @objc open func touchUpOutside(_ sender: UIButton) {
        if contentType.growByAnimation != nil {
            startGrowAndShrinkAnimation()
        } else if onTouchDownGrowInSize != nil {
            UIView.animate(withDuration: contentType.animationClickDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                self.getViewToAnimate().transform = CGAffineTransform.identity
            })
        }
        if self === sender {
            touchUp(sender)
            tapHandlerTouchUpOutside?()
        }
    }
    
    @objc open func touchDragInside(_ sender: UIButton) {
        if (sender === self) {
            touchDown(self)
        }
        guard let growSize = onTouchDownGrowInSize else  { return }
        
        let currentWidth = width
        let currentHeight = height
        
        let relativeGrowWidth = 1 + ((currentWidth + growSize.width) - currentWidth) / currentWidth
        let relativeGrowHeight = 1 + ((currentHeight + growSize.height) - currentHeight) / currentHeight
        
        self.getViewToAnimate().layer.removeAllAnimations()
        
        // We do not take the value of contentType.animationClickDuration because that lags like shit
        // We do however use this value when a touch up event occurs.
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: {
            self.getViewToAnimate().transform = CGAffineTransform(scaleX: relativeGrowWidth, y: relativeGrowHeight)
        })
    }
    
    @objc open func touchDown(_ sender: UIButton) {
        delegate?.touchDown(self)
        tapHandlerTouchDown?()
        touchDragInside(UIButton())
    }
    
    public func startGrowAndShrinkAnimation() {
        guard let growByAnimation = contentType.growByAnimation else { return }
        // This needs to be done else the startGrowAndShrinkAnimation() wont animate when resuming for the seconds time and later.
        self.getViewToAnimate().transform = CGAffineTransform.identity
        UIView.animate(withDuration: growByAnimation.duration,
                       delay: 0.0,
                       options: [.autoreverse, .repeat],
                       animations: {
            self.getViewToAnimate().transform = CGAffineTransform(scaleX: growByAnimation.scaleBy, y: growByAnimation.scaleBy)
        })
    }
    
    public func pause() {
        self.getViewToAnimate().layer.removeAllAnimations()
    }
    
    public func resume() {
        startGrowAndShrinkAnimation()
    }
    
}
