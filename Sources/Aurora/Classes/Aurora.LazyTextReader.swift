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

/// Lazily reads text files.
public class LazyTextReader: Sequence, IteratorProtocol {
    public let encoding: String.Encoding
    public let chunkSize: Int
    var fileHandle: FileHandle?
    let delimData: Data
    var buffer: Data
    var atEOF: Bool

    public init?(url: URL, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        guard let fileHandle = try? FileHandle(forReadingFrom: url),
              let delimData = delimiter.data(using: encoding) else {
            return nil
        }

        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEOF = false
    }

    deinit {
        self.close()
    }

    /// Return next line, or nil on end of file.
    public func next() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")
        guard let fileHandle = fileHandle else { return nil }

        // Read data chunks from file until a line delimiter is found:
        while !atEOF {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(
                    data: buffer.subdata(in: 0..<range.lowerBound),
                    encoding: encoding
                )

                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }

            let tmpData = fileHandle.readData(ofLength: chunkSize)

            if !tmpData.isEmpty {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEOF = true
                if !buffer.isEmpty {
                    // Buffer contains last line in file
                    // (not terminated by delimiter).
                    let line = String(
                        data: buffer as Data,
                        encoding: encoding
                    )
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }

    /// Start reading from the beginning of file.
    public func rewind() {
        guard let fileHandle = fileHandle else { return }

        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEOF = false
    }

    /// Close the underlying file.
    /// No reading must be done after calling this method.
    public func close() {
        if let handle = fileHandle {
            handle.closeFile()
         }

        fileHandle = nil
    }
}
