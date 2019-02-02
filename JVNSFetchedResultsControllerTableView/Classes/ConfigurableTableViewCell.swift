import UIKit
import CoreData

open class ConfigurableTableViewCell<T: NSFetchRequestResult>: UITableViewCell {
    
    open func configure(fetchRequestResult: T) {
        fatalError()
    }
    
    func getT() {
        let y = T.self
    }
}
