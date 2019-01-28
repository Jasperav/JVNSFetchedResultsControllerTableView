import UIKit

open class GenericTableView<T: UITableViewCell>: UITableView {
    
    private let cellIdentifier = "cell"
    private let loadCellIdentifier = "load"
    private let cellType: T.Type
    
    public init(cellType: T.Type,
                style: UITableView.Style) {
        self.cellType = cellType
        
        super.init(frame: .zero, style: style)
        
        register(cellType, forCellReuseIdentifier: cellIdentifier)
        register(LoadCell.self, forCellReuseIdentifier: loadCellIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Make sure that if this tableView is loadable, you don't try to access
    /// the last cell for the indexpath while it is loading, since than you get a
    /// cast exception.
    public func getCell(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! T
    }
    
    /// This has to be called when the load cell will become visible.
    public func configureLoadCell(indexPath: IndexPath) -> LoadCell {
        let cell = dequeueReusableCell(withIdentifier: loadCellIdentifier, for: indexPath) as! LoadCell
        
        cell.indicator.startAnimating()
        
        return cell
    }
}
