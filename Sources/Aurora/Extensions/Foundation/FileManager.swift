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

public extension FileManager {
    /// The app's `Document` directory in the file system.
    /// - Returns: URL.
    @objc static var document: URL {
        self.default.document
    }

    /// The app's `Document` directory in the file system.
    /// - Returns: URL.
    @objc var document: URL {
        #if os(OSX)
        // On OS X it is, so put files in Application Support. If we aren't running
        // in a sandbox, put it in a subdirectory based on the bundle identifier
        // to avoid accidentally sharing files between applications
        var defaultURL = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first

        if ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] == nil {
            var identifier = Bundle.main.bundleIdentifier
            if identifier?.isEmpty ?? false {
                identifier = Bundle.main.executableURL?.lastPathComponent
            }
            defaultURL = defaultURL?.appendingPathComponent(identifier ?? "", isDirectory: true)
        }
        return defaultURL ?? URL(fileURLWithPath: "")
        #else
        // On iOS the Documents directory isn't user-visible, so put files there
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        #endif
    }

    /// Does the directory exists at path?
    /// - Parameter path: a file URL where we will check for an directory.
    @objc static func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}

// MARK: - Create
public extension FileManager {
    /// Create a new directory at the specified URL.
    /// - Parameter directoryURL: a file URL where the directory will be created.
    /// - Note: if an error occurred during the creation, an error will be throw.
    static func createDirectory(at directoryURL: URL) throws {
        try self.default.createDirectory(at: directoryURL)
    }

    /// Create a new directory at the specified URL.
    /// - Parameter directoryURL: a file URL where the directory will be created.
    /// - Note: if an error occurred during the creation, an error will be throw.
    @objc
    func createDirectory(at directoryUrl: URL) throws {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let fileExists = fileManager.fileExists(
            atPath: directoryUrl.path,
            isDirectory: &isDir
        )

        if fileExists == false || isDir.boolValue != false {
            try fileManager.createDirectory(
                at: directoryUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
}

// MARK: - Remove
public extension FileManager {

    /// Remove all the files found in the `Temporary` app directory.
    /// - Parameter path: a parameter that's not used, it will be removed in a future version.
    /// - Note: if an error occurred during the creation, an error will be throw.
    static func removeTemporaryFiles(at path: String) throws {
        try self.default.removeTemporaryFiles()
    }

    /// Remove all the temporary files found in the `Temporary` app directory.
    /// - Note: if an error occurred during the creation, an error will be throw.
    func removeTemporaryFiles() throws {
        let contents = try contentsOfDirectory(atPath: NSTemporaryDirectory())
        for file in contents {
            try removeItem(atPath: NSTemporaryDirectory() + file)
        }
    }

    /// Remove all the files files found in the `Document` app directory.
    /// - Parameter path: a parameter that's not used, it will be removed in a future version.
    /// - Note: if an error occurred during the creation, an error will be throw.
    static func removeDocumentFiles(at path: String) throws {
        try self.default.removeDocumentFiles()
    }

    /// Remove all the files files found in the `Document` app directory.
    /// - Note: if an error occurred during the creation, an error will be throw.
    func removeDocumentFiles() throws {
        let documentPath = document.path
        let contents = try contentsOfDirectory(atPath: documentPath)
        for file in contents {
            try removeItem(atPath: documentPath + file)
        }
    }
}
