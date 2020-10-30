// $$HEADER$$

import Foundation

#if canImport(Security)
import Security
#endif

#if !targetEnvironment(simulator)
#if canImport(CommonCrypto)
import CommonCrypto
#endif
#endif

@available(tvOS 12.0, *)
extension Aurora {
    static var cookies: [HTTPCookie]? = []
    
    struct HTTPSCertificate {
        /// Server's public key hash
        static var publicKeyHash = ""
        
        /// Server's certificate hash
        static var certificateHash = ""
    }
    
    /**
     * Set hash of the server's certificate
     *
     * This saves the hash of the server's certificate
     *
     * - parameter certificateHash: Server's certificate hash
     */
    public func set(certificateHash: String) {
        HTTPSCertificate.certificateHash = certificateHash
    }
    
    /**
     * Set hash of the server's public key
     *
     * This saves the hash of the server's public key
     *
     * - parameter publicKeyHash: Server's public key hash
     */
    public func set(publicKeyHash: String) {
        HTTPSCertificate.publicKeyHash = publicKeyHash
    }
    
    /**
     * Get hash of the server's certificate
     *
     * This gets the hash of the server's certificate
     *
     * - returns Server's certificate hash
     */
    public func getCertificateHash() -> String {
        return HTTPSCertificate.certificateHash
    }
    
    /**
     * Get hash of the server's public key
     *
     * This gets the hash of the server's public key
     *
     * - returns Server's public key hash
     */
    public func getPublicKeyHash() -> String {
        return HTTPSCertificate.publicKeyHash
    }
    
