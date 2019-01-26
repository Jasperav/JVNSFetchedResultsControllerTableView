import UIKit

open class JVLabelCounter: JVLabel {
    
    public var format = "%f"
    public var animationDuration: TimeInterval!
    public var formatBlock: ((CGFloat) -> String)!
    public var attributedFormatBlock: ((CGFloat) -> NSAttributedString)?
    public var completionBlock: (() -> Void)?
    public var isAnimating = false
    
    private var startingValue: CGFloat!
    private var destinationValue: CGFloat!
    private var progress: TimeInterval = 0
    private var lastUpdate: TimeInterval!
    private var totalTime: TimeInterval!
    private var timer: CADisplayLink?
    private var counter: UILabelCounter!
    private var frameRate: Int!
    
    open override func setContentType() {
        super.setContentType()
        let contentTypeJVLabelCountingLabel: ContentTypeJVLabelCountingLabel
        
        if let contentTypeJVLabelTextCountingLabel = contentType as? ContentTypeJVLabelTextCountingLabel {
            contentTypeJVLabelCountingLabel = contentTypeJVLabelTextCountingLabel.contentTypeJVLabelCountingLabel!
        } else {
            contentTypeJVLabelCountingLabel = (contentType as! ContentTypeJVLabelAttributedTextCountingLabel).contentTypeJVLabelCountingLabel!
        }
        
        
        self.frameRate = contentTypeJVLabelCountingLabel.frameRate
        self.animationDuration = contentTypeJVLabelCountingLabel.animationDuration
        
        switch contentTypeJVLabelCountingLabel.animationType {
        case .easeIn:
            self.counter = UILabelCounterEaseIn()
        case .easeOut:
            self.counter = UILabelCounterEaseOut()
        case .easeInOut:
            self.counter = UILabelCounterEaseInOut()
        case .linear:
            self.counter = UILabelCounterLinear()
        }
        
        let formatter = contentTypeJVLabelCountingLabel.formatter
        
        if holdsAttributedText {
            if let _formatter = formatter as? DateComponentsFormatter {
                self.attributedFormatBlock = { (value) in
                    return ContentTypeAttributedText.createAttributedText(contentTypeAttributedText: (self.contentType as! ContentTypeJVLabelAttributedText), customText: _formatter.string(from: TimeInterval(value)) ?? "")!.attributedString
                }
            } else {
                self.attributedFormatBlock = { (value) in
                    return ContentTypeAttributedText.createAttributedText(contentTypeAttributedText: (self.contentType as! ContentTypeJVLabelAttributedText), customText: formatter.string(for: value as NSNumber) ?? "")!.attributedString
                }
            }
        } else {
            if let _formatter = formatter as? DateComponentsFormatter {
                self.formatBlock = { (value) in
                    return _formatter.string(from: TimeInterval(value)) ?? ""
                }
            } else {
                self.formatBlock = { (value) in
                    return formatter.string(for: value as NSNumber) ?? ""
                }
            }
        }
        
        guard let text = contentType.initialText else { return }
        
        // The text can not be converted to a double if the users language is in arabic.
        // That's why the ?? 0 has been added.
        countFromZeroTo(CGFloat(Double(text) ?? 0), withDuration: 0.01) // This has to be done else the coutner always starts the first time with value 0
    }
    
    public func removeTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func updateText(_ text: CGFloat) {
        if holdsAttributedText {
            attributedText = attributedFormatBlock!(text)
        } else {
            self.text = formatBlock(text)
        }
    }
    
    private func setFormat(_ format: String) {
        self.format = format
        self.updateText(self.currentValue())
    }
    
    private func runCompletionBlock() {
        if let tryCompletionBlock = self.completionBlock {
            tryCompletionBlock()
            
            self.completionBlock = nil
        }
    }
}

// MARK: Counter functions
extension JVLabelCounter {
    
    public func countFrom(_ startValue: CGFloat, to endValue: CGFloat, withDuration duration: TimeInterval) {
        self.isAnimating = true
        self.startingValue = startValue
        self.destinationValue = endValue
        
        // remove any (possible) old timers
        self.timer?.invalidate()
        self.timer = nil
        
        if duration == 0.0 {
            // No animation
            self.updateText(endValue)
            self.isAnimating = false
            self.runCompletionBlock()
            return
        }
        self.progress = 0
        self.totalTime = duration
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        let timer = CADisplayLink(target: self, selector: #selector(JVLabelCounter.updateValue(_:)))
        timer.preferredFramesPerSecond = frameRate
        timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        timer.add(to: RunLoop.main, forMode: RunLoop.Mode.tracking)
        self.timer = timer
    }
    
    public func countFromCurrentValueTo(_ endValue: CGFloat) {
        self.countFrom(self.currentValue(), to: endValue)
    }
    
    public func countFromCurrentValueTo(_ endValue: CGFloat, withDuration duration: TimeInterval) {
        self.countFrom(self.currentValue(), to: endValue, withDuration: duration)
    }
    
    public func countFromZeroTo(_ endValue: CGFloat) {
        self.countFrom(0, to: endValue)
    }
    
    public func countFromZeroTo(_ endValue: CGFloat, withDuration duration: TimeInterval) {
        self.countFrom(0, to: endValue, withDuration: duration)
    }
    
    public func currentValue() -> CGFloat {
        if self.progress == 0 {
            return 0
        } else if self.progress >= self.totalTime {
            return self.destinationValue
        }
        
        let percent = self.progress / self.totalTime
        let updateVal = self.counter.update(CGFloat(percent))
        
        return self.startingValue + updateVal * (self.destinationValue - self.startingValue)
    }
    
    @objc public func updateValue(_ timer: Timer) {
        let now = Date.timeIntervalSinceReferenceDate
        self.progress = self.progress + now - self.lastUpdate
        self.lastUpdate = now
        
        if self.progress >= self.totalTime {
            self.timer?.invalidate()
            self.timer = nil
            self.progress = self.totalTime
        }
        
        self.updateText(self.currentValue())
        
        if self.progress == self.totalTime {
            self.isAnimating = false
            self.runCompletionBlock()
        }
    }
    
    public func countFrom(_ startValue: CGFloat, to endValue: CGFloat) {
        self.countFrom(startValue, to: endValue, withDuration: self.animationDuration)
    }
    
     /// Retrieves the text formatted in an integer. Be careful calling this function.
    public var textNumber: Int {
        get {
            return Int(text!)!
        }
    }
}



