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
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.

import Foundation

#if canImport(Security)
import Security
#endif

#if canImport(UIKit)
import UIKit
#endif

#if !targetEnvironment(simulator)
#if canImport(CommonCrypto)
import CommonCrypto
#endif
#endif

@available(tvOS 12.0, *)
extension Aurora {
    /// All the cookies
    static var cookies: [HTTPCookie]? = []
    
    /// the full networkRequestResponse
    static var fullResponse: String? = ""
    
    /// The dispatch group
    static let group: DispatchGroup = .init()
    
    struct HTTPSCertificate {
        /// Server's public key hash
        static var publicKeyHash = ""
        
        /// Server's certificate hash
        static var certificateHash = ""
    }
    
    /// HTTP Method
    public enum HTTPMethod {
        /// POST
        ///
        /// Post a file or form
        case post
        
        /// GET
        ///
        /// Just a regular request to a webserver
        case get
    }
    
    /// Set hash of the server's certificate
    ///
    /// This saves the hash of the server's certificate
    ///
    /// - parameter certificateHash: Server's certificate hash
    public func set(certificateHash: String) {
        HTTPSCertificate.certificateHash = certificateHash
    }
    
    /// Set hash of the server's public key
    ///
    /// This saves the hash of the server's public key
    ///
    /// - parameter publicKeyHash: Server's public key hash
    public func set(publicKeyHash: String) {
        HTTPSCertificate.publicKeyHash = publicKeyHash
    }
    
    /// Get hash of the server's certificate
    ///
    /// This gets the hash of the server's certificate
    ///
    /// - returns Server's certificate hash
    public func getCertificateHash() -> String {
        return HTTPSCertificate.certificateHash
    }
    
    /// Get hash of the server's public key
    ///
    /// This gets the hash of the server's public key
    ///
    /// - returns Server's public key hash
    public func getPublicKeyHash() -> String {
        return HTTPSCertificate.publicKeyHash
    }
    
    /// Creates a network request that retrieves the contents of a URL \
    /// based on the specified URL request object and returns the data on completion
    ///
    ///
    ///
    /// - Parameters:
    ///   - url: A value that identifies the location of a resource, \
    ///   such as an item on a remote server or the path to a local file.
    ///   - method: The HTTP request method.
    ///   - values: POST values (if any)
    /// - Returns: The HTTP(S) request data
    public func networkRequest(
        url: String,
        method: HTTPMethod,
        values: [String: Any]?
    ) -> Data? {
        var result: Data?
        var inGroup = true
        var waiting = true
        let dGroup = Aurora.group
        
        dGroup.enter()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if waiting {
                Aurora.shared.log(
                    AuroraError(message: "Timeout, killing request")
                )
                
                if inGroup {
                    dGroup.leave()
                }
            }
        }
        
        Aurora.shared.networkRequest(
            url: url,
            method: method,
            values: values) { response in
            waiting = false
            
            switch response {
            case .success(let data):
                result = data
            case .failure(let error):
                Aurora.shared.log(error.localizedDescription)
            }
            
            if inGroup {
                dGroup.leave()
            }
        }
        
        dGroup.wait()
                
        inGroup = false
        return result
    }
    
    // swiftlint:disable function_body_length
    /// Creates a network request that retrieves the contents of a URL \
    /// based on the specified URL request object, and calls a handler upon completion.
    ///  
    /// - Parameters:
    ///   - url: A value that identifies the location of a resource, \
    ///   such as an item on a remote server or the path to a local file.
    ///   - method: The HTTP request method.
    ///   - values: POST values (if any)
    ///   - completionHandler: This completion handler takes the following parameters:
    ///   `Result<Data, Error>`
    ///     - `Data`: The data returned by the server.
    ///     - `Errror`: An error object that indicates why the request failed, or nil if the request was successful.
    public func networkRequest(
        url: String,
        method: HTTPMethod,
        values: [String: Any]?,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        /// Check if the URL is valid
        guard let siteURL = URL(string: url) else {
            completionHandler(
                .failure(
                    AuroraError(message: "Error: \(url) doesn't appear to be an URL")
                )
            )
            
            return
        }
        
        /// Create a new post dict, for the JSON String
        var post: String = ""
        
        // Try
        do {
            if let safeValues = values {
                /// Create JSON
                let JSON = try JSONSerialization.data(
                    withJSONObject: safeValues,
                    options: .sortedKeys
                )
                
                // set NewPosting
                post = String.init(
                    data: JSON,
                    encoding: .utf8
                )!.addingPercentEncoding(
                    withAllowedCharacters: .urlHostAllowed
                )!
            }
        }
        
        /// Catch errors
        catch let error as NSError {
            completionHandler(
                .failure(
                    AuroraError(message: "Error: \(error.localizedDescription)")
                )
            )
        }
        
        /// Create a URL Request
        let request = URLRequest(url: siteURL).configure {
            // 60 Seconds before timeout (default)
            $0.timeoutInterval = 15
            // Set Content-Type to FORM
            $0.setValue("close", forHTTPHeaderField: "Connection")
            $0.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")
            
            if method == .post {
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
            } else if method == .get {
                // We're getting
                
                // Set the HTTP Method to GET
                $0.httpMethod = "GET"
            } else {
                completionHandler(
                    .failure(
                        AuroraError(message: "Unknown method: \(method)")
                    )
                )
            }
        }
        
        /// Create a pinned URLSession
        var session: URLSession? = URLSession.init(
            // With default configuration
            configuration: .default,
            
            // With our pinning delegate
            delegate: AuroraURLSessionPinningDelegate(),
            
            // with no queue
            delegateQueue: nil
        )
        
        // Check if we have a public key, or certificate hash.
        if HTTPSCertificate.publicKeyHash.count == 0 || HTTPSCertificate.certificateHash.count == 0 {
            // Show a error, only on debug builds
            log(
                "[WARNING] No Public key pinning/Certificate pinning\n" +
                    "           Improve your security to enable this!\n"
            )
            // Use a non-pinned URLSession
            session = URLSession.shared
        }
        
        if let cookieData = Aurora.cookies {
            session?.configuration.httpCookieStorage?.setCookies(
                cookieData,
                for: siteURL,
                mainDocumentURL: nil
            )
        }
        
        // Start our datatask
        session?.dataTask(with: request) { (sitedata, _, theError) in
            /// Check if we got any useable site data
            guard let sitedata = sitedata else {
                if post.length > 3 {
                    self.log("Error: \(theError?.localizedDescription)")
                } else {
                    self.log("Error: \(theError?.localizedDescription)")
                }
                
                completionHandler(.failure(theError!))
                return
            }
            
            // Save our cookies
            Aurora.cookies = session?.configuration.httpCookieStorage?.cookies
            
            if post.length > 3 {
                let data = String.init(data: sitedata, encoding: .utf8)
                
                Aurora.fullResponse = data
            } else {
                let data = String.init(data: sitedata, encoding: .utf8)
                
                Aurora.fullResponse = data
            }
            
            completionHandler(
                .success(sitedata)
            )
        }.resume()
        
        // Invalidate session, after saving tasks
        session?.finishTasksAndInvalidate()
        
        // Release the session from memory
        session = nil
    }
    // swiftlint:enable function_body_length    
    
    /// Return the full networkRequestResponse
    /// - Returns: the full networkRequestResponse
    public func networkRequestResponse() -> String? {
        return Aurora.fullResponse
    }
}
