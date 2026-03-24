import Foundation

enum StreamConnectionState: Equatable {
    case idle
    case connecting(username: String)
    case connected(username: String)
    case failed(username: String, message: String)
}
