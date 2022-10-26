public struct ITunesSearch: Decodable {
    public struct Result: Decodable {
        public let wrapperType: String
        public let kind: String?
        public let artistId: Int
        public let collectionId: Int
        public let trackId: Int?
        public let artistName: String
        public let collectionName: String
        public let trackName: String?
    }
    public let results: [Result]
}


