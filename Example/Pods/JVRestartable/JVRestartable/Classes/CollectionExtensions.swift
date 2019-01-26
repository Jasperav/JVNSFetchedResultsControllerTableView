public extension Array where Element: Restartable {
    func pauseAll() {
        for restartable in self {
            restartable.pause()
        }
    }
    
    func resumeAll() {
        for restartable in self {
            restartable.resume()
        }
    }
}


public extension Set where Element: Restartable {
    func pauseAll() {
        for restartable in self {
            restartable.pause()
        }
    }
    
    func resumeAll() {
        for restartable in self {
            restartable.resume()
        }
    }
}
