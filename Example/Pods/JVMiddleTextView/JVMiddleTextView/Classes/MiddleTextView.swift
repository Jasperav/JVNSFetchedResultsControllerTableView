import UIKit
import JVView
import JVConstraintEdges

open class MiddleTextView: UIView {
    
    public static var contentType: ContentTypeJVLabelText!
    public static var constraintEdges: ConstraintEdges!
    
    public init(text: String) {
        super.init(frame: CGRect.zero)
        
        let label = JVLabel(contentType: MiddleTextView.contentType)
        
        label.fill(toSuperview: self, edges: MiddleTextView.constraintEdges)
        label.text = text
        label.textAlignment = .center
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
