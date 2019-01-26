import UIKit

public extension CAGradientLayer {
    
    // Add an animation that when autoreversing is true and this method gets called again, the current colors should be taken into the start animation
    public func animateColors(colors: [CGColor], duration: CFTimeInterval?, autoreverse: Bool = false) {
        let currentColor = self.colors
        
        guard let duration = duration, duration > 0.0 else {
            self.colors = colors
            return
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        self.colors = colors
        
        if autoreverse {
            CATransaction.setCompletionBlock { [weak self] in
                Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak self] (_)  in
                    self?.animateColors(colors: currentColor as! [CGColor], duration: duration, autoreverse: true)
                })
            }
        }
        
        CATransaction.commit()
    }
    
    public func getColors(color: CGColor) -> [CGColor] {
        let count = locations?.count ?? 0
        var colors = [CGColor]()
        
        for _ in 0..<count {
            colors.append(color)
        }
        return colors
    }
    
    public func animateColor(color: CGColor, duration: CFTimeInterval?) {
        let colors = getColors(color: color)
        
        animateColors(colors: colors, duration: duration)
    }
    
}
