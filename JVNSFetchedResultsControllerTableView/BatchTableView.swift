public struct Batch {
    var hasMoreResults = true
    let searchingText: String
    
    public init(searchingText: String) {
        self.searchingText = searchingText
    }
}
