import UIKit

open class GenericUITableView<T: UITableViewCell>: UITableView {
    
    public var cellIdentifier: String { return "cell" }
    private let cellType: T.Type
    
    public init(cellType: T.Type,
                style: UITableView.Style) {
        self.cellType = cellType
        
        super.init(frame: .zero, style: style)
        
        register(cellType, forCellReuseIdentifier: cellIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getCell(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! T
    }
}
