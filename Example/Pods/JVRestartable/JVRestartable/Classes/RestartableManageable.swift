/// Some classes can hold multiple restartable objects (like the appDelegate)
/// They should implement this protocol.
public protocol RestartableManageable: AnyObject {
    var restartables: [Restartable] { get set }
}

public extension RestartableManageable {
    func addRestartable(_ restartable: Restartable) {
        // We check for object reference here rather than equality (==)
        // Since I noticed some restartable objects just can't have a useful unique hashValue.
        guard !restartables.contains(where: { $0 === restartable }) else { return }
        
        restartables.append(restartable)
    }
    
    func removeRestartable(_ restartable: Restartable) {
        restartables = restartables.filter { $0 !== restartable }
    }
    
    func removeAllRestartables() {
        restartables.removeAll()
    }

    // Prety sad we can't use the CollectionExtensions here since Restartable
    // doesn't conform to itself >:(
    func pauseRestartables() {
        for restartable in restartables {
            restartable.pause()
        }
    }
    
    func resumeRestartables() {
        for restartable in restartables {
            restartable.resume()
        }
    }
    
}
