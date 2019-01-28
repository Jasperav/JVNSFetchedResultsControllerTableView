/// Omits spagetti initializers when using composite design pattern and you are using lots of objects in one object.
public protocol SingleParameterInitializable {
    associatedtype SingleParameterInitializableObject
    
    init(from: SingleParameterInitializableObject)
}
