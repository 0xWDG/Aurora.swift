// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Thanks for using!
//
// Licence: MIT

import Foundation

extension Aurora {
    /// Fetch something from the network. (DEPRECATED DO NOT USE)
    /// - Parameter fromURL: URL
    /// - Returns: Data
    @available(*, deprecated)
    func networkFetch(fromURL: URL, file: String = #file, line: Int = #line) -> Data {
        print("WARNING IN \(file):\(line).")
        print("You've called networkFetch(fromURL: URL), this is deprecated.")
        var waiting = true
        var returnData: Data = Data.init()

        URLSession.shared.dataTask(with: fromURL) { dataTaskData, _, _ in
            if let dataTaskData = dataTaskData {
                returnData = dataTaskData
            }

            waiting = false
        }
        .resume()

        while waiting { }

        return returnData
    }

    /// networkRequest (blocking) _(read note)_
    ///
    /// Start a network request
    /// use the inproved version (example):
    ///
    /// - parameter url: The url to be parsed
    /// - parameter posting: What do you need to post
    /// - returns: Result<String, Error>
    /// - Note: This functions calls ``networkRequest(url:posting:completionHandler:)`` which is \
    /// a `temporary` wrapper to the new function ``networkRequest(url:method:values:completionHandler:)``
    public func networkRequest(
        url: String,
        posting: [String: Any]? = ["nothing": "send"]
    ) -> Result<String, Error> {
        // Ok, this is a waiter
        var rResult: Result<String, Error>?

        self.networkRequest(url: url, posting: posting) { (res) in
            rResult = res
        }

        while rResult == nil {
            // wait.
        }

        return rResult ?? .failure(
            AuroraError(message: "Failed to unwrap result")
        )
    }

    /// networkRequest (non-blocking) _(read note)_
    ///
    /// Start a network request
    /// Usage (new version):
    ///
    ///     self.networkRequest(url: url, method: .post, values: posting) { result in
    ///       switch result {
    ///       case .success(let data):
    ///         // do something with the data (not a string anymore!)
    ///
    ///       case .failure(let error):
    ///         // Do something with the error
    ///       }
    ///     }
    ///
    /// - parameter url: The url to be parsed
    /// - parameter posting: What do you need to post
    /// - returns: closure -> sucess, fail.
    /// - Note: This is a `temporary` wrapper to the new function \
    /// ``networkRequest(url:method:values:completionHandler:)``
    public func networkRequest(
        url: String,
        posting: [String: Any]?,
        completionHandler: @escaping (Result<String, Error>) -> Void
    ) {
        self.networkRequest(url: url, method: .post, values: posting) { result in
            var resStrErr: Result<String, Error>

            switch result {
            case .success(let data):
                if let str = String.init(data: data, encoding: .utf8) {
                    resStrErr = .success(str)
                } else {
                    resStrErr = .success("")
                }

            case .failure(let error):
                resStrErr = .failure(error)
            }

            completionHandler(resStrErr)
        }
    }
}
