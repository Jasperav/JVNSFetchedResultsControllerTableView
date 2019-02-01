import JVMiddleTextView
import UIKit
import CoreData

struct MiddleTextViewPresenter {
    private unowned let view: UIView
    private unowned let middleTextView: MiddleTextView
    
    init(view: UIView, middleTextView: MiddleTextView) {
        self.view = view
        self.middleTextView = middleTextView
    }
    
    func updateMiddleTextView<U: NSFetchedResultsControllerTableView<ConfigurableTableViewCell<T>, T>, T: NSFetchRequestResult>(hasMinimalOneRow: Bool, mode: U.Mode) {
        if middleTextView.isHidden && hasMinimalOneRow {
            removeMiddleTextView()
        } else if !middleTextView.isHidden && !hasMinimalOneRow {
            showMiddleTextView(mode: mode)
        }
    }
    
    private func showMiddleTextView<U: NSFetchedResultsControllerTableView<ConfigurableTableViewCell<T>, T>, T: NSFetchRequestResult>(mode: U.Mode) {
        middleTextView.isHidden = false
        
        view.bringSubviewToFront(middleTextView)
        
        switch mode {
        case .notQuerying:
            middleTextView.change(mode: .notQuerying)
        case .querying:
            middleTextView.change(mode: .querying)
        }
    }
    
    private func removeMiddleTextView() {
        middleTextView.isHidden = true
        
        view.sendSubviewToBack(middleTextView)
    }
}
