public extension MiddleTextView {
    struct SingleParameterInitializer {
        public let notQueryingText: String
        public let startMode: StartMode?
        
        public init(notQueryingText: String, startMode: StartMode? = nil) {
            self.notQueryingText = notQueryingText
            self.startMode = startMode
        }
    }
}
