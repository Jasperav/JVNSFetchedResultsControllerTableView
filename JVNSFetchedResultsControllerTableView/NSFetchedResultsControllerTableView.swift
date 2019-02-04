import UIKit
import CoreData
import JVMiddleTextView
import JVGenericTableView

open class NSFetchedResultsControllerTableView<T: ConfigurableTableViewCell<U>, U: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, UITableViewDataSource {
    
    /// 'var' because sometimes we need 'self' available in the super.init.
    /// The user can than later on set the configuration.
    public var configure: ((_ cell: T, _ result: U) -> ())!
    
    /// Subclasses may use those values to determine the correct content offset y when the controller did refresh.
    var controllerRefresh = ControllerRefresh()
    let resultController: NSFetchedResultsController<U>
    let middleTextViewPresenter: MiddleTextViewPresenter
    unowned let tableView: GenericTableView<T>

    /// Viewcontrollers view property
    private unowned let view: UIView
    private unowned let middleTextView: MiddleTextView
    
    public init(tableView: GenericTableView<T>,
                view: UIView,
                middleTextView: MiddleTextView,
                resultController: NSFetchedResultsController<U>,
                configure: ((_ cell: T, _ result: U) -> ())?) {
        self.tableView = tableView
        self.resultController = resultController
        self.configure = configure
        self.view = view
        self.middleTextView = middleTextView
        self.middleTextViewPresenter = MiddleTextViewPresenter(view: view, middleTextView: middleTextView, tableView: tableView)

        super.init()
        
        if self.configure == nil {
            self.configure = { (cell, object) in
                cell.configure(fetchRequestResult: object)
            }
        }
        
        assert((type(of: self) == NSFetchedResultsControllerTableView.self) ? !middleTextView.isQueryable : true)
        assert(tableView.superview == nil)
        assert(middleTextView.superview == nil)
        assert(view.subviews.count == 0)
        
        middleTextView.fill(toSuperview: view, toSafeMargins: true)
        tableView.fill(toSuperview: view, toSafeMargins: true)
        
        // Setting the initial state to isHidden makes it easier for the middleTextViewPresenter
        middleTextView.isHidden = true
        
        resultController.delegate = self
        
        try! resultController.performFetch() // Error handling.
        
        // The delegate of the tableview needs to be after the fetch have been performed.
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        middleTextViewPresenter.setup(hasMinimalOneRow: resultController.fetchedObjects!.count > 0)
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
            
            controllerRefresh.didInsert = true
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            
            controllerRefresh.didDelete = true
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            
            controllerRefresh.didMove = true
        case .update:
            let cell = tableView.getCell(indexPath: newIndexPath!)
            let result = resultController.object(at: newIndexPath!)
            
            configure(cell, result)
            
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            
            controllerRefresh.didUpdate = true
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateMiddleTextView()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultController.fetchedObjects!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createCell(indexPath: indexPath)
    }
    
    public func getObject(indexPath: IndexPath) -> U {
        return resultController.object(at: indexPath)
    }
    
    func updateMiddleTextView() {
        let hasMinimalOneRow = resultController.fetchedObjects!.count > 0

        middleTextViewPresenter.updateMiddleTextView(hasMinimalOneRow: hasMinimalOneRow, mode: .notQuerying)
    }
    
    func createCell(indexPath: IndexPath) -> T {
        let cell = self.tableView.getCell(indexPath: indexPath)
        let object = resultController.object(at: indexPath)
        
        configure(cell, object)
        
        return cell
    }
    
}
