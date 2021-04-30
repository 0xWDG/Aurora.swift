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

// See: https://www.bugsee.com/blog/ssl-certificate-pinning-in-mobile-applications/
/// AuroraURLSessionPinningDelegate
class AuroraURLSessionPinningDelegate: NSObject, URLSessionDelegate {
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
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            /// Server trust
            if let serverTrust = challenge.protectionSpace.serverTrust {
                /// server trust
                var secresult = SecTrustResultType.invalid
                
                /// status
                let status = SecTrustEvaluate(serverTrust, &secresult)
                //                let status = SecTrustEvaluateWithError(serverTrust, &secresult)
                
                if errSecSuccess == status {
                    // Aurora.shared.log(SecTrustGetCertificateCount(serverTrust))
                    /// Server certificate
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        
                        if pinnedCertificateHash.count > 2 {
                            /// Certificate pinning
                            let serverCertificateData: NSData = SecCertificateCopyData(
                                serverCertificate
                            )
                            
                            /// Get hash
                            let certHash = sha256(
                                data: serverCertificateData as Data
                            )
                            
                            if certHash == pinnedCertificateHash {
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
                            if pinnedPublicKeyHash.count > 2 {
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
                                
                                if keyHash == pinnedPublicKeyHash {
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
