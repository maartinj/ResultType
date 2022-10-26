import Foundation

public struct LaunchCalendar: Codable {
     public struct Launche: Codable {
        public let name: String
        public let wsstamp: Date
    }
     public let launches: [Launche]
}