    /**
     * networkRequest
     *
     * Start a network request
     *
     * - parameter url: The url to be parsed
     * - parameter posting: What do you need to post
     * - returns: closure -> sucess, fail.
     */
    public func networkRequest(
        url: String,
        posting: Dictionary<String, Any>? = ["nothing": "send"],
        completionHandler: @escaping (Result<String, Error>) -> Void
    ) {
        /// Check if the URL is valid
        guard let siteURL = URL(string: url) else {
            completionHandler(
                .failure("Error: \(url) doesn't appear to be an URL" as! Error)
            )
            return
        }
        
        /// Create a new post dict, for the JSON String
        var post: String = ""
        
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
            )!.addingPercentEncoding(
                withAllowedCharacters: .urlHostAllowed
            )!
        }
        
        /// Catch errors
        catch let error as NSError {
            completionHandler(.failure("Error: \(error.localizedDescription)" as! Error))
        }
        
        /// Create a URL Request
        let request = URLRequest(url: siteURL).configure {
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
                
                // Log, if we are in debugmode.
                log("HTTP (POST): \(url)\nbody (escaped): \(post)\nbody (unescaped): \(post.removingPercentEncoding!)")
                
            } else {
                // We're getting
                
                // Set the HTTP Method to GET
                $0.httpMethod = "GET"
                
                // Log, if we are in debugmode.
                log("HTTP (GET): \(url)\npost body (escaped): \(post)\npost body (unescaped): \(post.removingPercentEncoding!)")
                
            }
        }
        
        /// Create a pinned URLSession
        var session = URLSession.init(
            // With default configuration
            configuration: .ephemeral,
            
            // With our pinning delegate
            delegate: URLSessionPinningDelegate(),
            
            // with no queue
            delegateQueue: nil
        )
        
        // Check if we have a public key, or certificate hash.
        if (HTTPSCertificate.publicKeyHash.count == 0 || HTTPSCertificate.certificateHash.count == 0) {
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
        
        //        #if os(iOS)
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //        #endif
        
        // Start our datatask
        session.dataTask(with: request) { (sitedata, _, theError) in
            //            #if os(iOS)
            //            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //            #endif
            
            /// Check if we got any useable site data
            guard let sitedata = sitedata else {
                if post.length > 3 {
                    self.log("HTTP (POST): \(url)\nbody (escaped): \(post)\nbody (unescaped): \(post.removingPercentEncoding!)\nError: \(theError?.localizedDescription)")
                } else {
                    self.log("HTTP (GET): \(url)\npost body (escaped): \(post)\npost body (unescaped): \(post.removingPercentEncoding!)\nError: \(theError?.localizedDescription)")
                }
                
                completionHandler(.failure(theError!))
                return
            }
            
            // Save our cookies
            Aurora.cookies = session.configuration.httpCookieStorage?.cookies
            
            if post.length > 3 {
                self.log("HTTP (POST): \(url)\nbody (escaped): \(post)\nbody (unescaped): \(post.removingPercentEncoding!)\nresponse: \(String.init(data: sitedata, encoding: .utf8)?.substr(0, 120).replace("\n", withString: ""))")
            } else {
                self.log("HTTP (GET): \(url)\npost body (escaped): \(post)\npost body (unescaped): \(post.removingPercentEncoding!)\nresponse: \(String.init(data: sitedata, encoding: .utf8)?.substr(0, 120).replace("\n", withString: ""))")
            }
            
            completionHandler(.success(String.init(data: sitedata, encoding: .utf8)!))
        }.resume()
    }
    
    /**
     * networkRequest
     *
     * Start a network request
     *
     * - parameter url: The url to be parsed
     * - parameter posting: What do you need to post
     * - returns: the data we've got from the server
     */
    public func dep_networkRequest(
        _ url: String,
        _ posting: Dictionary<String, Any>? = ["nothing": "send"]
    ) -> Data {
        /// Check if the URL is valid
        guard let myURL = URL(string: url) else {
            return "Error: \(url) doesn't appear to be an URL".data(using: String.Encoding.utf8)!
        }
        
        /// Create a new post dict, for the JSON String
        var post: String
        
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
            )!.addingPercentEncoding(
                withAllowedCharacters: .urlHostAllowed
            )!
        }
        
        /// Catch errors
        catch let error as NSError {
            return "Error: \(error.localizedDescription)".data(using: String.Encoding.utf8)!
        }
        
        /// We are waiting for data
        var waiting: Bool = true
        
        /// Setup a fake, empty data
        var data: Data? = "" . data(using: .utf8)
        
        /// Create a URL Request
        var request = URLRequest(url: myURL)
        
        // With method POST
        request.httpMethod = "POST"
        
        // And custom Content-Type
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )
        
        // Log, if we are in debugmode.
        log("url: \(url)\npost body (escaped): \(post)\npost body (unescaped): \(post.removingPercentEncoding!)")
        
        // Set the httpBody
        request.httpBody = post.data(using: .utf8)
        
        /// Create a pinned URLSession
        var session = URLSession.init(
            // With default configuration
            configuration: .ephemeral,
            
            // With our pinning delegate
            delegate: URLSessionPinningDelegate(),
            
            // with no queue
            delegateQueue: nil
        )
        
        // Check if we have a public key, or certificate hash.
        if (HTTPSCertificate.publicKeyHash.count == 0 || HTTPSCertificate.certificateHash.count == 0) {
            // Show a error, only on debug builds
            log(
                "[WARNING] No Public key pinning/Certificate pinning\n" +
                    "           Improve your security to enable this!\n"
            )
            // Use a non-pinned URLSession
            session = URLSession.shared
        }
        
        // Start our datatask
        session.dataTask(with: request) { (sitedata, _, theError) in
            /// Check if we got any useable site data
            guard let sitedata = sitedata else {
                data = theError?.localizedDescription.data(using: .utf8)
                waiting = false
                return
            }
            
            // save the sitedata
            data = sitedata
            
            // stop waiting
            waiting = false
        }.resume()
        
        // Dirty way to create a blocking function.
        while (waiting) { }
        
        /// Unwrap our data
        guard let unwrappedData = data else {
            return "Error while unwrapping data" . data(using: .utf8)!
        }
        
        /// Unwrap for debug
        if let returnedData = String.init(data: unwrappedData, encoding: .utf8) {
            log("Return data: \(returnedData)")
        }
        
        // Return the data.
        return unwrappedData
    }
    
    /**
     * networkRequest_dep (DEPRECATED)
     *
     * Start a network request
     *
     * - parameter url: The url to be parsed
     * - parameter posting: What do you need to post
     * - returns: the data we've got from the server
     */
    public func networkRequest_dep(
        _ url: String,
        _ posting: Dictionary<String, Any>? = ["nothing": "send"]
    ) -> Data {
        /// Check if the URL is valid
        guard let myURL = URL(string: url) else {
            return "Error: \(url) doesn't appear to be an URL".data(using: String.Encoding.utf8)!
        }
        
        /// Create a new post dict, for the JSON String
        var newPosting: Dictionary<String, String>?
        
        // Try
        do {
            /// Create JSON
            let JSON = try JSONSerialization.data(
                withJSONObject: posting as Any,
                options: .sortedKeys
            )
            
            // set NewPosting
            newPosting = ["JSON": String.init(data: JSON, encoding: .utf8)!]
        }
        
        /// Catch errors
        catch let error as NSError {
            return "Error: \(error.localizedDescription)".data(using: String.Encoding.utf8)!
        }
        
        /// We are waiting for data
        var waiting: Bool = true
        
        /// Setup a fake, empty data
        var data: Data? = "" . data(using: .utf8)
        
        /// Setup a reuseable noData dataset
        let noData: Data = "" . data(using: .utf8)!
        
        /// Create a URL Request
        var request = URLRequest(url: myURL)
        
        // With method POST
        request.httpMethod = "POST"
        
        // And custom Content-Type
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )
        
        /// Create a empty httpBody
        var httpPostBody = ""
        
        /// Index = 0
        var idx = 0
        
        /// Check if we can unwrap the post fields.
        guard let postFields = newPosting else {
            return noData
        }
        
        // Walk trough the post Fields
        for (key, val) in postFields {
            /// Check if we need to preAppend
            let preAppend = (idx == 0) ? "": "&"
            
            /// Encode the value
            let encodedValue = val.addingPercentEncoding(
                withAllowedCharacters: .urlHostAllowed
            )!
            
            // Append to httpPostBody
            httpPostBody.append(
                contentsOf: "\(preAppend)\(key)=\(encodedValue)"
            )
            
            // Increase our index
            idx += 1
        }
        
        // Log, if we are in debugmode.
        self.log(""
                    + "url: \(url)\n"
                    + "post body (escaped): \(httpPostBody)\n"
                    + "post body (unescaped): \(httpPostBody.removingPercentEncoding!)"
        )
        
        // Set the httpBody
        request.httpBody = httpPostBody.data(using: .utf8)
        
        /// Create a pinned URLSession
        var session = URLSession.init(
            // With default configuration
            configuration: .ephemeral,
            
            // With our pinning delegate
            delegate: URLSessionPinningDelegate(),
            
            // with no queue
            delegateQueue: nil
        )
        
        // Check if we have a public key, or certificate hash.
        if (HTTPSCertificate.publicKeyHash.count == 0 || HTTPSCertificate.certificateHash.count == 0) {
            // Show a error, only on debug builds
            log(
                "[WARNING] No Public key pinning/Certificate pinning\n" +
                    "           Improve your security to enable this!\n"
            )
            // Use a non-pinned URLSession
            session = URLSession.shared
        }
        
        // Start our datatask
        session.dataTask(with: request) { (sitedata, _, theError) in
            /// Check if we got any useable site data
            guard let sitedata = sitedata else {
                data = theError?.localizedDescription.data(using: .utf8)
                waiting = false
                return
            }
            
            // save the sitedata
            data = sitedata
            
            // stop waiting
            waiting = false
        }.resume()
        
        // Dirty way to create a blocking function.
        while (waiting) { }
        
        /// Unwrap our data
        guard let unwrappedData = data else {
            return "Error while unwrapping data" . data(using: .utf8)!
        }
        
        /// Unwrap for debug
        if let returnedData = String.init(data: unwrappedData, encoding: .utf8) {
            log("Return data: \(returnedData)")
        }
        
        // Return the data.
        return unwrappedData
    }
}

