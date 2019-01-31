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
    unowned let tableView: GenericTableView<T>
    
    private var mode: Mode
    private let middleTextViewPresenter: MiddleTextViewPresenter

    /// Viewcontrollers view property
    private unowned let view: UIView
    private unowned let middleTextView: MiddleTextView
    
    public init(tableView: GenericTableView<T>,
                view: UIView,
                middleTextView: MiddleTextView,
                resultController: NSFetchedResultsController<U>,
                mode: Mode,
                configure: ((_ cell: T, _ result: U) -> ())?) {
        self.tableView = tableView
        self.resultController = resultController
        self.configure = configure
        self.mode = mode
        self.view = view
        self.middleTextView = middleTextView
        self.middleTextViewPresenter = MiddleTextViewPresenter(view: view, middleTextView: middleTextView)

        super.init()
        
        if self.configure == nil {
            self.configure = { (cell, object) in
                cell.configure(fetchRequestResult: object)
            }
        }
        
        assert(tableView.superview == nil)
        assert(middleTextView.superview == nil)
        assert(view.subviews.count == 0)
        
        resultController.delegate = self
        
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.fill(toSuperview: view, toSafeMargins: true)
        
        middleTextView.fill(toSuperview: view, toSafeMargins: true)
        
        try! resultController.performFetch() // Error handling.
        
        updateMiddleTextView()
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
        switch mode {
        case .notQuerying:
            return resultController.fetchedObjects!.count
        case .querying:
            return resultController.fetchedObjects!.count + 1
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mode {
        case .notQuerying:
            return createCell(indexPath: indexPath)
        case .querying:
            if (indexPath.row - 1) == tableView.numberOfRows(inSection: indexPath.section) {
                return self.tableView.configureLoadCell(indexPath: indexPath)
            } else {
                return createCell(indexPath: indexPath)
            }
        }

    }
    
    public func getObject(indexPath: IndexPath) -> U {
        return resultController.object(at: indexPath)
    }
    
    public func change(mode: Mode) {
        guard self.mode != mode else { return }
        
        self.mode = mode
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        
        switch mode {
        case .notQuerying:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .querying:
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func updateMiddleTextView() {
        let hasMinimalOneRow = resultController.fetchedObjects!.count > 0
        
        middleTextViewPresenter.updateMiddleTextView(hasMinimalOneRow: hasMinimalOneRow, mode: mode as! NSFetchedResultsControllerTableView<ConfigurableTableViewCell<U>, U>.Mode)
    }
    
    private func createCell(indexPath: IndexPath) -> T {
        let cell = self.tableView.getCell(indexPath: indexPath)
        let object = resultController.object(at: indexPath)
        
        configure(cell, object)
        
        return cell
    }
    
}
