public extension MiddleTextView {
    enum Mode {
        case querying, notQuerying
    }
    
    struct StartMode {
        public let queryingText: String
        public let startMode: Mode
        
        public init(queryingText: String, startMode: Mode) {
            self.queryingText = queryingText
            self.startMode = startMode
        }
    }
}
