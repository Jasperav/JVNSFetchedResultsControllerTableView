import UIKit

extension UITableView {
    var isScrolled: Bool {
        return contentOffset.y != 0
    }
    
    var allContentIsCompletelyVisible: Bool {
        return contentSize.height > bounds.height
    }
}
