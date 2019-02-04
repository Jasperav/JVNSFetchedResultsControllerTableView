import UIKit

// Seperated classes since every result controller is genericfied and if those enums are inside the classes, the enums gets generic to...


public enum NSFetchedResultsControllerTableViewMode {
    case notQuerying, querying
}

public enum NSFetchedResultsControllerTableViewLoadCellPosition {
    case top, bottom
}
