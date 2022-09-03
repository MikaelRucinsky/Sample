//
//  SampleError.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import Foundation

/// An error Sample returns
public struct SampleError: Swift.Error, Equatable, LocalizedError {
    
    /// The error code description
    public var errorDescription: String?
    public var recoverySuggestion: String?
    
    public init(errorDescription: String?, recoverySuggestion: String? = nil) {
        self.errorDescription = errorDescription
        self.recoverySuggestion = recoverySuggestion
    }
    
    // MARK: - General errors
    
    /// When an unknown or unexpected error has happened
    public static let general = SampleError(errorDescription: "An unknown or unexpected error has happened")
    
    /// An error if URL has wrong format
    public static let badURL = SampleError(errorDescription: "URL has invalid format")
    
    /// An error if any value throws an error during encoding.
    public static let invalidDecoding = SampleError(errorDescription: "Data decoding has been invalid")
    
    public static func unacceptableStatusCode(_ statusCode: Int) -> SampleError {
        SampleError(errorDescription: "Response status code was unacceptable: \(statusCode).")
    }
}
