// $$HEADER$$

import Foundation

public typealias Byte = UInt8

open class Socket {
    
    public let address: String
    internal(set) public var port: Int32
    internal(set) public var fd: Int32?
    
    public init(address: String, port: Int32) {
        self.address = address
        self.port = port
    }
    
}

public enum SocketError: Error {
    case queryFailed
    case connectionClosed
    case connectionTimeout
    case unknownError
}

public enum Result {
    case success
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
