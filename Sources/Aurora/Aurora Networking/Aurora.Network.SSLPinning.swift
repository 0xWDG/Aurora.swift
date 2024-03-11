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

    /// SHA256 Encode data
    /// - Parameter data: the data which needs to be encoded
    /// - Returns: encoded data
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

    func urlSession( // swiftlint:disable:this function_body_length
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void
    ) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            /// Server trust
            if let serverTrust = challenge.protectionSpace.serverTrust {
                /// server trust
                var statusPointer: CFError?

                if SecTrustEvaluateWithError(serverTrust, &statusPointer) {
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

                                // Disable this lint,
                                // It will let us not build, if we change
                                // it to guard/if let.
                                // Error: error: Abort trap: 6
                                // swiftlint:disable force_unwrapping
                                /// Public key data
                                let serverPublicKeyData: NSData = SecKeyCopyExternalRepresentation(
                                    serverPublicKey!,
                                    nil
                                )!
                                // swiftlint:enable force_unwrapping

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
                            fatalError(
                                "Aurora.networking.SSLPinningUnavailable"
                            )
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
