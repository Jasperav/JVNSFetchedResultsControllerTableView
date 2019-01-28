public extension NSFetchedResultsControllerTableView {
    enum Mode {
        case notQuerying, querying
    }
}

import UIKit

struct MyGenericStruct<T: UITableViewCell> {
    enum MyUselessEnum {
        case one, two
    }
    
    func callingMethod() {
        SomeStruct.handle(anEnum: .one)
    }
}

struct SomeStruct {
    static func handle(anEnum: MyGenericStruct<UITableViewCell>.MyUselessEnum) {
        
    }
}
