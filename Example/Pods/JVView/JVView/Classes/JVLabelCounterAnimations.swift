import UIKit

public enum CountingAnimationType {
    case easeIn, easeOut, easeInOut, linear
    public static var allTypes: [CountingAnimationType] = [easeIn, easeOut, easeInOut, linear]
}

//MARK: - UILabelCounter
let kUILabelCounterRate = Float(3)

public protocol UILabelCounter {
    func update(_ t: CGFloat) -> CGFloat
}

public class UILabelCounterLinear: UILabelCounter {
    public func update(_ t: CGFloat) -> CGFloat {
        return t
    }
}

public class UILabelCounterEaseIn: UILabelCounter {
    public func update(_ t: CGFloat) -> CGFloat {
        return CGFloat(powf(Float(t), kUILabelCounterRate))
    }
}

public class UILabelCounterEaseOut: UILabelCounter {
    public func update(_ t: CGFloat) -> CGFloat {
        return CGFloat(1.0 - powf(Float(1.0 - t), kUILabelCounterRate))
    }
}

public class UILabelCounterEaseInOut: UILabelCounter {
    public func update(_ t: CGFloat) -> CGFloat {
        let newt: CGFloat = 2 * t
        if newt < 1 {
            return CGFloat(0.5 * powf (Float(newt), kUILabelCounterRate))
        } else {
            return CGFloat(0.5 * (2.0 - powf(Float(2.0 - newt), kUILabelCounterRate)))
        }
    }
}
