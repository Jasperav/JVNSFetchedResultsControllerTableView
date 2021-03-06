import UIKit
import JVView
import JVConstraintEdges

open class MiddleTextView: UIView {
    
    /// Content type for the label
    public static var contentType: ContentTypeJVLabelText!
    
    private static let constraintEdgesWidth: CGFloat = 5
    private static let spacingFromMiddle: CGFloat = 5
    
    public let startMode: StartMode?
    
    public var isQueryable: Bool {
        return queryingText != nil
    }
    
    private let notQueryingText: String
    private let queryingText: String?
    private let label: JVLabel
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)
    
    public init(notQueryingText: String, startMode: StartMode? = nil) {
        self.notQueryingText = notQueryingText
        self.queryingText = startMode?.queryingText
        label = JVLabel(contentType: MiddleTextView.contentType)
        self.startMode = startMode
        
        super.init(frame: CGRect.zero)
        
        addLabel()
        
        if queryingText != nil {
            addLoadingIndicator()
        }
        
        change(mode: startMode?.startMode ?? .notQuerying)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func change(mode: Mode) {
        switch mode {
        case .notQuerying:
            label.text = notQueryingText
            loadingIndicator.stopAnimating()
        case .querying:
            label.text = queryingText!
            loadingIndicator.startAnimating()
        }
    }
    
    private func addLabel() {
        let edges = ConstraintEdges(width: MiddleTextView.constraintEdgesWidth, setHeightToNil: true)
        
        label.fill(toSuperview: self, edges: edges)
        label.topAnchor.constraint(equalTo: centerYAnchor, constant: MiddleTextView.spacingFromMiddle).isActive = true
        label.textAlignment = .center
    }
    
    private func addLoadingIndicator() {
        loadingIndicator.addAsSubview(to: self)
        
        loadingIndicator.spacing(from: .bottom, to: .top, view: label, constant: MiddleTextView.spacingFromMiddle)
        loadingIndicator.setSameCenterX(view: self)
    }

}


