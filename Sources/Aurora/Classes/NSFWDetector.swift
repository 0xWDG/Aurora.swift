//
//  NSFWDetector.swift
//  Aurora
//
//  Created by Wesley de Groot on 12/06/2020.
//  Original Created by Michael Berg on 13.08.18.
//

import Foundation

#if canImport(CoreML) && canImport(Vision)
import CoreML
import Vision

/// <#Description#>
///
/// Example
///
///     NSFWDetector.shared.check(image: image) { result in
///        switch result {
///        case .error:
///            print("Detection failed")
///        case let .success(nsfwConfidence: confidence):
///            print(String(format: "%.1f %% NSFW", confidence * 100.0))
///        }
///    }
@available(macOS 10.14, *)
@available(iOS 12.0, *)
public class NSFWDetector {
    /// Singleton for NSFWDetector
    public static let shared = NSFWDetector()
    
    /// Core ML model used with Vision requests.
    private let model: VNCoreMLModel
    
    /// Initialize
    public required init() {
        var NSFWModel: MLModel?
        
        #if swift(>=5.3)
        guard let modelURL = Bundle.module.url(forResource: "NSFW", withExtension: "mlmodel") else {
            fatalError("No model found.")
        }
        #else
        guard let modelURL = Bundle.main.url(forResource: "NSFW", withExtension: "mlmodel") else {
            fatalError("No model found.")
        }
        #endif
        
        do {
            let config = MLModelConfiguration().configure {
                $0.computeUnits = .all
            }
            
            NSFWModel = try MLModel(contentsOf: modelURL, configuration: config)
        } catch {
            fatalError("Error loading model: \(error)")
        }
        
        guard let model = try? VNCoreMLModel(for: NSFWModel.unwrap()) else {
            fatalError("NSFW should always be a valid model")
        }
        
        self.model = model
    }
    
    /// The Result of an NSFW Detection
    ///
    /// - error: Detection was not successful
    /// - success: Detection was successful. `nsfwConfidence`: 0.0 for safe content - 1.0 for hardcore porn ;)
    public enum DetectionResult {
        case error(Error)
        case success(nsfwConfidence: Float)
    }
    
    /// Check the image
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - completion: <#completion description#>
    public func check(image: Image, completion: @escaping (_ result: DetectionResult) -> Void) {
        // Create a requestHandler for the image
        let requestHandler: VNImageRequestHandler?
        
        /// <#Description#>
        #if os(iOS)
        if let cgImage = image.cgImage {
            requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        } else if let ciImage = image.ciImage {
            requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        } else {
            requestHandler = nil
        }
        #endif
        #if os(macOS)
        //swiftlint:ignore:next force_unwrap
        let cgImage = image.cgImage as! CGImage
        
        requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        #endif
        
        self.check(requestHandler, completion: completion)
    }
    
    /// Check the image (using pixels)
    /// - Parameters:
    ///   - cvPixelbuffer: <#cvPixelbuffer description#>
    ///   - completion: <#completion description#>
    public func check(cvPixelbuffer: CVPixelBuffer, completion: @escaping (_ result: DetectionResult) -> Void) {
        /// <#Description#>
        let requestHandler = VNImageRequestHandler(
            cvPixelBuffer: cvPixelbuffer,
            options: [:]
        )
        
        self.check(requestHandler, completion: completion)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - requestHandler: <#requestHandler description#>
    ///   - completion: <#completion description#>
    func check(_ requestHandler: VNImageRequestHandler?, completion: @escaping (_ result: DetectionResult) -> Void) {
        guard let requestHandler = requestHandler else {
            completion(
                .error(
                    NSError(
                        domain: "either cgImage or ciImage must be set inside of UIImage",
                        code: 0,
                        userInfo: nil
                    )
                )
            )
            return
        }
        
        /// The request that handles the detection completion
        let request = VNCoreMLRequest(
            model: self.model,
            completionHandler: { (request, error) in
                guard let observations = request.results as? [VNClassificationObservation],
                    let observation = observations.first(where: { $0.identifier == "NSFW" }) else {
                        completion(
                            .error(
                                NSError(
                                    domain: "Detection failed: No NSFW Observation found",
                                    code: 0,
                                    userInfo: nil
                                )
                            )
                        )
                        
                        return
                }
                
                completion(
                    .success(
                        nsfwConfidence: observation.confidence
                    )
                )
        })
        
        /// Start the actual detection
        do {
            try requestHandler.perform([request])
        } catch {
            completion(
                .error(
                    NSError(
                        domain: "Detection failed: No NSFW Observation found",
                        code: 0,
                        userInfo: nil
                    )
                )
            )
        }
    }
}
#endif
