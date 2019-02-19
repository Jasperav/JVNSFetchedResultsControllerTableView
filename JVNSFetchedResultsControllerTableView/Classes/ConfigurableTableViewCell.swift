import UIKit
import CoreData

/// The cell to configure when using NSFetchedResultsControllerTableView.
/// Generic parameter T takes a fetch request result as the generic signature
/// As well for the only method: configure. This method is required to override.
/// This class is therefore meant to be subclassed.
/// This class is the only UITableViewCell that can be used by NSFetchedResultsControllerTableView.
open class ConfigurableTableViewCell<T: NSFetchRequestResult>: UITableViewCell {
    
    public class var rowHeight: CGFloat {
        fatalError()
    }
    
    public class var estimatedRowHeight: CGFloat {
        fatalError()
    }
    
    /// Configure the cell based on fetchRequestResult.
    /// Crashes by default.
    open func configure(fetchRequestResult: T) {
        fatalError()
    }
}
