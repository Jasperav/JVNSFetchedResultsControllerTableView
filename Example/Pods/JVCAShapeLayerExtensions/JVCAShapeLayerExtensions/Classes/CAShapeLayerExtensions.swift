public extension CAShapeLayer {
    public func animateFillColor(color: CGColor, duration: TimeInterval, delay: TimeInterval? = nil) {
        let currentFillColor = self.fillColor ?? UIColor.clear.cgColor
        let animation = CABasicAnimation(keyPath: "fillColor")
        
        self.fillColor = color
        
        animation.fromValue = currentFillColor
        animation.toValue = color
        animation.duration = duration
        
        if let delay = delay {
            animation.beginTime = CACurrentMediaTime() + delay
        }
        
        add(animation, forKey: "fillColor")
    }
    
    public func animateStrokeColor(color: CGColor, duration: TimeInterval, delay: TimeInterval? = nil) {
        let currentStrokeColor = self.strokeColor ?? UIColor.clear.cgColor
        let animation = CABasicAnimation(keyPath: "strokeColor")
        
        self.strokeColor = color
        
        animation.fromValue = currentStrokeColor
        animation.toValue = color
        animation.duration = duration
        
        if let delay = delay {
            animation.beginTime = CACurrentMediaTime() + delay
        }
        
        add(animation, forKey: "strokeColor")
    }
    
}
