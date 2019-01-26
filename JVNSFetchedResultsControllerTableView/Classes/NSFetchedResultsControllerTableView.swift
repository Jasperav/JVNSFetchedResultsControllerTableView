import UIKit
import CoreData
import JVMiddleTextView
import JVGenericTableView

open class NSFetchedResultsControllerTableView<T: UITableViewCell, U: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, UITableViewDataSource {
    unowned let tableView: GenericUITableView<T>
    
    /// Most likely the UIViewController.view property.
    private unowned let middleTextViewSuperView: UIView
    
    private let middleTextView: MiddleTextView
    let resultController: NSFetchedResultsController<U>
    
    /// Should be an unowned reference.
    private let configure: ((_ cell: T, _ result: U) -> ())
    
    /// Subclasses may use those values to determine the correct content offset y when the controller did refresh.
    var controllerRefresh = ControllerRefresh()
    
    public init(tableView: GenericUITableView<T>,
                middleTextViewSuperView: UIView,
                middleTextViewText: String,
                resultController: NSFetchedResultsController<U>,
                configure: @escaping ((_ cell: T, _ result: U) -> ())) {
        self.tableView = tableView
        self.middleTextViewSuperView = middleTextViewSuperView
        self.middleTextView = MiddleTextView(text: middleTextViewText)
        self.resultController = resultController
        self.configure = configure
        
        super.init()
        
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        resultController.delegate = self
        
        try! resultController.performFetch() // Error handling.
        
        guard resultController.fetchedObjects!.count != 0 else {
            showMiddleTextView()
            
            return
        }
        
        removeMiddleTextView()
    }
    
    private func showMiddleTextView() {
        guard resultController.fetchedObjects!.count == 0
            && middleTextView.superview == nil
            else { return }
        
        middleTextView.fill(toSuperview: middleTextViewSuperView, toSafeMargins: true)
    }
    
    private func removeMiddleTextView() {
        guard middleTextView.superview != nil else { return }
        
        middleTextView.removeFromSuperview()
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        controllerRefresh = ControllerRefresh()
        controllerRefresh.fetchedResultsBeforeUpdate = controller.fetchedObjects!.count
        
        tableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            controllerRefresh.didInsertRowAtBottom = newIndexPath!.row == tableView.numberOfRows(inSection: 0)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            removeMiddleTextView()
            
            controllerRefresh.didInsert = true
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            showMiddleTextView()
            
            controllerRefresh.didDelete = true
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            
            controllerRefresh.didMove = true
        case .update:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableView.cellIdentifier, for: newIndexPath!) as! T
            let result = resultController.object(at: newIndexPath!)
            
            configure(cell, result)
            
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            
            controllerRefresh.didUpdate = true
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultController.fetchedObjects!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.getCell(indexPath: indexPath)
        let object = resultController.object(at: indexPath)
        
        configure(cell, object)
        
        return cell
    }
    
    public func getObject(indexPath: IndexPath) -> U {
        return resultController.object(at: indexPath)
    }
    
}
