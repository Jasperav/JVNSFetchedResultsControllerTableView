/// To use stand alone timers (a.k.a. timers that are class-independent)
/// Conform appDelegate to be a restartableManageable instance and set standalone restartables there.

/// Let classes conform to this protocol when it is restartable.
/// Usefull for timers, downloadable classes, etc.
/// It is constrainted to classes only because than we have a lot more options in protocol extensions
/// in RestartableManageable.swift
public protocol Restartable: AnyObject {
    func pause()
    func resume()
}
