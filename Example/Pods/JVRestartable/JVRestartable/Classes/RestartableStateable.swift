/// Not all conforming objects want a restartableState, so this protocol
/// is a subprotocol of Restartable with the restartableState property.

public protocol RestartableStateable: Restartable {
    var restartableState: RestartableState { get set }
}

public extension RestartableStateable {
    var isActive: Bool {
        return restartableState == .active
    }
    
    var isPaused: Bool {
        return restartableState == .paused
    }
}
