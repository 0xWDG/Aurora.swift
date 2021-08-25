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
    /// Fetch something from the network.
    /// - Parameter fromURL: URL
    /// - Returns: Data
    @available(*, deprecated)
    func networkFetch(fromURL: URL) -> Data {
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

    /// networkRequest (blocking)
    ///
    /// Start a network request
    ///
    /// - parameter url: The url to be parsed
    /// - parameter posting: What do you need to post
    /// - returns: Result<String, Error>
    @available(*, deprecated)
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
    // swiftlint:disable function_body_length
    /// networkRequest (non-blocking) [DEPRECATED]
    ///
    /// Start a network request
    ///
    /// - parameter url: The url to be parsed
    /// - parameter posting: What do you need to post
    /// - returns: closure -> sucess, fail.
    public func networkRequest(
        url: String,
        posting: [String: Any]?,
        completionHandler: @escaping (Result<String, Error>) -> Void
    ) {

        /// Check if the URL is valid
        guard let siteURL = URL(string: url) else {
            completionHandler(
                .failure(
                    AuroraError(
                        message: "Error: \(url) doesn't appear to be an URL"
                    )
                )
            )

            return
        }

        /// Create a new post dict, for the JSON String
        var post: String = ""

        if posting != nil {
            // Try
            do {
                /// Create JSON
                let JSON = try JSONSerialization.data(
                    withJSONObject: posting as Any,
                    options: .sortedKeys
                )

                // set NewPosting
                post = String.init(
                    data: JSON,
                    encoding: .utf8
                ).unwrap(
                    orError: "can not make POST object"
                )
                .addingPercentEncoding(
                    withAllowedCharacters: .urlHostAllowed
                ).unwrap(
                    orError: "Cannot add Percent Encoding"
                )
            }

            /// Catch errors
            catch let error as NSError {
                completionHandler(
                    .failure(
                        AuroraError(message: "Error: \(error.localizedDescription)")
                    )
                )
            }
        }

        /// Create a URL Request
        let request = URLRequest(url: siteURL).configure {
            // 60 Seconds before timeout (default)
            $0.timeoutInterval = 15
            // Set Content-Type to FORM
            $0.setValue("close", forHTTPHeaderField: "Connection")
            $0.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")

            if post.length > 3 {
                // We're posting

                // Set the HTTP Method to POST
                $0.httpMethod = "POST"

                // Set Content-Type to FORM
                $0.setValue(
                    "application/x-www-form-urlencoded",
                    forHTTPHeaderField: "Content-Type"
                )

                // Set the httpBody
                $0.httpBody = post.data(using: .utf8)
            } else {
                // We're getting

                // Set the HTTP Method to GET
                $0.httpMethod = "GET"
            }
        }

        /// Create a pinned URLSession
        var session = URLSession.init(
            // With default configuration
            configuration: .default,

            // With our pinning delegate
            delegate: AuroraURLSessionPinningDelegate(),

            // with no queue
            delegateQueue: nil
        )

        // Check if we have a public key, or certificate hash.
        if HTTPSCertificate.publicKeyHash.isBlank || HTTPSCertificate.certificateHash.isBlank {
            // Show a error, only on debug builds
            log(
                "[WARNING] No Public key pinning/Certificate pinning\n" +
                    "           Improve your security to enable this!\n"
            )
            // Use a non-pinned URLSession
            session = URLSession.shared
        }

        if let cookieData = Aurora.cookies {
            session.configuration.httpCookieStorage?.setCookies(
                cookieData,
                for: siteURL,
                mainDocumentURL: nil
            )
        }

        // Start our datatask
        session.dataTask(with: request) { (sitedata, _, theError) in
            /// Check if we got any useable site data
            guard let sitedata = sitedata else {
                if post.length > 3 {
                    self.log("Error: \(theError?.localizedDescription)")
                } else {
                    self.log("Error: \(theError?.localizedDescription)")
                }

                guard let theError = theError else {
                    fatalError("Failed to get the error message.")
                }

                completionHandler(.failure(theError))
                return
            }

            // Save our cookies
            Aurora.cookies = session.configuration.httpCookieStorage?.cookies

            if post.length > 3 {
                let data = String.init(data: sitedata, encoding: .utf8)

                Aurora.fullResponse = data
            } else {
                let data = String.init(data: sitedata, encoding: .utf8)

                Aurora.fullResponse = data
            }

            completionHandler(
                .success(
                    String.init(
                        data: sitedata,
                        encoding: .utf8
                    ).unwrap(
                        orError: "Failed to decode website data."
                    )
                )
            )
        }.resume()
    }
    // swiftlint:enable function_body_length
}
