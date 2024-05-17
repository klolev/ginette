@propertyWrapper
public enum Indirect<T> {
    indirect case next(T)
    
    public init(wrappedValue: T) {
        self = .next(wrappedValue)
    }
    
    public var wrappedValue: T {
        get {
            switch self {
            case .next(let value): return value
            }
        } set {
            self = .next(newValue)
        }
    }
}
