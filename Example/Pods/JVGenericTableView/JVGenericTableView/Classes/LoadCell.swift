import UIKit
import JVConstraintEdges

open class LoadCell: UITableViewCell {
    
    let indicator = UIActivityIndicatorView(style: .gray)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        indicator.fillToMiddle(toSuperview: contentView)
        
        // We have to do this, else we get weird warnings the debugger...
        // contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