// See: https://www.bugsee.com/blog/ssl-certificate-pinning-in-mobile-applications/
class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    /// Hash of the pinned certificate
    let pinnedCertificateHash: String
    
    /// Hash of the pinned public key
    let pinnedPublicKeyHash: String
    
    override init() {
        if #available(tvOS 12.0, *) {
            pinnedCertificateHash = Aurora.shared.getCertificateHash()
            pinnedPublicKeyHash = Aurora.shared.getPublicKeyHash()
        } else {
            pinnedCertificateHash = ""
            pinnedPublicKeyHash = ""
        }
        
        super.init()
    }
    
    /// RSA2048 Asn1 Header
    let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d,
        0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05,
        0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    /// <#Description#>
    /// - Parameter data: <#data description#>
    /// - Returns: <#description#>
    private func sha256(data: Data) -> String {
        #if !targetEnvironment(simulator)
        /// Key header
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        
        /// Hash
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(keyWithHeader.count), &hash)
        }
        
        return Data(hash).base64EncodedString()
        #else
        return data.base64EncodedString()
        #endif
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - session: <#session description#>
    ///   - challenge: <#challenge description#>
    ///   - completionHandler: <#completionHandler description#>
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void
    ) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            /// Server trust
            if let serverTrust = challenge.protectionSpace.serverTrust {
                /// server trust
                var secresult = SecTrustResultType.invalid
                
                /// status
                let status = SecTrustEvaluate(serverTrust, &secresult)
//                let status = SecTrustEvaluateWithError(serverTrust, &secresult)

                if(errSecSuccess == status) {
                    // Aurora.shared.log(SecTrustGetCertificateCount(serverTrust))
                    /// Server certificate
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        
                        if (pinnedCertificateHash.count > 2) {
                            /// Certificate pinning
                            let serverCertificateData: NSData = SecCertificateCopyData(
                                serverCertificate
                            )
                            
                            /// Get hash
                            let certHash = sha256(
                                data: serverCertificateData as Data
                            )
                            
                            if (certHash == pinnedCertificateHash) {
                                // Success! This is our server
                                completionHandler(
                                    .useCredential,
                                    URLCredential(
                                        trust: serverTrust
                                    )
                                )
                                return
                            }
                        }
                        
                        if #available(tvOS 12.0, *) {
                            if (pinnedPublicKeyHash.count > 2) {
                                /// Public key pinning
                                let serverPublicKey = SecCertificateCopyKey(
                                    serverCertificate
                                )
                                
                                /// Public key data
                                let serverPublicKeyData: NSData = SecKeyCopyExternalRepresentation(
                                    serverPublicKey!,
                                    nil
                                )!
                                
                                /// Key hash
                                let keyHash = sha256(
                                    data: serverPublicKeyData as Data
                                )
                                
                                if (keyHash == pinnedPublicKeyHash) {
                                    // Success! This is our server
                                    completionHandler(
                                        .useCredential,
                                        URLCredential(trust: serverTrust)
                                    )
                                    return
                                }
                            }
                        } else {
                            fatalError("SSL Pinning is not available on this version of tvOS")
                        }
                    }
                }
            }
        }
        
        // Pinning failed
        completionHandler(
            .cancelAuthenticationChallenge,
            nil
        )
    }
}
